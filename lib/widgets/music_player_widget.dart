import 'package:flutter/material.dart';
import '../models/media_state.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class MusicPlayerWidget extends StatelessWidget {
  final MediaState mediaState;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback? onLaunchYtMusic;

  const MusicPlayerWidget({
    super.key,
    required this.mediaState,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrev,
    this.onLaunchYtMusic,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = mediaState.hasSession;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      accentColor: hasMedia ? AppColors.neonPurple : AppColors.textDim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                hasMedia ? 'NOW PLAYING' : 'MEDIA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: hasMedia ? AppColors.textMuted : AppColors.textDim,
                  letterSpacing: 2,
                ),
              ),
              if (hasMedia && mediaState.isPlaying)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 6, height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.neonGreen, shape: BoxShape.circle,
                  ),
                ),
              const Spacer(),
              if (mediaState.sourceName != null)
                Text(
                  mediaState.sourceName!,
                  style: const TextStyle(fontSize: 8, color: AppColors.textDim),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: hasMedia ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasMedia && mediaState.artist.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          mediaState.artist,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              if (!hasMedia && onLaunchYtMusic != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onLaunchYtMusic,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.neonRed.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.neonRed.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow_rounded, color: AppColors.neonRed, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'YT Music',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neonRed.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (hasMedia) ...[
                _MediaButton(Icons.skip_previous_rounded, onPrev, enabled: hasMedia),
                const SizedBox(width: 4),
                _MediaButton(
                  hasMedia && mediaState.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  onPlayPause,
                  enabled: true,
                  size: 40,
                  color: hasMedia ? AppColors.neonPurple : AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                _MediaButton(Icons.skip_next_rounded, onNext, enabled: hasMedia),
              ],
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

  const _MediaButton(this.icon, this.onTap, {this.enabled = true, this.size = 36, this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: size, height: size,
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
