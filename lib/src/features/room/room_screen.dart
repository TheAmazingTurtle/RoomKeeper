import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../shared/delete_confirmation.dart';

class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  int? _selectedObjectId;

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
        label: const Text('Room area'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          _RoomCanvas(
            layout: layout,
            objects: objects,
            selectedId: _selectedObjectId,
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

class _RoomCanvas extends ConsumerWidget {
  const _RoomCanvas({
    required this.layout,
    required this.objects,
    required this.selectedId,
    required this.onSelect,
  });

  final RoomLayout layout;
  final List<LayoutObject> objects;
  final int? selectedId;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final scale = width / layout.width;
        final height = layout.height * scale;

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
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: _CanvasHelpBanner(hasObjects: objects.isNotEmpty),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(
                    gridSize: layout.gridSize * scale,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(onTap: () => onSelect(null)),
              ),
              if (objects.isEmpty) const Center(child: _EmptyCanvasMessage()),
              ...objects.map((object) {
                return _CanvasObject(
                  layout: layout,
                  object: object,
                  scale: scale,
                  selected: object.id == selectedId,
                  onSelect: () => onSelect(object.id),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _CanvasObject extends ConsumerWidget {
  const _CanvasObject({
    required this.layout,
    required this.object,
    required this.scale,
    required this.selected,
    required this.onSelect,
  });

  final RoomLayout layout;
  final LayoutObject object;
  final double scale;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _parseColor(object.colorHex);
    return Positioned(
      left: object.x * scale,
      top: object.y * scale,
      width: object.width * scale,
      height: object.height * scale,
      child: Transform.rotate(
        angle: object.rotation * math.pi / 180,
        child: GestureDetector(
          onTap: onSelect,
          onPanUpdate: (details) {
            final next = object.copyWith(
              x: _snap(
                object.x + details.delta.dx / scale,
                layout.gridSize,
              ).clamp(0, layout.width - object.width).toDouble(),
              y: _snap(
                object.y + details.delta.dy / scale,
                layout.gridSize,
              ).clamp(0, layout.height - object.height).toDouble(),
            );
            ref.read(repositoryProvider).updateLayoutObject(next);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? Theme.of(context).colorScheme.primary : color,
                width: selected ? 3 : 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.28),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                if (selected)
                  Positioned(
                    left: 6,
                    top: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: Text(
                          'Selected',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      object.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final next = object.copyWith(
                          width: _snap(
                            object.width + details.delta.dx / scale,
                            layout.gridSize,
                          ).clamp(40, layout.width - object.x).toDouble(),
                          height: _snap(
                            object.height + details.delta.dy / scale,
                            layout.gridSize,
                          ).clamp(40, layout.height - object.y).toDouble(),
                        );
                        ref.read(repositoryProvider).updateLayoutObject(next);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.open_in_full,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    return Card(
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
                        '${_kindLabel(object.kind)} - ${areaName ?? 'No linked area'}',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Rotate',
                  icon: const Icon(Icons.rotate_right),
                  onPressed: () {
                    ref
                        .read(repositoryProvider)
                        .updateLayoutObject(
                          object.copyWith(
                            rotation: (object.rotation + 15) % 360,
                          ),
                        );
                    _showSnackBar('Room area rotated.');
                  },
                ),
                IconButton(
                  tooltip: 'Delete room area',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _deleteObject,
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Details', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Room area label'),
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _applyDetails(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'Type'),
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
                    decoration: const InputDecoration(labelText: 'Linked area'),
                    items: [
                      const DropdownMenuItem<int>(
                        value: _noLinkedAreaValue,
                        child: Text('None'),
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
                label: const Text('Apply details'),
              ),
            ),
            const Divider(height: 28),
            Text(
              'Position and size',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _ObjectSlider(
              label: 'Left',
              value: object.x,
              max: widget.layout.width - object.width,
              onChanged: (value) => _updateObject(
                object.copyWith(x: _snap(value, widget.layout.gridSize)),
              ),
            ),
            _ObjectSlider(
              label: 'Top',
              value: object.y,
              max: widget.layout.height - object.height,
              onChanged: (value) => _updateObject(
                object.copyWith(y: _snap(value, widget.layout.gridSize)),
              ),
            ),
            _ObjectSlider(
              label: 'Width',
              value: object.width,
              min: 40,
              max: widget.layout.width - object.x,
              onChanged: (value) => _updateObject(
                object.copyWith(width: _snap(value, widget.layout.gridSize)),
              ),
            ),
            _ObjectSlider(
              label: 'Height',
              value: object.height,
              min: 40,
              max: widget.layout.height - object.y,
              onChanged: (value) => _updateObject(
                object.copyWith(height: _snap(value, widget.layout.gridSize)),
              ),
            ),
            _ObjectSlider(
              label: 'Rotation',
              value: object.rotation,
              max: 345,
              divisions: 23,
              onChanged: (value) => _updateObject(
                object.copyWith(rotation: _snap(value, 15) % 360),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Drag the selected area on the grid to move it, or use the corner handle and controls above for precise sizing.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 28),
            Text('Linked items', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (widget.linkedItems.isEmpty)
              const Text('No items in this area.')
            else
              ...widget.linkedItems
                  .take(6)
                  .map(
                    (item) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.inventory_2_outlined),
                      title: Text(item.name),
                      subtitle: Text(
                        'Qty ${item.quantity} - ${item.condition}',
                      ),
                    ),
                  ),
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
}

class _RoomSummary extends StatelessWidget {
  const _RoomSummary();

  @override
  Widget build(BuildContext context) {
    return Card(
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
                'Select a room area on the layout to edit details, move it, resize it, rotate it, or delete it.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CanvasHelpBanner extends StatelessWidget {
  const _CanvasHelpBanner({required this.hasObjects});

  final bool hasObjects;

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
          hasObjects
              ? 'Tap a room area to configure it. Drag to move; use the corner handle or details panel to resize.'
              : 'Add your first room area, then link it to an inventory area.',
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
        child: Text('No room areas yet. Use Add room area to begin.'),
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
      title: const Text('Add room area'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Room area label'),
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _kind,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _kindOptions,
                onChanged: (value) => setState(() => _kind = value ?? _kind),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _areaDropdownValue(_linkedAreaId),
                decoration: const InputDecoration(labelText: 'Linked area'),
                items: [
                  const DropdownMenuItem<int>(
                    value: _noLinkedAreaValue,
                    child: Text('None'),
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
        FilledButton(onPressed: _save, child: const Text('Save')),
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

class _ObjectSlider extends StatelessWidget {
  const _ObjectSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    this.min = 0,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveMax = math.max(min, max);
    final effectiveValue = value.clamp(min, effectiveMax).toDouble();
    return Row(
      children: [
        SizedBox(width: 72, child: Text(label)),
        Expanded(
          child: Slider(
            min: min,
            max: effectiveMax,
            divisions: divisions,
            value: effectiveValue,
            label: effectiveValue.round().toString(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            effectiveValue.round().toString(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.gridSize, required this.color});

  final double gridSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.42)
      ..strokeWidth = 0.6;
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize || oldDelegate.color != color;
  }
}

double _snap(double value, double grid) {
  if (grid <= 0) return value;
  return (value / grid).round() * grid;
}

Color _parseColor(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.tryParse('FF$cleaned', radix: 16);
  return Color(value ?? 0xFF3B82F6);
}
