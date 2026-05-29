import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/media_provider.dart';
import '../widgets/clock_widget.dart';
import '../widgets/speed_display.dart';
import '../widgets/music_player_widget.dart';
import '../widgets/weather_widget.dart';
import '../widgets/status_bar.dart';
import '../widgets/app_dock.dart';
import '../widgets/glass_card.dart';
import '../models/app_item.dart';
import '../theme/app_colors.dart';
import 'app_drawer_screen.dart';
import 'navigation_screen.dart';
import 'music_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final mediaProvider = context.watch<MediaProvider>();
    final settings = context.watch<SettingsProvider>();
    final accent = settings.accentColor;
    final navState = navProvider.state;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBarWidget(hasGpsFix: true),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 35, child: _LeftPanel(navState, mediaProvider, accent, context)),
                  const SizedBox(width: 16),
                  Expanded(flex: 65, child: _RightPanel(navState, accent, context)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppDock(
              apps: AppItem.defaultApps.take(4).toList(),
              onAppTap: (app) => _launchScreen(context, app.name),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _launchScreen(BuildContext context, String appName) {
    switch (appName.toLowerCase()) {
      case 'maps':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NavigationScreen()));
      case 'music':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicScreen()));
      case 'settings':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
      default:
        break;
    }
  }
}

class _LeftPanel extends StatelessWidget {
  final dynamic navState;
  final MediaProvider mediaProvider;
  final Color accent;
  final BuildContext screenContext;

  const _LeftPanel(this.navState, this.mediaProvider, this.accent, this.screenContext);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GlassCard(
            accentColor: accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ClockWidget(fontSize: 42, showDate: true),
                const Spacer(),
                Center(
                  child: SpeedDisplay(
                    speed: navState.currentSpeed,
                    unit: navState.speedUnit,
                    size: 80,
                  ),
                ),
                const Spacer(),
                WeatherWidget(latitude: navState.latitude, longitude: navState.longitude),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        MusicPlayerWidget(
          mediaState: mediaProvider.state,
          onPlayPause: () => mediaProvider.playPause(),
          onNext: () => mediaProvider.next(),
          onPrev: () => mediaProvider.previous(),
        ),
        const SizedBox(height: 8),
        _QuickShortcuts(accent: accent),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  final dynamic navState;
  final Color accent;
  final BuildContext screenContext;

  const _RightPanel(this.navState, this.accent, this.screenContext);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _NavigationCard(navState: navState, accent: accent),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: _QuickActionCard(
                icon: Icons.person_outline_rounded,
                label: 'CALLS',
                color: AppColors.neonGreen,
                onTap: () {},
              )),
              const SizedBox(width: 8),
              Expanded(child: _QuickActionCard(
                icon: Icons.message_outline_rounded,
                label: 'MESSAGES',
                color: AppColors.neonCyan,
                onTap: () {},
              )),
              const SizedBox(width: 8),
              Expanded(child: _QuickActionCard(
                icon: Icons.more_horiz_rounded,
                label: 'APPS',
                color: AppColors.neonPurple,
                onTap: () {
                  Navigator.push(screenContext, MaterialPageRoute(builder: (_) => const AppDrawerScreen()));
                },
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final dynamic navState;
  final Color accent;

  const _NavigationCard({required this.navState, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accentColor: AppColors.neonCyan,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NavigationScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.navigation_rounded, color: AppColors.neonCyan, size: 16),
              const SizedBox(width: 8),
              Text(
                navState.destLabel ?? 'NAVIGATION',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              _MiniMap(navState: navState),
              const SizedBox(width: 8),
            ],
          ),
          const Spacer(),
          if (navState.destLabel != null)
            Row(
              children: [
                _StatItem(value: '${navState.etaMinutes}', label: 'MIN', color: AppColors.neonCyan),
                const SizedBox(width: 16),
                _StatItem(value: navState.distance.toStringAsFixed(1), label: 'KM', color: AppColors.textSecondary),
              ],
            )
          else
            Text(
              'Tap to set destination',
              style: TextStyle(
                fontSize: 12,
                color: accent.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniMap extends StatelessWidget {
  final dynamic navState;

  const _MiniMap({required this.navState});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppColors.darkCard, AppColors.darkBackground],
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Stack(
        children: [
          ...List.generate(6, (i) {
            final angle = i * 60 * pi / 180;
            return Positioned(
              left: 40 + 25 * cos(angle) - 2,
              top: 40 + 25 * sin(angle) - 2,
              child: Container(
                width: 4, height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textDim,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          const Center(
            child: Icon(Icons.near_me_rounded, color: AppColors.neonCyan, size: 20),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted, letterSpacing: 2, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      accentColor: color,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color.withValues(alpha: 0.8),
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickShortcuts extends StatelessWidget {
  final Color accent;

  const _QuickShortcuts({required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (i) {
          return Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
              color: AppColors.darkCard,
            ),
            child: const Icon(Icons.add_rounded, color: AppColors.textDim, size: 20),
          );
        }),
      ),
    );
  }
}
