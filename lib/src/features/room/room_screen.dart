import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/delete_confirmation.dart';
import '../../shared/roomkeeper_ui.dart';

class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  int? _selectedObjectId;
  bool _editing = false;
  bool _erasing = false;

  @override
  Widget build(BuildContext context) {
    final layout = ref.watch(primaryLayoutProvider).value;
    final areas = ref.watch(areasProvider).value ?? const [];
    final inventory = ref.watch(inventoryProvider).value ?? const [];

    if (layout == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final objects =
        ref.watch(layoutObjectsProvider(layout.id)).value ?? const [];
    final cells = ref.watch(layoutCellsProvider(layout.id)).value ?? const [];
    LayoutObject? selected;
    for (final object in objects) {
      if (object.id == _selectedObjectId) {
        selected = object;
        break;
      }
    }
    final selectedAreaItems = selected?.linkedAreaId == null
        ? const <InventoryItem>[]
        : inventory
              .where((item) => item.areaId == selected!.linkedAreaId)
              .toList();

    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Room layout')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await showDialog<bool>(
            context: context,
            builder: (_) => _LayoutObjectDialog(layout: layout, areas: areas),
          );
          if (created == true && context.mounted) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Room area added to layout.')),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add area'),
      ),
      body: RoomKeeperPage(
        bottomPadding: 96,
        children: [
          _RoomModeBar(
            editing: _editing,
            erasing: _erasing,
            onEditingChanged: (value) => setState(() => _editing = value),
            onErasingChanged: (value) => setState(() => _erasing = value),
          ),
          const SizedBox(height: 12),
          _RoomCanvas(
            layout: layout,
            objects: objects,
            cells: cells,
            selectedId: _selectedObjectId,
            editing: _editing,
            erasing: _erasing,
            onSelect: (id) => setState(() => _selectedObjectId = id),
          ),
          const SizedBox(height: 16),
          if (selected == null)
            const _RoomSummary()
          else
            _SelectedObjectPanel(
              layout: layout,
              object: selected,
              areas: areas,
              linkedItems: selectedAreaItems,
              onDeleted: () => setState(() => _selectedObjectId = null),
            ),
        ],
      ),
    );
  }
}

class _RoomModeBar extends StatelessWidget {
  const _RoomModeBar({
    required this.editing,
    required this.erasing,
    required this.onEditingChanged,
    required this.onErasingChanged,
  });

  final bool editing;
  final bool erasing;
  final ValueChanged<bool> onEditingChanged;
  final ValueChanged<bool> onErasingChanged;

  @override
  Widget build(BuildContext context) {
    return RoomKeeperCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.visibility_outlined),
                    label: Text('View'),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.grid_on_outlined),
                    label: Text('Paint'),
                  ),
                ],
                selected: {editing},
                onSelectionChanged: (value) => onEditingChanged(value.single),
              ),
            ),
            if (editing) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: erasing ? 'Paint cells' : 'Erase cells',
                isSelected: erasing,
                icon: Icon(
                  erasing ? Icons.brush_outlined : Icons.cleaning_services,
                ),
                onPressed: () => onErasingChanged(!erasing),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoomCanvas extends ConsumerWidget {
  const _RoomCanvas({
    required this.layout,
    required this.objects,
    required this.cells,
    required this.selectedId,
    required this.editing,
    required this.erasing,
    required this.onSelect,
  });

  final RoomLayout layout;
  final List<LayoutObject> objects;
  final List<LayoutCell> cells;
  final int? selectedId;
  final bool editing;
  final bool erasing;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final scale = width / layout.width;
        final height = layout.height * scale;
        final columns = math.max(1, (layout.width / layout.gridSize).round());
        final rows = math.max(1, (layout.height / layout.gridSize).round());
        final cellWidth = width / columns;
        final cellHeight = height / rows;
        final objectsById = {for (final object in objects) object.id: object};
        final persisted = <({int column, int row}), LayoutObject>{};
        final cellsByObject = <int, Set<({int column, int row})>>{};
        for (final cell in cells) {
          final object = objectsById[cell.layoutObjectId];
          if (object == null) continue;
          final key = (column: cell.column, row: cell.row);
          persisted[key] = object;
          cellsByObject.putIfAbsent(object.id, () => {}).add(key);
        }
        final painted = _fallbackObjectCells(
          objects: objects,
          persisted: persisted,
          cellsByObject: cellsByObject,
          gridSize: layout.gridSize,
          columns: columns,
          rows: rows,
        );

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: columns * rows,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: cellWidth / cellHeight,
                ),
                itemBuilder: (context, index) {
                  final column = index % columns;
                  final row = index ~/ columns;
                  final key = (column: column, row: row);
                  final object = painted[key];
                  final selected = object?.id == selectedId;
                  return _PaintCell(
                    object: object,
                    selected: selected,
                    onTap: () => _handleCellTap(
                      context: context,
                      ref: ref,
                      key: key,
                      object: object,
                      selectedObject: selectedId == null
                          ? null
                          : objectsById[selectedId],
                      cellsByObject: cellsByObject,
                    ),
                  );
                },
              ),
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: _CanvasHelpBanner(
                  hasObjects: objects.isNotEmpty,
                  editing: editing,
                ),
              ),
              if (objects.isEmpty) const Center(child: _EmptyCanvasMessage()),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleCellTap({
    required BuildContext context,
    required WidgetRef ref,
    required ({int column, int row}) key,
    required LayoutObject? object,
    required LayoutObject? selectedObject,
    required Map<int, Set<({int column, int row})>> cellsByObject,
  }) async {
    if (!editing) {
      onSelect(object?.id);
      return;
    }
    if (selectedObject == null) {
      onSelect(object?.id);
      if (object == null) {
        _showCellMessage(context, 'Select or add an area before painting.');
      }
      return;
    }

    final next = {...?cellsByObject[selectedObject.id]};
    if (next.isEmpty) {
      next.addAll(
        _rectangleCellsFor(
          selectedObject,
          layout.gridSize,
          math.max(1, (layout.width / layout.gridSize).round()),
          math.max(1, (layout.height / layout.gridSize).round()),
        ),
      );
    }
    if (erasing) {
      next.remove(key);
    } else {
      next.add(key);
    }

    try {
      await ref
          .read(repositoryProvider)
          .replaceLayoutObjectCells(object: selectedObject, cells: next);
      onSelect(selectedObject.id);
    } on ArgumentError catch (error) {
      if (!context.mounted) return;
      _showCellMessage(context, error.message?.toString() ?? 'Invalid shape.');
    }
  }

  void _showCellMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PaintCell extends StatelessWidget {
  const _PaintCell({
    required this.object,
    required this.selected,
    required this.onTap,
  });

  final LayoutObject? object;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = object == null
        ? Colors.transparent
        : _parseColor(object!.colorHex);
    return Semantics(
      button: true,
      label: object == null ? 'Empty cell' : '${object!.label} cell',
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: object == null
                ? Theme.of(context).colorScheme.surface
                : color.withValues(alpha: selected ? 0.72 : 0.46),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor.withValues(alpha: 0.65),
              width: selected ? 1.8 : 0.45,
            ),
          ),
        ),
      ),
    );
  }
}

Map<({int column, int row}), LayoutObject> _fallbackObjectCells({
  required List<LayoutObject> objects,
  required Map<({int column, int row}), LayoutObject> persisted,
  required Map<int, Set<({int column, int row})>> cellsByObject,
  required double gridSize,
  required int columns,
  required int rows,
}) {
  final result = {...persisted};
  for (final object in objects) {
    if (cellsByObject.containsKey(object.id)) continue;
    for (final cell in _rectangleCellsFor(object, gridSize, columns, rows)) {
      result.putIfAbsent(cell, () => object);
    }
  }
  return result;
}

Set<({int column, int row})> _rectangleCellsFor(
  LayoutObject object,
  double gridSize,
  int columns,
  int rows,
) {
  final startColumn = (object.x / gridSize).floor().clamp(0, columns - 1);
  final startRow = (object.y / gridSize).floor().clamp(0, rows - 1);
  final endColumn = ((object.x + object.width) / gridSize).ceil().clamp(
    startColumn + 1,
    columns,
  );
  final endRow = ((object.y + object.height) / gridSize).ceil().clamp(
    startRow + 1,
    rows,
  );
  return {
    for (var row = startRow; row < endRow; row++)
      for (var column = startColumn; column < endColumn; column++)
        (column: column, row: row),
  };
}

class _SelectedObjectPanel extends ConsumerStatefulWidget {
  const _SelectedObjectPanel({
    required this.layout,
    required this.object,
    required this.areas,
    required this.linkedItems,
    required this.onDeleted,
  });

  final RoomLayout layout;
  final LayoutObject object;
  final List<Area> areas;
  final List<InventoryItem> linkedItems;
  final VoidCallback onDeleted;

  @override
  ConsumerState<_SelectedObjectPanel> createState() =>
      _SelectedObjectPanelState();
}

class _SelectedObjectPanelState extends ConsumerState<_SelectedObjectPanel> {
  late final TextEditingController _labelController;
  late String _kind;
  late int? _linkedAreaId;
  late String _colorHex;

  LayoutObject get object => widget.object;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _syncFromObject();
  }

  @override
  void didUpdateWidget(covariant _SelectedObjectPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.object.id != widget.object.id ||
        oldWidget.object.label != widget.object.label ||
        oldWidget.object.kind != widget.object.kind ||
        oldWidget.object.linkedAreaId != widget.object.linkedAreaId ||
        oldWidget.object.colorHex != widget.object.colorHex) {
      _syncFromObject();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _syncFromObject() {
    _labelController.text = widget.object.label;
    _kind = widget.object.kind;
    _linkedAreaId = widget.object.linkedAreaId;
    _colorHex = widget.object.colorHex;
  }

  @override
  Widget build(BuildContext context) {
    String? areaName;
    for (final area in widget.areas) {
      if (area.id == object.linkedAreaId) {
        areaName = area.name;
        break;
      }
    }
    final linkedItems = widget.linkedItems;
    final linkedItemPreview = linkedItems.take(6).toList();
    final hiddenLinkedItemCount = linkedItems.length - linkedItemPreview.length;

    return RoomKeeperCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        object.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${_kindLabel(object.kind)} • ${areaName ?? 'Not linked to inventory'}',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Delete room area',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _deleteObject,
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Area details', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Area name',
                hintText: 'Bed, study desk, clothes cabinet',
              ),
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _applyDetails(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'Area type'),
                    items: _kindOptions,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _kind = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _areaDropdownValue(_linkedAreaId),
                    decoration: const InputDecoration(
                      labelText: 'Inventory area',
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: _noLinkedAreaValue,
                        child: Text('No inventory link'),
                      ),
                      ...widget.areas.map(
                        (area) => DropdownMenuItem<int>(
                          value: area.id,
                          child: Text(area.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      final linkedAreaId = _linkedAreaIdFromDropdown(value);
                      Area? area;
                      for (final candidate in widget.areas) {
                        if (candidate.id == linkedAreaId) {
                          area = candidate;
                          break;
                        }
                      }
                      setState(() {
                        _linkedAreaId = linkedAreaId;
                        _colorHex = area?.colorHex ?? _colorHex;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ColorPicker(
              selectedHex: _colorHex,
              onSelected: (hex) => setState(() => _colorHex = hex),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _applyDetails,
                icon: const Icon(Icons.check),
                label: const Text('Save area'),
              ),
            ),
            const Divider(height: 28),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Inventory in this area',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Chip(
                  label: Text(
                    '${linkedItems.length} ${linkedItems.length == 1 ? 'item' : 'items'}',
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (linkedItems.isEmpty)
              const Text('No inventory items are linked to this area yet.')
            else ...[
              ...linkedItemPreview.map((item) => _LinkedItemTile(item: item)),
              if (hiddenLinkedItemCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text('+$hiddenLinkedItemCount more')),
                      TextButton.icon(
                        onPressed: _showLinkedItems,
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('View all'),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _applyDetails() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      _showSnackBar('Enter a room area label before applying changes.');
      return;
    }
    await _updateObject(
      object.copyWith(
        label: label,
        kind: _kind,
        linkedAreaId: Value<int?>(_linkedAreaId),
        colorHex: _colorHex,
      ),
      message: 'Room area details updated.',
    );
  }

  Future<void> _deleteObject() async {
    final confirmed = await confirmDelete(
      context: context,
      title: 'Delete room area?',
      itemName: object.label,
    );
    if (!confirmed) return;
    await ref.read(repositoryProvider).deleteLayoutObject(object.id);
    widget.onDeleted();
    _showSnackBar('Room area deleted.');
  }

  Future<void> _updateObject(LayoutObject next, {String? message}) async {
    await ref.read(repositoryProvider).updateLayoutObject(next);
    if (message != null) _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showLinkedItems() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Inventory in ${object.label}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: widget.linkedItems
                  .map((item) => _LinkedItemTile(item: item))
                  .toList(),
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

class _LinkedItemTile extends StatelessWidget {
  const _LinkedItemTile({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.inventory_2_outlined),
      title: Text(item.name),
      subtitle: Text('Qty ${item.quantity} • ${item.condition}'),
    );
  }
}

class _RoomSummary extends StatelessWidget {
  const _RoomSummary();

  @override
  Widget build(BuildContext context) {
    return RoomKeeperCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.touch_app_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tap an area on the layout to edit, move, resize, rotate, or remove it.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CanvasHelpBanner extends StatelessWidget {
  const _CanvasHelpBanner({required this.hasObjects, required this.editing});

  final bool hasObjects;
  final bool editing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          editing
              ? 'Paint mode: select an area, then tap grid cells to paint or erase.'
              : hasObjects
              ? 'View mode: tap a colored cell to inspect that area.'
              : 'Add your first room area, then paint it onto the grid.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _EmptyCanvasMessage extends StatelessWidget {
  const _EmptyCanvasMessage();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Text('No room areas yet. Use Add area to begin.'),
      ),
    );
  }
}

class _LayoutObjectDialog extends ConsumerStatefulWidget {
  const _LayoutObjectDialog({required this.layout, required this.areas});

  final RoomLayout layout;
  final List<Area> areas;

  @override
  ConsumerState<_LayoutObjectDialog> createState() =>
      _LayoutObjectDialogState();
}

class _LayoutObjectDialogState extends ConsumerState<_LayoutObjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  String _kind = 'zone';
  int? _linkedAreaId;
  String _colorHex = '#3B82F6';

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add area to layout'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Area name',
                  hintText: 'Bed, desk, cabinet',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _kind,
                decoration: const InputDecoration(labelText: 'Area type'),
                items: _kindOptions,
                onChanged: (value) => setState(() => _kind = value ?? _kind),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _areaDropdownValue(_linkedAreaId),
                decoration: const InputDecoration(labelText: 'Inventory area'),
                items: [
                  const DropdownMenuItem<int>(
                    value: _noLinkedAreaValue,
                    child: Text('No inventory link'),
                  ),
                  ...widget.areas.map(
                    (area) => DropdownMenuItem<int>(
                      value: area.id,
                      child: Text(area.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  final linkedAreaId = _linkedAreaIdFromDropdown(value);
                  Area? area;
                  for (final candidate in widget.areas) {
                    if (candidate.id == linkedAreaId) {
                      area = candidate;
                      break;
                    }
                  }
                  setState(() {
                    _linkedAreaId = linkedAreaId;
                    _colorHex = area?.colorHex ?? _colorHex;
                  });
                },
              ),
              const SizedBox(height: 12),
              _ColorPicker(
                selectedHex: _colorHex,
                onSelected: (hex) => setState(() => _colorHex = hex),
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
        FilledButton(onPressed: _save, child: const Text('Add area')),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(repositoryProvider)
        .addLayoutObject(
          layoutId: widget.layout.id,
          label: _labelController.text,
          linkedAreaId: _linkedAreaId,
          kind: _kind,
          colorHex: _colorHex,
        );
    if (mounted) Navigator.pop(context, true);
  }
}

const _kindOptions = [
  DropdownMenuItem(value: 'zone', child: Text('Zone')),
  DropdownMenuItem(value: 'furniture', child: Text('Furniture')),
  DropdownMenuItem(value: 'storage', child: Text('Storage')),
  DropdownMenuItem(value: 'fixture', child: Text('Fixture')),
];

const _noLinkedAreaValue = -1;

int _areaDropdownValue(int? linkedAreaId) {
  return linkedAreaId ?? _noLinkedAreaValue;
}

int? _linkedAreaIdFromDropdown(int? value) {
  return value == null || value == _noLinkedAreaValue ? null : value;
}

String _kindLabel(String value) {
  return switch (value) {
    'furniture' => 'Furniture',
    'storage' => 'Storage',
    'fixture' => 'Fixture',
    _ => 'Zone',
  };
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.selectedHex, required this.onSelected});

  final String selectedHex;
  final ValueChanged<String> onSelected;

  static const _colors = [
    '#3B82F6',
    '#F97316',
    '#10B981',
    '#8B5CF6',
    '#EF4444',
    '#06B6D4',
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _colors.map((hex) {
          final selected = hex == selectedHex;
          return Tooltip(
            message: 'Use color $hex',
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onSelected(hex),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _parseColor(hex),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

Color _parseColor(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.tryParse('FF$cleaned', radix: 16);
  return Color(value ?? 0xFF3B82F6);
}
