import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/delete_confirmation.dart';
import '../../shared/formatters.dart';
import '../../shared/roomkeeper_ui.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(laundryBasketProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Laundry')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _LaundryItemDialog(),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add item'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Reset basket',
                icon: const Icon(Icons.restart_alt),
                onPressed: items.isEmpty
                    ? null
                    : () async {
                        await ref
                            .read(repositoryProvider)
                            .resetLaundryBasketCounts();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Laundry basket reset.'),
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const _EmptyMessage(
              icon: Icons.local_laundry_service_outlined,
              title: 'No laundry counters yet',
              body:
                  'Laundry basket counters will appear here after app startup.',
            )
          else
            RoomKeeperCard(
              child: Column(
                children: items
                    .map((item) => _LaundryBasketTile(item: item))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _LaundryBasketTile extends ConsumerWidget {
  const _LaundryBasketTile({required this.item});

  final LaundryBasketItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ListTile(
      leading: const Icon(Icons.local_laundry_service_outlined),
      title: Text(item.name),
      subtitle: item.isDefault ? const Text('Everyday clothes') : null,
      trailing: QuantityStepper(
        value: '${item.count}',
        decrementTooltip: 'Remove one ${item.name}',
        incrementTooltip: 'Add one ${item.name}',
        canDecrement: item.count > 0,
        onDecrement: () =>
            ref.read(repositoryProvider).changeLaundryBasketCount(item, -1),
        onIncrement: () =>
            ref.read(repositoryProvider).changeLaundryBasketCount(item, 1),
      ),
    );
    if (item.isDefault) return tile;
    return Dismissible(
      key: ValueKey('laundry-basket-${item.id}'),
      direction: DismissDirection.endToStart,
      background: const DeleteSwipeBackground(),
      confirmDismiss: (_) => confirmDelete(
        context: context,
        title: 'Delete laundry item?',
        itemName: item.name,
      ),
      onDismissed: (_) async {
        await ref.read(repositoryProvider).deleteLaundryBasketItem(item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${item.name} deleted.')));
        }
      },
      child: tile,
    );
  }
}

class _LaundryItemDialog extends ConsumerStatefulWidget {
  const _LaundryItemDialog();

  @override
  ConsumerState<_LaundryItemDialog> createState() => _LaundryItemDialogState();
}

class _LaundryItemDialogState extends ConsumerState<_LaundryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add laundry item'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Item type',
            hintText: 'Hanky, pillow case, bed sheet',
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Add item')),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(repositoryProvider)
        .addLaundryBasketItem(_nameController.text);
    if (mounted) Navigator.pop(context);
  }
}

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Bills')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          FilledButton.icon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const _PaymentDialog(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add payment'),
          ),
          const SizedBox(height: 12),
          if (payments.isEmpty)
            const _EmptyMessage(
              icon: Icons.receipt_long_outlined,
              title: 'No payment logs yet',
              body:
                  'Track rent and utilities, then set reminders for the next bill.',
            )
          else
            RoomKeeperCard(
              child: Column(
                children: payments
                    .map(
                      (payment) => ListTile(
                        leading: const Icon(Icons.receipt_long_outlined),
                        title: Text(
                          '${_billTypeLabel(payment.billType)} • ${payment.billingMonth}',
                        ),
                        subtitle: Text(
                          [
                            formatPesoCents(payment.amountCents),
                            'Paid ${formatDate(payment.paidAt)}',
                            if (payment.nextReminderAt != null)
                              'Next reminder ${formatDateTime(payment.nextReminderAt)}',
                            if (payment.notes != null) payment.notes!,
                          ].join(' • '),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              tooltip: 'Edit payment log',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (_) =>
                                    _PaymentDialog(payment: payment),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete payment log',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await confirmDelete(
                                  context: context,
                                  title: 'Delete payment log?',
                                  itemName:
                                      '${payment.billType} ${payment.billingMonth}',
                                );
                                if (!confirmed) return;
                                await ref
                                    .read(reminderServiceProvider)
                                    .cancelOwnerReminders(
                                      ownerType: 'payment',
                                      ownerId: payment.id,
                                    );
                                await ref
                                    .read(repositoryProvider)
                                    .deletePaymentLog(payment.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment log deleted.'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentDialog extends ConsumerStatefulWidget {
  const _PaymentDialog({this.payment});

  final PaymentLog? payment;

  @override
  ConsumerState<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<_PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _billType = 'rent';
  DateTime _billingMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _paidAt = DateTime.now();
  DateTime? _nextReminderAt = DateTime.now().add(const Duration(days: 30));

  bool get _isEditing => widget.payment != null;

  @override
  void initState() {
    super.initState();
    final payment = widget.payment;
    if (payment == null) return;
    _billType = payment.billType;
    _billingMonth = _parseBillingMonth(payment.billingMonth);
    _paidAt = payment.paidAt;
    _nextReminderAt = payment.nextReminderAt;
    _amountController.text = (payment.amountCents / 100).toStringAsFixed(2);
    _notesController.text = payment.notes ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit payment' : 'Add payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _billType,
                decoration: const InputDecoration(labelText: 'Bill type'),
                items: const [
                  DropdownMenuItem(value: 'rent', child: Text('Rent')),
                  DropdownMenuItem(
                    value: 'electricity',
                    child: Text('Electricity'),
                  ),
                  DropdownMenuItem(value: 'water', child: Text('Water')),
                  DropdownMenuItem(value: 'internet', child: Text('Internet')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) =>
                    setState(() => _billType = value ?? _billType),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount paid',
                  prefixText: 'PHP ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final parsed = parseFlexibleNumber(value ?? '');
                  return parsed == null || !parsed.isFinite || parsed <= 0
                      ? 'Enter a positive amount'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              _DateActionTile(
                icon: Icons.calendar_month_outlined,
                title: 'Billing month',
                value: monthFormat.format(_billingMonth),
                onTap: () async {
                  final picked = await _pickDate(context, _billingMonth);
                  if (picked != null) {
                    setState(() {
                      _billingMonth = DateTime(picked.year, picked.month);
                    });
                  }
                },
              ),
              _DateActionTile(
                icon: Icons.event_available_outlined,
                title: 'Paid date',
                value: formatDate(_paidAt),
                onTap: () async {
                  final picked = await _pickDate(context, _paidAt);
                  if (picked != null) setState(() => _paidAt = picked);
                },
              ),
              _DateActionTile(
                icon: Icons.notifications_outlined,
                title: 'Next reminder',
                value: formatDateTime(_nextReminderAt),
                onTap: () async {
                  final picked = await _pickDateTime(
                    context,
                    _nextReminderAt ??
                        DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => _nextReminderAt = picked);
                },
                onClear: _nextReminderAt == null
                    ? null
                    : () => setState(() => _nextReminderAt = null),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Receipt number, shared amount, or notes',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save payment')),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final billingMonth = monthFormat.format(_billingMonth);
    final amountCents = parsePesoToCents(_amountController.text);
    final id =
        widget.payment?.id ??
        await ref
            .read(repositoryProvider)
            .addPaymentLog(
              billType: _billType,
              billingMonth: billingMonth,
              paidAt: _paidAt,
              amountCents: amountCents,
              nextReminderAt: _nextReminderAt,
              notes: _notesController.text,
            );
    if (_isEditing) {
      await ref
          .read(repositoryProvider)
          .updatePaymentLog(
            id: id,
            billType: _billType,
            billingMonth: billingMonth,
            paidAt: _paidAt,
            amountCents: amountCents,
            nextReminderAt: _nextReminderAt,
            notes: _notesController.text,
          );
    }
    await ref
        .read(reminderServiceProvider)
        .rescheduleOwnerReminder(
          ownerType: 'payment',
          ownerId: id,
          title: 'Pay $_billType',
          body: 'Billing month $billingMonth',
          scheduledAt: _nextReminderAt,
        );
    if (mounted) Navigator.pop(context);
  }
}

DateTime _parseBillingMonth(String value) {
  final parts = value.split('-');
  final year = int.tryParse(parts.first);
  final month = parts.length > 1 ? int.tryParse(parts[1]) : null;
  if (year == null || month == null) {
    return DateTime(DateTime.now().year, DateTime.now().month);
  }
  return DateTime(year, month);
}

class _DateActionTile extends StatelessWidget {
  const _DateActionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: Wrap(
        children: [
          if (onClear != null)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            ),
          IconButton(
            tooltip: 'Pick date',
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: onTap,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

String _billTypeLabel(String value) {
  return switch (value) {
    'rent' => 'Rent',
    'electricity' => 'Electricity',
    'water' => 'Water',
    'internet' => 'Internet',
    _ => 'Other',
  };
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return CompactEmptyState(icon: icon, title: title, body: body);
  }
}

Future<DateTime?> _pickDate(BuildContext context, DateTime? current) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: current ?? now,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 10),
  );
}

Future<DateTime?> _pickDateTime(BuildContext context, DateTime current) async {
  final date = await _pickDate(context, current);
  if (date == null || !context.mounted) {
    return null;
  }
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(current),
  );
  if (time == null) {
    return null;
  }
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
