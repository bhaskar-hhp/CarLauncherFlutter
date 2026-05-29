import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../providers/navigation_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../theme/app_colors.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool _isNightMode = true;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    final settings = context.watch<SettingsProvider>();
    final state = nav.state;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(state.latitude, state.longitude),
              initialZoom: 15,
              maxZoom: 19,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _isNightMode
                    ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
                    : 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.carlauncher.flutter',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(state.latitude, state.longitude),
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: settings.accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: settings.accentColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.near_me_rounded, color: Colors.white, size: 14),
                    ),
                  ),
                  if (state.destLatitude != null && state.destLongitude != null)
                    Marker(
                      point: LatLng(state.destLatitude!, state.destLongitude!),
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonRed,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonRed.withValues(alpha: 0.4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                ],
              ),
            ],
          ),

          SafeArea(
            child: Column(
              children: [
                _TopBar(context, settings),
                const Spacer(),
                _BottomControls(context, nav, state, settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _TopBar(BuildContext context, SettingsProvider settings) {
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
          GlassCard(
            padding: const EdgeInsets.all(4),
            borderRadius: 12,
            onTap: () => setState(() => _isNightMode = !_isNightMode),
            child: Icon(
              _isNightMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _BottomControls(
      BuildContext context, NavigationProvider nav, dynamic state, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassCard(
            accentColor: settings.accentColor,
            child: Row(
              children: [
                Expanded(
                  child: _NavButton(
                    icon: Icons.home_rounded,
                    label: 'HOME',
                    onTap: () => nav.setDestination(37.7749, -122.4194, 'Home'),
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.glassBorder),
                Expanded(
                  child: _NavButton(
                    icon: Icons.work_rounded,
                    label: 'WORK',
                    onTap: () => nav.setDestination(37.8044, -122.2712, 'Work'),
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.glassBorder),
                Expanded(
                  child: _NavButton(
                    icon: Icons.close_rounded,
                    label: 'CLEAR',
                    onTap: () => nav.clearDestination(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (state.destLabel != null)
            GlassCard(
              accentColor: AppColors.neonCyan,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.destLabel!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(
                          '${state.etaMinutes} min • ${state.distance.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: AppColors.neonCyan, size: 24),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 24),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
