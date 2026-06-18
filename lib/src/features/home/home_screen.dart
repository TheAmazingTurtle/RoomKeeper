import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/formatters.dart';
import '../../shared/roomkeeper_ui.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider).value ?? const [];
    final foods = ref.watch(foodProvider).value ?? const [];
    final reminders = ref.watch(activeRemindersProvider).value ?? const [];
    final laundry = ref.watch(laundryProvider).value ?? const [];
    final payments = ref.watch(paymentsProvider).value ?? const [];
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    final upcoming = reminders
        .where(
          (reminder) =>
              reminder.ownerType != 'todo' &&
              reminder.scheduledAt.isBefore(soon),
        )
        .toList();
    final foodAttention = foods
        .map((food) => _FoodAttention.from(food, soon))
        .where((attention) => attention.needsAttention)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('RoomKeeper')),
      body: RoomKeeperPage(
        children: [
          Text(
            'Today at home',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'A quick check of your inventory, food, laundry, and bills.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.sizeOf(context).width >= 720 ? 4 : 2,
            childAspectRatio: 1.35,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _MetricCard(
                icon: Icons.inventory_2_outlined,
                label: 'Inventory',
                value: '${inventory.length}',
                color: const Color(0xFF2563EB),
                onTap: () => context.go('/inventory'),
              ),
              _MetricCard(
                icon: Icons.kitchen_outlined,
                label: 'Food items',
                value: '${foods.length}',
                color: const Color(0xFFF97316),
                onTap: () => context.go('/food'),
              ),
              _MetricCard(
                icon: Icons.local_laundry_service_outlined,
                label: 'Laundry',
                value: '${laundry.length}',
                color: const Color(0xFF16A34A),
                onTap: () => context.go('/laundry'),
              ),
              _MetricCard(
                icon: Icons.receipt_long_outlined,
                label: 'Bills',
                value: '${payments.length}',
                color: const Color(0xFF9333EA),
                onTap: () => context.go('/bills'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          RoomKeeperSection(
            title: 'Upcoming reminders',
            subtitle: 'Due in the next 7 days',
            emptyIcon: Icons.notifications_none_outlined,
            emptyTitle: 'Nothing due soon',
            emptyBody: 'Your next week is clear for now.',
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
          RoomKeeperSection(
            title: 'Food to check',
            subtitle: 'Expiring soon or running low',
            emptyIcon: Icons.kitchen_outlined,
            emptyTitle: 'Food looks okay',
            emptyBody: 'No low-stock or expiring food needs attention.',
            children: foodAttention
                .take(6)
                .map(
                  (attention) => _FoodAttentionTile(
                    attention: attention,
                    onTap: () => context.go('/food'),
                  ),
                )
                .toList(),
          ),
          RoomKeeperSection(
            title: 'Recent logs',
            subtitle: 'Latest laundry and bill activity',
            emptyIcon: Icons.history_outlined,
            emptyTitle: 'No logs yet',
            emptyBody: 'Laundry and payment records will show here.',
            children: [
              if (laundry.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.local_laundry_service_outlined),
                  title: const Text('Last laundry'),
                  subtitle: Text(formatDate(laundry.first.completedAt)),
                  trailing: laundry.first.nextReminderAt == null
                      ? null
                      : Text(formatDate(laundry.first.nextReminderAt)),
                  onTap: () => context.go('/laundry'),
                ),
              if (payments.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text('Last ${payments.first.billType} payment'),
                  subtitle: Text(
                    '${payments.first.billingMonth} - ${formatDate(payments.first.paidAt)}',
                  ),
                  trailing: Text(formatPesoCents(payments.first.amountCents)),
                  onTap: () => context.go('/bills'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodAttention {
  const _FoodAttention({
    required this.food,
    required this.isExpiring,
    required this.isLowStock,
  });

  factory _FoodAttention.from(FoodStock food, DateTime soon) {
    return _FoodAttention(
      food: food,
      isExpiring:
          food.expiryDate != null &&
          food.expiryDate!.isBefore(soon.add(const Duration(days: 1))),
      isLowStock:
          food.lowStockThreshold != null &&
          food.quantity <= food.lowStockThreshold!,
    );
  }

  final FoodStock food;
  final bool isExpiring;
  final bool isLowStock;

  bool get needsAttention => isExpiring || isLowStock;
}

class _FoodAttentionTile extends StatelessWidget {
  const _FoodAttentionTile({required this.attention, required this.onTap});

  final _FoodAttention attention;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final food = attention.food;
    return ListTile(
      leading: Icon(
        attention.isExpiring
            ? Icons.event_busy_outlined
            : Icons.production_quantity_limits,
      ),
      title: Text(food.name),
      subtitle: Text(
        [
          if (attention.isExpiring) 'Expires ${formatDate(food.expiryDate)}',
          if (attention.isLowStock)
            '${compactQuantity(food.quantity)} ${food.unit} left',
        ].join(' • '),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

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
          padding: const EdgeInsets.all(16),
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
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
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
        label: Text(isOverdue ? 'Overdue' : 'This week'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
