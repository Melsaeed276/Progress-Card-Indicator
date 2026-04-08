import 'package:flutter/material.dart';

/// A content card with a rounded border progress indicator around it.
class BorderProgressCard extends StatelessWidget {
  /// Progress value from 0.0 to 1.0.
  final double percentage;

  /// Child shown inside the card.
  final Widget child;

  /// Stroke width of the outer progress border.
  final double strokeWidth;

  /// Radius used for both inner card and outer progress shape.
  final double borderRadius;

  /// Gradient start color for progress.
  final Color progressStartColor;

  /// Gradient end color for progress.
  final Color progressEndColor;

  /// Color of the inactive track border.
  final Color trackColor;

  /// Fill color of the inner card surface.
  final Color surfaceColor;

  /// Border color of the inner card.
  final Color innerBorderColor;

  const BorderProgressCard({
    super.key,
    required this.percentage,
    required this.child,
    this.strokeWidth = 8.0,
    this.borderRadius = 13.0,
    this.progressStartColor = const Color(0xFF7F77DD),
    this.progressEndColor = const Color(0xFF1D9E75),
    this.trackColor = const Color(0xFFECECEC),
    this.surfaceColor = Colors.white,
    this.innerBorderColor = const Color(0xFFECECEC),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RectProgressPainter(
        percentage: percentage.clamp(0.0, 1.0),
        progressColor: _progressColor(
          percentage,
          start: progressStartColor,
          end: progressEndColor,
        ),
        trackColor: trackColor,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.all(strokeWidth / 2 + 2),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: innerBorderColor, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

class _RectProgressPainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;
  final double borderRadius;

  const _RectProgressPainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final half = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      half,
      half,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (percentage <= 0) return;

    final path = _buildPath(rect, borderRadius);
    final metrics = path.computeMetrics().first;
    final progressPath = metrics.extractPath(0, metrics.length * percentage);

    canvas.drawPath(
      progressPath,
      Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _buildPath(Rect r, double radius) {
    final path = Path();
    final x = r.left, y = r.top, w = r.width, h = r.height;
    final rd = radius;

    path.moveTo(x + rd, y);
    path.lineTo(x + w - rd, y);
    path.arcToPoint(Offset(x + w, y + rd), radius: Radius.circular(rd));
    path.lineTo(x + w, y + h - rd);
    path.arcToPoint(Offset(x + w - rd, y + h), radius: Radius.circular(rd));
    path.lineTo(x + rd, y + h);
    path.arcToPoint(Offset(x, y + h - rd), radius: Radius.circular(rd));
    path.lineTo(x, y + rd);
    path.arcToPoint(Offset(x + rd, y), radius: Radius.circular(rd));
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_RectProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

Color _progressColor(
  double t, {
  required Color start,
  required Color end,
}) {
  return Color.lerp(start, end, t.clamp(0.0, 1.0))!;
}
