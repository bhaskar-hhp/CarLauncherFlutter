import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../theme/app_colors.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = context.watch<MediaProvider>();
    final settings = context.watch<SettingsProvider>();
    final state = media.state;
    final accent = settings.accentColor;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(context, accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AlbumArt(state.hasSession, accent),
                    const SizedBox(height: 32),
                    if (state.sourceName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          state.sourceName!,
                          style: const TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 2, fontWeight: FontWeight.w600),
                        ),
                      ),
                    Text(
                      state.hasSession ? state.title : 'No Media Playing',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: state.hasSession ? AppColors.textPrimary : AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.hasSession ? state.artist : 'Open YouTube Music to play',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 40),
                    if (state.hasSession) _ProgressBar(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!state.hasSession)
                          _LaunchYtButton(() => media.launchYtMusic(), accent)
                        else ...[
                          _ControlButton(Icons.skip_previous_rounded, () => media.previous(), accent),
                          const SizedBox(width: 24),
                          _PlayButton(state.isPlaying, () => media.playPause(), accent),
                          const SizedBox(width: 24),
                          _ControlButton(Icons.skip_next_rounded, () => media.next(), accent),
                        ],
                      ],
                    ),
                    if (state.hasSession) ...[
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SmallButton(Icons.shuffle_rounded, accent),
                          const SizedBox(width: 32),
                          _SmallButton(Icons.repeat_rounded, accent),
                          const SizedBox(width: 32),
                          _SmallButton(Icons.favorite_border_rounded, accent),
                        ],
                      ),
                    ],
                  ],
                ),
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
            child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary, size: 24),
          ),
          const Spacer(),
          const Text(
            'MUSIC',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          GlassCard(
            padding: const EdgeInsets.all(4),
            borderRadius: 12,
            onTap: () {},
            child: const Icon(Icons.bluetooth_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _AlbumArt(bool hasMedia, Color accent) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.3),
            AppColors.darkCard,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.2),
            blurRadius: 60,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          hasMedia ? Icons.music_note_rounded : Icons.play_circle_outline_rounded,
          size: 80,
          color: accent.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _ProgressBar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColors.glassBorder,
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [AppColors.neonBlue, AppColors.neonPurple],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1:24', style: TextStyle(fontSize: 10, color: AppColors.textDim)),
            Text('3:42', style: TextStyle(fontSize: 10, color: AppColors.textDim)),
          ],
        ),
      ],
    );
  }

  Widget _ControlButton(IconData icon, VoidCallback onTap, Color accent) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 26),
        ),
      ),
    );
  }

  Widget _PlayButton(bool isPlaying, VoidCallback onTap, Color accent) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [accent, accent.withValues(alpha: 0.7)],
            ),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: -5),
            ],
          ),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _LaunchYtButton(VoidCallback onTap, Color accent) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppColors.neonRed.withValues(alpha: 0.2),
                AppColors.neonRed.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: AppColors.neonRed.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_circle_filled_rounded, color: AppColors.neonRed, size: 32),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OPEN YOUTUBE MUSIC',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tap to launch and start playing',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.neonRed, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _SmallButton(IconData icon, Color accent) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 18),
        ),
      ),
    );
  }
}
