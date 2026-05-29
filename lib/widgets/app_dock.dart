import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_item.dart';

class AppDock extends StatelessWidget {
  final List<AppItem> apps;
  final void Function(AppItem) onAppTap;

  const AppDock({
    super.key,
    required this.apps,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassLight,
            AppColors.glassMedium,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: apps.map((app) => _DockIcon(app: app, onTap: () => onAppTap(app))).toList(),
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final AppItem app;
  final VoidCallback onTap;

  const _DockIcon({required this.app, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5),
                ),
                child: Icon(
                  _iconForApp(app.name),
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                app.name,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForApp(String name) {
    switch (name.toLowerCase()) {
      case 'phone':
        return Icons.phone_rounded;
      case 'maps':
        return Icons.navigation_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'settings':
        return Icons.settings_rounded;
      case 'chrome':
        return Icons.language_rounded;
      case 'messages':
        return Icons.message_rounded;
      case 'camera':
        return Icons.camera_alt_rounded;
      case 'calendar':
        return Icons.calendar_month_rounded;
      default:
        return Icons.apps_rounded;
    }
  }
}
