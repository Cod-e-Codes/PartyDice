import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/gender.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<Offset> slideAnimation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlayerCard({
    required this.player,
    required this.isSelected,
    required this.onTap,
    required this.slideAnimation,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color cardColor =
        isSelected ? colorScheme.secondary : colorScheme.surface;
    final Color textColor = isSelected
        ? Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black87
        : colorScheme.onSurface;
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    final double elevation = isSelected && isDarkTheme ? 8 : 4;

    return SlideTransition(
      position: slideAnimation,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(8),
        color: cardColor,
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
            child: CircleAvatar(
              backgroundColor: player.color,
              child: Text(
                player.name[0],
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            player.name,
            style: TextStyle(color: textColor),
          ),
          subtitle: Text(
            player.gender == Gender.male
                ? 'Male'
                : player.gender == Gender.female
                    ? 'Female'
                    : 'Other',
            style: TextStyle(color: textColor),
          ),
          onTap: onTap,
          trailing: isSelected
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      color: theme.iconTheme.color,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      color: theme.iconTheme.color,
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
