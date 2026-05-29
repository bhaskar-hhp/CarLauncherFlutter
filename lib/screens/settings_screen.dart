import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final accent = settings.accentColor;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(context, accent),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _AccentColorSection(settings, accent),
                  const SizedBox(height: 12),
                  _BrightnessSlider(settings, accent),
                  const SizedBox(height: 12),
                  _SpeedUnitToggle(settings, accent),
                  const SizedBox(height: 12),
                  _DarkModeToggle(settings, accent),
                  const SizedBox(height: 12),
                  _WallpaperSelector(settings, accent),
                  const SizedBox(height: 12),
                  _DayNightAuto(settings, accent),
                  const SizedBox(height: 24),
                  _AboutSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Header(BuildContext context, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(4),
            borderRadius: 12,
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 22),
          ),
          const Spacer(),
          const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _AccentColorSection(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACCENT COLOR',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppColors.accentColors.entries.map((entry) {
              final isSelected = settings.accentName == entry.key;
              return GestureDetector(
                onTap: () => settings.setAccentColor(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.value,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: entry.value.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: -2)]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _BrightnessSlider(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BRIGHTNESS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.brightness_low_rounded, color: AppColors.textDim, size: 18),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: accent,
                    inactiveTrackColor: AppColors.glassBorder,
                    thumbColor: accent,
                    overlayColor: accent.withValues(alpha: 0.1),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: settings.brightness,
                    onChanged: (v) => settings.setBrightness(v),
                    min: 0.3,
                    max: 1.0,
                  ),
                ),
              ),
              const Icon(Icons.brightness_high_rounded, color: AppColors.textDim, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _SpeedUnitToggle(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      onTap: () => settings.setSpeedUnit(settings.speedUnit == 'km/h' ? 'mph' : 'km/h'),
      child: Row(
        children: [
          const Icon(Icons.speed_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SPEED UNIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2)),
                SizedBox(height: 2),
                Text('Tap to toggle', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: accent.withValues(alpha: 0.15),
            ),
            child: Text(
              settings.speedUnit,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DarkModeToggle(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      child: Row(
        children: [
          const Icon(Icons.dark_mode_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DARK MODE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2)),
                SizedBox(height: 2),
                Text('Always on for driving', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: settings.isDarkMode,
            onChanged: (_) => settings.toggleDarkMode(),
            activeTrackColor: accent,
            activeThumbColor: accent,
          ),
        ],
      ),
    );
  }

  Widget _WallpaperSelector(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      onTap: () async {
        // In production, this would use image_picker
        // For now, cycle through preset options
        if (settings.wallpaperPath == null) {
          await settings.setWallpaper('preset_dark');
        } else {
          await settings.setWallpaper(null);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.wallpaper_rounded, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WALLPAPER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2)),
                SizedBox(height: 2),
                Text('Custom background', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: accent, size: 24),
        ],
      ),
    );
  }

  Widget _DayNightAuto(SettingsProvider settings, Color accent) {
    return GlassCard(
      accentColor: accent,
      child: Row(
        children: [
          const Icon(Icons.sunny_snowing, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AUTO DAY/NIGHT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 2)),
                SizedBox(height: 2),
                Text('Automatic based on time', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: true,
            onChanged: null,
            activeTrackColor: accent,
            activeThumbColor: accent,
          ),
        ],
      ),
    );
  }

  Widget _AboutSection() {
    return GlassCard(
      child: Column(
        children: [
          const Text(
            'CAR LAUNCHER',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: AppColors.textPrimary, letterSpacing: 4),
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.0.0 • Flutter',
            style: TextStyle(fontSize: 10, color: AppColors.textDim),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: const LinearGradient(
                colors: [AppColors.neonBlue, AppColors.neonPurple],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
