import 'package:flutter/material.dart';

class RoomKeeperPage extends StatelessWidget {
  const RoomKeeperPage({
    super.key,
    required this.children,
    this.bottomPadding = 24,
  });

  final List<Widget> children;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
      children: children,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitleWidgets = subtitle == null
        ? null
        : <Widget>[
            const SizedBox(height: 2),
            Text(subtitle!, style: textTheme.bodySmall),
          ];
    final trailingWidgets = trailing == null ? null : <Widget>[trailing!];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                ...?subtitleWidgets,
              ],
            ),
          ),
          ...?trailingWidgets,
        ],
      ),
    );
  }
}

class RoomKeeperSection extends StatelessWidget {
  const RoomKeeperSection({
    super.key,
    required this.title,
    required this.emptyTitle,
    required this.emptyBody,
    required this.emptyIcon,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String emptyTitle;
  final String emptyBody;
  final IconData emptyIcon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, subtitle: subtitle),
          RoomKeeperCard(
            child: children.isEmpty
                ? CompactEmptyState(
                    icon: emptyIcon,
                    title: emptyTitle,
                    body: emptyBody,
                  )
                : Column(children: children),
          ),
        ],
      ),
    );
  }
}

class RoomKeeperCard extends StatelessWidget {
  const RoomKeeperCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(clipBehavior: Clip.antiAlias, child: child);
  }
}

class CompactEmptyState extends StatelessWidget {
  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            child: Icon(icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullPageEmptyState extends StatelessWidget {
  const FullPageEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              child: Icon(icon, size: 34),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ActionChipLabel extends StatelessWidget {
  const ActionChipLabel({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon == null ? null : Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      backgroundColor: color?.withValues(alpha: 0.13),
    );
  }
}
