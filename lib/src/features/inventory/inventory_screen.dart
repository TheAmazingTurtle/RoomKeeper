import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/delete_confirmation.dart';
import '../../shared/roomkeeper_ui.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areas = ref.watch(areasProvider).value ?? const [];
    final items = ref.watch(inventoryProvider).value ?? const [];
    final areasById = {for (final area in areas) area.id: area};
    final grouped = <String, List<InventoryItem>>{};
    for (final item in items) {
      final areaName = areasById[item.areaId]?.name ?? 'Unassigned';
      grouped.putIfAbsent(areaName, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room items'),
        actions: [
          IconButton(
            tooltip: 'Add area',
            icon: const Icon(Icons.add_location_alt_outlined),
            onPressed: () => _showAreaDialog(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await showDialog<bool>(
            context: context,
            builder: (_) => _InventoryItemDialog(areas: areas),
          );
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Room item added.')));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: items.isEmpty
          ? const _EmptyInventory()
          : RoomKeeperPage(
              bottomPadding: 96,
              children: grouped.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: entry.key,
                        subtitle:
                            '${entry.value.length} ${entry.value.length == 1 ? 'item' : 'items'}',
                      ),
                      RoomKeeperCard(
                        child: Column(
                          children: entry.value
                              .map(
                                (item) => _InventoryTile(
                                  item: item,
                                  area: areasById[item.areaId],
                                  areas: areas,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Future<void> _showAreaDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add storage area'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Area name',
              hintText: 'Bed shelf, desk drawer, cabinet',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add area'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == null || result.trim().isEmpty) {
      return;
    }
    await ref.read(repositoryProvider).addArea(name: result);
  }
}

class _InventoryTile extends ConsumerWidget {
  const _InventoryTile({
    required this.item,
    required this.area,
    required this.areas,
  });

  final InventoryItem item;
  final Area? area;
  final List<Area> areas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('inventory-${item.id}'),
      direction: DismissDirection.endToStart,
      background: const DeleteSwipeBackground(),
      confirmDismiss: (_) => confirmDelete(
        context: context,
        title: 'Delete room item?',
        itemName: item.name,
      ),
      onDismissed: (_) async {
        await ref.read(repositoryProvider).deleteInventoryItem(item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${item.name} deleted.')));
        }
      },
      child: ListTile(
        leading: _ItemPhoto(path: item.photoPath),
        title: Text(item.name),
        onTap: () => _showInventoryDetails(context, item, area),
        subtitle: Text(
          [
            if (area != null) area!.name,
            item.condition,
            if (item.notes != null) item.notes!,
          ].join(' - '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: QuantityStepper(
          value: '${item.quantity}',
          decrementTooltip: 'Remove one ${item.name}',
          incrementTooltip: 'Add one ${item.name}',
          canDecrement: item.quantity > 0,
          onDecrement: () =>
              ref.read(repositoryProvider).changeInventoryQuantity(item, -1),
          onIncrement: () =>
              ref.read(repositoryProvider).changeInventoryQuantity(item, 1),
        ),
      ),
    );
  }

  void _showInventoryDetails(
    BuildContext context,
    InventoryItem item,
    Area? area,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Area', value: area?.name ?? 'Unassigned'),
                _DetailRow(label: 'Quantity', value: item.quantity.toString()),
                _DetailRow(label: 'Condition', value: item.condition),
                _DetailRow(label: 'Photo', value: item.photoPath ?? 'None'),
                _DetailRow(label: 'Notes', value: item.notes ?? 'None'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final saved = await showDialog<bool>(
                  context: context,
                  builder: (_) =>
                      _InventoryItemDialog(areas: areas, item: item),
                );
                if (saved == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room item updated.')),
                  );
                }
              },
              child: const Text('Edit'),
            ),
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

class _ItemPhoto extends StatelessWidget {
  const _ItemPhoto({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final file = path == null ? null : File(path!);
    if (file != null && file.existsSync()) {
      return Tooltip(
        message: 'Open photo preview',
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showPhotoPreview(context, file),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.square(
                dimension: 48,
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: const Icon(Icons.inventory_2_outlined),
    );
  }

  void _showPhotoPreview(BuildContext context, File file) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Close photo preview',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: InteractiveViewer(
                      minScale: 0.75,
                      maxScale: 4,
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('This photo could not be loaded.'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

class _InventoryItemDialog extends ConsumerStatefulWidget {
  const _InventoryItemDialog({required this.areas, this.item});

  final List<Area> areas;
  final InventoryItem? item;

  @override
  ConsumerState<_InventoryItemDialog> createState() =>
      _InventoryItemDialogState();
}

class _InventoryItemDialogState extends ConsumerState<_InventoryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  int? _areaId;
  String _condition = 'Good';
  String? _photoPath;
  bool _savingPhoto = false;
  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _notesController.text = item.notes ?? '';
      _areaId = item.areaId;
      _condition = item.condition;
      _photoPath = item.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit room item' : 'Add room item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  hintText: 'Rice cooker, fan, blanket',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _areaId,
                decoration: const InputDecoration(labelText: 'Area'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No area yet'),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final fieldWidth = constraints.maxWidth < 360
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: fieldWidth,
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final parsed = int.tryParse(value ?? '');
                            return parsed == null || parsed < 1
                                ? 'Use 1 or more'
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: fieldWidth,
                        child: DropdownButtonFormField<String>(
                          initialValue: _condition,
                          decoration: const InputDecoration(
                            labelText: 'Condition',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Good',
                              child: Text('Good'),
                            ),
                            DropdownMenuItem(
                              value: 'Used',
                              child: Text('Used'),
                            ),
                            DropdownMenuItem(
                              value: 'Needs repair',
                              child: Text('Needs repair'),
                            ),
                            DropdownMenuItem(
                              value: 'Missing',
                              child: Text('Missing'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _condition = value ?? _condition),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Optional details, serial numbers, or owner notes',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _savingPhoto ? null : _pickPhoto,
                  icon: _savingPhoto
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.photo_library_outlined),
                  label: Text(
                    _photoPath == null ? 'Attach photo' : 'Photo attached',
                  ),
                ),
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
          child: Text(_isEditing ? 'Save changes' : 'Add item'),
        ),
      ],
    );
  }

  Future<void> _pickPhoto() async {
    setState(() => _savingPhoto = true);
    final path = await ref
        .read(imageStorageServiceProvider)
        .pickAndStoreInventoryPhoto();
    if (mounted) {
      setState(() {
        _photoPath = path ?? _photoPath;
        _savingPhoto = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final item = widget.item;
    if (item == null) {
      await ref
          .read(repositoryProvider)
          .addInventoryItem(
            name: _nameController.text,
            areaId: _areaId,
            quantity: int.parse(_quantityController.text),
            condition: _condition,
            notes: _notesController.text,
            photoPath: _photoPath,
          );
    } else {
      await ref
          .read(repositoryProvider)
          .updateInventoryItem(
            item.copyWith(
              name: _nameController.text.trim(),
              areaId: Value<int?>(_areaId),
              quantity: int.parse(_quantityController.text),
              condition: _condition,
              notes: Value<String?>(
                _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
              ),
              photoPath: Value<String?>(_photoPath),
            ),
          );
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}

class _EmptyInventory extends StatelessWidget {
  const _EmptyInventory();

  @override
  Widget build(BuildContext context) {
    return const FullPageEmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'Start your room inventory',
      body:
          'Add items you want to track, then group them by bed, shelf, cabinet, or any area that makes sense.',
    );
  }
}
