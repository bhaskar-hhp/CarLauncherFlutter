import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusBarWidget extends StatelessWidget {
  final bool bluetoothOn;
  final bool hasGpsFix;
  final int batteryLevel;
  final int signalStrength;
  final String temperature;
  final VoidCallback? onBluetoothTap;
  final VoidCallback? onWifiTap;

  const StatusBarWidget({
    super.key,
    this.bluetoothOn = false,
    this.hasGpsFix = false,
    this.batteryLevel = 80,
    this.signalStrength = 3,
    this.temperature = '75°',
    this.onBluetoothTap,
    this.onWifiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          _StatusIcon(
            icon: Icons.bluetooth_rounded,
            active: bluetoothOn,
            onTap: onBluetoothTap,
          ),
          const SizedBox(width: 16),
          _StatusIcon(
            icon: Icons.wifi_rounded,
            active: true,
            onTap: onWifiTap,
          ),
          const SizedBox(width: 16),
          _GpsIndicator(hasFix: hasGpsFix),
          const Spacer(),
          if (temperature.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                temperature,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          _SignalBars(strength: signalStrength),
          const SizedBox(width: 8),
          _BatteryIndicator(level: batteryLevel),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback? onTap;

  const _StatusIcon({
    required this.icon,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 16,
        color: active ? AppColors.textSecondary : AppColors.textDim,
      ),
    );
  }
}

class _GpsIndicator extends StatelessWidget {
  final bool hasFix;

  const _GpsIndicator({required this.hasFix});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        final fill = hasFix && i < 3;
        return Container(
          width: 3,
          height: 4 + i * 2,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: fill ? AppColors.neonGreen : AppColors.textDim,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

class _SignalBars extends StatelessWidget {
  final int strength;

  const _SignalBars({required this.strength});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        return Container(
          width: 3,
          height: 4 + i * 2,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: i < strength ? AppColors.statusOnline : AppColors.textDim,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  final int level;

  const _BatteryIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = level > 20 ? AppColors.textSecondary : AppColors.neonRed;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.battery_5_bar_rounded, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$level%',
          style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
