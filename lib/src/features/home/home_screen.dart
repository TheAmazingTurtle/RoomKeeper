import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/formatters.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider).value ?? const [];
    final foods = ref.watch(foodProvider).value ?? const [];
    final reminders = ref.watch(activeRemindersProvider).value ?? const [];
    final todos = ref.watch(todosProvider).value ?? const [];
    final laundry = ref.watch(laundryProvider).value ?? const [];
    final payments = ref.watch(paymentsProvider).value ?? const [];
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    final upcoming = reminders
        .where((reminder) => reminder.scheduledAt.isBefore(soon))
        .toList();
    final expiringFoods = foods
        .where(
          (food) =>
              food.expiryDate != null &&
              food.expiryDate!.isBefore(soon.add(const Duration(days: 1))),
        )
        .toList();
    final lowStockFoods = foods
        .where(
          (food) =>
              food.lowStockThreshold != null &&
              food.quantity <= food.lowStockThreshold!,
        )
        .toList();
    final openTodos = todos.where((todo) => !todo.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RoomKeeper'),
        actions: [
          IconButton(
            tooltip: 'Save backup to file',
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: () => _saveBackup(context, ref),
          ),
          PopupMenuButton<_BackupAction>(
            tooltip: 'Backup options',
            onSelected: (action) {
              switch (action) {
                case _BackupAction.share:
                  _shareBackup(context, ref);
                case _BackupAction.import:
                  _importBackup(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _BackupAction.share,
                child: ListTile(
                  leading: Icon(Icons.ios_share),
                  title: Text('Share backup'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: _BackupAction.import,
                child: ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text('Import backup'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Room check', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.sizeOf(context).width >= 720 ? 4 : 2,
            childAspectRatio: 1.55,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _MetricCard(
                icon: Icons.inventory_2_outlined,
                label: 'Room items',
                value: '${inventory.length}',
                color: const Color(0xFF2563EB),
                onTap: () => context.go('/inventory'),
              ),
              _MetricCard(
                icon: Icons.kitchen_outlined,
                label: 'Food stocked',
                value: '${foods.length}',
                color: const Color(0xFFF97316),
                onTap: () => context.go('/food'),
              ),
              _MetricCard(
                icon: Icons.check_circle_outline,
                label: 'Open tasks',
                value: '${openTodos.length}',
                color: const Color(0xFF16A34A),
                onTap: () => context.go('/tasks'),
              ),
              _MetricCard(
                icon: Icons.notifications_active_outlined,
                label: 'Due soon',
                value: '${upcoming.length}',
                color: const Color(0xFF9333EA),
                onTap: () => context.go('/tasks'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _StatusSection(
            title: 'Upcoming reminders',
            emptyText: 'No reminders due in the next 7 days.',
            children: upcoming
                .take(4)
                .map(
                  (reminder) => _ReminderTile(
                    reminder: reminder,
                    isOverdue: reminder.scheduledAt.isBefore(now),
                  ),
                )
                .toList(),
          ),
          _StatusSection(
            title: 'Food attention',
            emptyText: 'No expiring or low-stock food right now.',
            children: [
              ...expiringFoods
                  .take(3)
                  .map(
                    (food) => ListTile(
                      leading: const Icon(Icons.event_busy_outlined),
                      title: Text(food.name),
                      subtitle: Text('Expires ${formatDate(food.expiryDate)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/food'),
                    ),
                  ),
              ...lowStockFoods
                  .take(3)
                  .map(
                    (food) => ListTile(
                      leading: const Icon(Icons.production_quantity_limits),
                      title: Text(food.name),
                      subtitle: Text(
                        '${compactQuantity(food.quantity)} ${food.unit} left',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/food'),
                    ),
                  ),
            ],
          ),
          _StatusSection(
            title: 'Recent logs',
            emptyText: 'Laundry and payment logs will appear here.',
            children: [
              if (laundry.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.local_laundry_service_outlined),
                  title: const Text('Last laundry'),
                  subtitle: Text(formatDate(laundry.first.completedAt)),
                  trailing: laundry.first.nextReminderAt == null
                      ? null
                      : Text(formatDate(laundry.first.nextReminderAt)),
                  onTap: () => context.go('/tasks'),
                ),
              if (payments.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text('Last ${payments.first.billType} payment'),
                  subtitle: Text(
                    '${payments.first.billingMonth} - ${formatDate(payments.first.paidAt)}',
                  ),
                  trailing: Text(formatPesoCents(payments.first.amountCents)),
                  onTap: () => context.go('/tasks'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveBackup(BuildContext context, WidgetRef ref) async {
    try {
      final file = await ref.read(backupServiceProvider).saveBackupFile();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup saved to ${file.path}')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup save failed: $error')));
      }
    }
  }

  Future<void> _shareBackup(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupServiceProvider).shareBackupFile();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup prepared for sharing.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup export failed: $error')));
      }
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    try {
      final imported = await ref.read(backupServiceProvider).importFromPicker();
      if (imported) {
        await ref.read(reminderServiceProvider).rescheduleActiveReminders();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(imported ? 'Backup restored.' : 'Import cancelled.'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup import failed: $error')));
      }
    }
  }
}

enum _BackupAction { share, import }

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.09),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({
    required this.title,
    required this.emptyText,
    required this.children,
  });

  final String title;
  final String emptyText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: children.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(emptyText),
                  )
                : Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.isOverdue});

  final Reminder reminder;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isOverdue ? Icons.warning_amber_rounded : Icons.notifications_outlined,
        color: isOverdue ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(reminder.title),
      subtitle: Text(formatDateTime(reminder.scheduledAt)),
      trailing: Chip(
        label: Text(isOverdue ? 'Overdue' : 'Soon'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
