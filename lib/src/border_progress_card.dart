import 'package:flutter/material.dart';

/// A content card with a rounded border progress indicator around it.
///
/// The progress border is painted clockwise around a rounded rectangle,
/// starting near the top-left corner. The stroke is drawn with a linear
/// gradient that sweeps from [progressStartColor] to [progressEndColor]
/// across the widget's bounding box.
class BorderProgressCard extends StatelessWidget {
  /// Progress value from `0.0` to `1.0`.
  ///
  /// Values outside this range are clamped.
  final double percentage;

  /// Child shown inside the card.
  final Widget child;

  /// Stroke width of the outer progress border.
  ///
  /// Must be greater than `0`.
  final double strokeWidth;

  /// Radius used for both inner card and outer progress shape.
  ///
  /// Must be greater than or equal to `0`.
  final double borderRadius;

  /// Start color of the progress gradient (top-left region of the widget).
  final Color progressStartColor;

  /// End color of the progress gradient (bottom-right region of the widget).
  final Color progressEndColor;

  /// Color of the inactive track border.
  final Color trackColor;

  /// Fill color of the inner card surface.
  final Color surfaceColor;

  /// Border color of the inner card.
  final Color innerBorderColor;

  /// Gap in logical pixels between the progress stroke and the inner card.
  ///
  /// Defaults to `2`. Increase this to add more breathing room between the
  /// stroke and the card edge.
  final double gap;

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
    this.gap = 2.0,
  })  : assert(strokeWidth > 0, 'strokeWidth must be greater than 0'),
        assert(borderRadius >= 0, 'borderRadius must be >= 0'),
        assert(gap >= 0, 'gap must be >= 0');

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RectProgressPainter(
        percentage: percentage.clamp(0.0, 1.0),
        progressStartColor: progressStartColor,
        progressEndColor: progressEndColor,
        trackColor: trackColor,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.all(strokeWidth / 2 + gap),
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
  final Color progressStartColor;
  final Color progressEndColor;
  final Color trackColor;
  final double strokeWidth;
  final double borderRadius;

  const _RectProgressPainter({
    required this.percentage,
    required this.progressStartColor,
    required this.progressEndColor,
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

    // Draw the inactive track.
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (percentage <= 0) return;

    // Build the progress path and extract the filled portion.
    final path = _buildPath(rect, borderRadius);
    final metrics = path.computeMetrics().first;
    final progressPath = metrics.extractPath(0, metrics.length * percentage);

    // Create a linear gradient shader across the full widget bounds so the
    // gradient is consistent regardless of how much of the stroke is filled.
    final gradientShader = LinearGradient(
      colors: [progressStartColor, progressEndColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(
      progressPath,
      Paint()
        ..shader = gradientShader
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
        oldDelegate.progressStartColor != progressStartColor ||
        oldDelegate.progressEndColor != progressEndColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
