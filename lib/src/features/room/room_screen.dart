import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Room layout')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => _LayoutObjectDialog(layout: layout, areas: areas),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Object'),
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
              object: selected,
              areas: areas,
              linkedItems: selectedAreaItems,
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
            ),
            child: Stack(
              children: [
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

class _SelectedObjectPanel extends ConsumerWidget {
  const _SelectedObjectPanel({
    required this.object,
    required this.areas,
    required this.linkedItems,
  });

  final LayoutObject object;
  final List<Area> areas;
  final List<InventoryItem> linkedItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? areaName;
    for (final area in areas) {
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
                      Text(areaName ?? 'No linked area'),
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
                  },
                ),
                IconButton(
                  tooltip: 'Delete object',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref
                      .read(repositoryProvider)
                      .deleteLayoutObject(object.id),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Linked items', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (linkedItems.isEmpty)
              const Text('No items in this area.')
            else
              ...linkedItems
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
            const Expanded(child: Text('Select a layout object.')),
          ],
        ),
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
      title: const Text('Add object'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Label'),
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _kind,
                decoration: const InputDecoration(labelText: 'Kind'),
                items: const [
                  DropdownMenuItem(value: 'zone', child: Text('Zone')),
                  DropdownMenuItem(
                    value: 'furniture',
                    child: Text('Furniture'),
                  ),
                  DropdownMenuItem(value: 'storage', child: Text('Storage')),
                  DropdownMenuItem(value: 'fixture', child: Text('Fixture')),
                ],
                onChanged: (value) => setState(() => _kind = value ?? _kind),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _linkedAreaId,
                decoration: const InputDecoration(labelText: 'Linked area'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('None'),
                  ),
                  ...widget.areas.map(
                    (area) => DropdownMenuItem<int?>(
                      value: area.id,
                      child: Text(area.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  Area? area;
                  for (final candidate in widget.areas) {
                    if (candidate.id == value) {
                      area = candidate;
                      break;
                    }
                  }
                  setState(() {
                    _linkedAreaId = value;
                    _colorHex = area?.colorHex ?? _colorHex;
                  });
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        '#3B82F6',
                        '#F97316',
                        '#10B981',
                        '#8B5CF6',
                        '#EF4444',
                        '#06B6D4',
                      ].map((hex) {
                        final selected = hex == _colorHex;
                        return InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => setState(() => _colorHex = hex),
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
                        );
                      }).toList(),
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
    if (mounted) Navigator.pop(context);
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
