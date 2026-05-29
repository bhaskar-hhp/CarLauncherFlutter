import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class ClockWidget extends StatefulWidget {
  final double fontSize;
  final bool showDate;
  final Color? color;

  const ClockWidget({
    super.key,
    this.fontSize = 48,
    this.showDate = true,
    this.color,
  });

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _time = '';
  String _date = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = DateFormat('h:mm').format(now);
      _date = DateFormat('EEEE, MMMM d').format(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _time,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w200,
            color: widget.color ?? AppColors.textPrimary,
            letterSpacing: 4,
            height: 0.9,
          ),
        ),
        if (widget.showDate)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _date.toUpperCase(),
              style: TextStyle(
                fontSize: widget.fontSize * 0.2,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
                letterSpacing: 2,
              ),
            ),
          ),
      ],
    );
  }
}
