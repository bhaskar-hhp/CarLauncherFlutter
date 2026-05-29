import 'package:flutter/material.dart';
import '../models/media_state.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class MusicPlayerWidget extends StatelessWidget {
  final MediaState mediaState;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const MusicPlayerWidget({
    super.key,
    required this.mediaState,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = mediaState.hasSession;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      accentColor: AppColors.neonPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'NOW PLAYING',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 2,
                ),
              ),
              if (hasMedia && mediaState.isPlaying)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.neonGreen,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasMedia ? mediaState.title : 'No Media Playing',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasMedia && mediaState.artist.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          mediaState.artist,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MediaButton(
                    icon: Icons.skip_previous_rounded,
                    onTap: onPrev,
                    enabled: hasMedia,
                  ),
                  const SizedBox(width: 4),
                  _MediaButton(
                    icon: hasMedia && mediaState.isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    onTap: onPlayPause,
                    enabled: true,
                    size: 40,
                    color: hasMedia ? AppColors.neonPurple : AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  _MediaButton(
                    icon: Icons.skip_next_rounded,
                    onTap: onNext,
                    enabled: hasMedia,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final double size;
  final Color? color;

  const _MediaButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: color ?? (enabled ? AppColors.textPrimary : AppColors.textDim),
            size: size * 0.7,
          ),
        ),
      ),
    );
  }
}
