import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/delete_confirmation.dart';
import '../../shared/formatters.dart';

class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areas = ref.watch(areasProvider).value ?? const [];
    final foods = ref.watch(foodProvider).value ?? const [];
    final areasById = {for (final area in areas) area.id: area};

    return Scaffold(
      appBar: AppBar(title: const Text('Food stock')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await showDialog<bool>(
            context: context,
            builder: (_) => _FoodDialog(areas: areas),
          );
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Food item added.')));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Food'),
      ),
      body: foods.isEmpty
          ? const _EmptyFood()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemBuilder: (context, index) {
                final food = foods[index];
                return _FoodTile(
                  food: food,
                  area: areasById[food.areaId],
                  areas: areas,
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemCount: foods.length,
            ),
    );
  }
}

class _FoodTile extends ConsumerWidget {
  const _FoodTile({
    required this.food,
    required this.area,
    required this.areas,
  });

  final FoodStock food;
  final Area? area;
  final List<Area> areas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final expiresSoon =
        food.expiryDate != null &&
        food.expiryDate!.isBefore(now.add(const Duration(days: 7)));
    final expired = food.expiryDate != null && food.expiryDate!.isBefore(now);
    final lowStock =
        food.lowStockThreshold != null &&
        food.quantity <= food.lowStockThreshold!;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: expired
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(expired ? Icons.warning_amber_rounded : Icons.kitchen),
        ),
        title: Text(food.name),
        onTap: () => _showFoodDetails(context, food, area),
        subtitle: Text(
          [
            '${compactQuantity(food.quantity)} ${food.unit}',
            food.category,
            if (area != null) area!.name,
            if (food.expiryDate != null) 'exp ${formatDate(food.expiryDate)}',
            if (food.notes != null) food.notes!,
          ].join(' - '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            if (expiresSoon)
              Chip(
                label: Text(expired ? 'Expired' : 'Soon'),
                visualDensity: VisualDensity.compact,
              ),
            if (lowStock)
              const Chip(
                label: Text('Low'),
                visualDensity: VisualDensity.compact,
              ),
            IconButton(
              tooltip: 'View food details',
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showFoodDetails(context, food, area),
            ),
            IconButton(
              tooltip: 'Edit food',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final saved = await showDialog<bool>(
                  context: context,
                  builder: (_) => _FoodDialog(areas: areas, food: food),
                );
                if (saved == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food item updated.')),
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Delete food',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirmed = await confirmDelete(
                  context: context,
                  title: 'Delete food item?',
                  itemName: food.name,
                );
                if (!confirmed) return;
                await ref.read(repositoryProvider).deleteFoodStock(food.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name} deleted.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetails(BuildContext context, FoodStock food, Area? area) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  label: 'Quantity',
                  value: compactQuantity(food.quantity),
                ),
                _DetailRow(label: 'Unit', value: food.unit),
                _DetailRow(label: 'Category', value: food.category),
                _DetailRow(
                  label: 'Storage area',
                  value: area?.name ?? 'Unassigned',
                ),
                _DetailRow(
                  label: 'Expiry date',
                  value: formatDate(food.expiryDate),
                ),
                _DetailRow(
                  label: 'Low-stock threshold',
                  value: food.lowStockThreshold == null
                      ? 'None'
                      : compactQuantity(food.lowStockThreshold!),
                ),
                _DetailRow(label: 'Notes', value: food.notes ?? 'None'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          SelectableText(value),
        ],
      ),
    );
  }
}

class _FoodDialog extends ConsumerStatefulWidget {
  const _FoodDialog({required this.areas, this.food});

  final List<Area> areas;
  final FoodStock? food;

  @override
  ConsumerState<_FoodDialog> createState() => _FoodDialogState();
}

class _FoodDialogState extends ConsumerState<_FoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Pantry');
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'pcs');
  final _lowStockController = TextEditingController();
  final _notesController = TextEditingController();
  int? _areaId;
  DateTime? _expiryDate;
  bool get _isEditing => widget.food != null;

  @override
  void initState() {
    super.initState();
    final food = widget.food;
    if (food != null) {
      _nameController.text = food.name;
      _categoryController.text = food.category;
      _quantityController.text = food.quantity.toString();
      _unitController.text = food.unit;
      _lowStockController.text = food.lowStockThreshold?.toString() ?? '';
      _notesController.text = food.notes ?? '';
      _areaId = food.areaId;
      _expiryDate = food.expiryDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _lowStockController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit food' : 'Add food'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Food name'),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _areaId,
                decoration: const InputDecoration(labelText: 'Storage area'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Unassigned'),
                  ),
                  ...widget.areas.map(
                    (area) => DropdownMenuItem<int?>(
                      value: area.id,
                      child: Text(area.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _areaId = value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _positiveNumberValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(labelText: 'Unit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lowStockController,
                decoration: const InputDecoration(
                  labelText: 'Low-stock threshold',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _optionalPositiveNumberValidator,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: const Text('Expiry date'),
                subtitle: Text(formatDate(_expiryDate)),
                trailing: const Icon(Icons.edit_calendar_outlined),
                onTap: _pickExpiry,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
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
        FilledButton(
          onPressed: _save,
          child: Text(_isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }

  String? _positiveNumberValidator(String? value) {
    final parsed = parseFlexibleNumber(value ?? '');
    return parsed == null || !parsed.isFinite || parsed <= 0
        ? 'Use a positive number'
        : null;
  }

  String? _optionalPositiveNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = parseFlexibleNumber(value);
    return parsed == null || !parsed.isFinite || parsed <= 0
        ? 'Use a positive number or leave blank'
        : null;
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (selected != null) {
      setState(() => _expiryDate = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final lowStock = _lowStockController.text.trim().isEmpty
        ? null
        : parseFlexibleNumber(_lowStockController.text);
    final food = widget.food;
    if (food == null) {
      await ref
          .read(repositoryProvider)
          .addFoodStock(
            name: _nameController.text,
            areaId: _areaId,
            category: _categoryController.text,
            quantity: parseFlexibleNumber(_quantityController.text)!,
            unit: _unitController.text,
            expiryDate: _expiryDate,
            lowStockThreshold: lowStock,
            notes: _notesController.text,
          );
    } else {
      await ref
          .read(repositoryProvider)
          .updateFoodStock(
            food.copyWith(
              name: _nameController.text.trim(),
              areaId: Value<int?>(_areaId),
              category: _categoryController.text.trim().isEmpty
                  ? 'Pantry'
                  : _categoryController.text.trim(),
              quantity: parseFlexibleNumber(_quantityController.text)!,
              unit: _unitController.text.trim().isEmpty
                  ? 'pcs'
                  : _unitController.text.trim(),
              expiryDate: Value<DateTime?>(_expiryDate),
              lowStockThreshold: Value<double?>(lowStock),
              notes: Value<String?>(
                _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
              ),
              updatedAt: DateTime.now(),
            ),
          );
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}

class _EmptyFood extends StatelessWidget {
  const _EmptyFood();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.kitchen_outlined,
              size: 54,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Stock your first food item',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Track quantity, location, expiry, and low-stock status.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
