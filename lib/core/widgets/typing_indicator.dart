import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TypingIndicator extends StatefulWidget {
  final double dotSize;
  final Color? color;
  final bool showLabel;

  const TypingIndicator({
    super.key,
    this.dotSize = 6,
    this.color,
    this.showLabel = true,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel)
          Text(
            'Typing',
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),

        if (widget.showLabel) const SizedBox(width: 6),

        SizedBox(
          height: widget.dotSize * 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final t = (_controller.value + index * 0.2) % 1.0;
                  final scale =
                      0.6 + (0.4 * (1 - (t - 0.5).abs() * 2).clamp(0, 1));

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: widget.dotSize,
                        height: widget.dotSize,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
