import 'package:flutter/material.dart';

Future<bool> confirmDelete({
  required BuildContext context,
  required String title,
  required String itemName,
  String? message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message ??
              'Remove "$itemName" from RoomKeeper? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
