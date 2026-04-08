import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ─────────────────────────────────────────────
//  Entry point
// ─────────────────────────────────────────────
void main() => runApp(const ShowcaseApp());

class ShowcaseApp extends StatelessWidget {
  final ShowcaseColors colors;

  const ShowcaseApp({
    super.key,
    this.colors = const ShowcaseColors(),
  });

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      debugShowCheckedModeBanner: false,
      color: colors.primaryStart,
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      textStyle: TextStyle(
        color: colors.appBarForeground,
        fontFamily: 'SF Pro Display',
      ),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
        );
      },
      home: Material(
        color: colors.pageBackground,
        child: ShowcasePage(colors: colors),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Showcase Page
// ─────────────────────────────────────────────
class ShowcasePage extends StatefulWidget {
  final ShowcaseColors colors;

  const ShowcasePage({
    super.key,
    this.colors = const ShowcaseColors(),
  });

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  // Card 1 — ID card
  final _idController = TextEditingController(text: '5');
  double _idPct = 35;

  // Card 2 — Step / text card
  final _stepController = TextEditingController(text: 'Review designs');
  final _stepPctController = TextEditingController(text: '60');
  String _stepText = 'Review designs';
  double _stepPct = 60;

  // Cards 3 & 4 — percentage inside
  double _pct34 = 75;

  @override
  void dispose() {
    _idController.dispose();
    _stepController.dispose();
    _stepPctController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    String? suffixText,
    String? counterText,
  }) {
    return InputDecoration(
      suffixText: suffixText,
      counterText: counterText,
      filled: true,
      fillColor: widget.colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.colors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.colors.primaryStart, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colors.pageBackground,
      appBar: AppBar(
        title: const Text('Border Progress Cards'),
        backgroundColor: widget.colors.surface,
        foregroundColor: widget.colors.appBarForeground,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card 1 ──────────────────────────────
            _SectionLabel(label: '1 — ID card (fits content)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _LabeledField(
                    label: 'ID',
                    child: TextField(
                      controller: _idController,
                      maxLength: 16,
                      decoration: _inputDecoration(counterText: ''),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: _LabeledField(
                    label: 'Percentage',
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(suffixText: '%'),
                      onChanged: (v) => setState(() {
                        _idPct = (double.tryParse(v) ?? 0).clamp(0, 100);
                      }),
                      controller: TextEditingController(
                          text: _idPct.round().toString())
                        ..selection = TextSelection.collapsed(
                            offset: _idPct.round().toString().length),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ID card — intrinsic size
            IntrinsicWidth(
              child: BorderProgressCard(
                percentage: _idPct / 100,
                strokeWidth: 8,
                borderRadius: 13,
                progressStartColor: widget.colors.primaryStart,
                progressEndColor: widget.colors.primaryEnd,
                trackColor: widget.colors.track,
                surfaceColor: widget.colors.surface,
                innerBorderColor: widget.colors.innerBorder,
                child: Text(
                    _idController.text.isEmpty ? '—' : _idController.text,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Courier',
                    ),
                  ),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 28),

            // ── Card 2 ──────────────────────────────
            _SectionLabel(label: '2 — Step / text card'),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _LabeledField(
                    label: 'Step text',
                    child: TextField(
                      controller: _stepController,
                      decoration: _inputDecoration(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: _LabeledField(
                    label: 'Percentage',
                    child: TextField(
                      controller: _stepPctController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(suffixText: '%'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.colors.primaryStart,
                      foregroundColor: widget.colors.buttonText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => setState(() {
                      _stepText = _stepController.text.isEmpty
                          ? 'Step'
                          : _stepController.text;
                      _stepPct =
                          (double.tryParse(_stepPctController.text) ?? 0)
                              .clamp(0, 100);
                    }),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BorderProgressCard(
              percentage: _stepPct / 100,
              strokeWidth: 8,
              borderRadius: 13,
              progressStartColor: widget.colors.primaryStart,
              progressEndColor: widget.colors.primaryEnd,
              trackColor: widget.colors.track,
              surfaceColor: widget.colors.surface,
              innerBorderColor: widget.colors.innerBorder,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _stepText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_stepPct.round()}%',
                      style: TextStyle(
                          fontSize: 13, color: widget.colors.mutedText),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 28),

            // ── Cards 3 & 4 ─────────────────────────
            _SectionLabel(label: '3 & 4 — Percentage inside'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Percentage',
                    style:
                        TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: _pct34,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: _progressColor(
                      _pct34 / 100,
                      start: widget.colors.primaryStart,
                      end: widget.colors.primaryEnd,
                    ),
                    onChanged: (v) => setState(() => _pct34 = v),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${_pct34.round()}%',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('with border',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                      const SizedBox(height: 8),
                      BorderProgressCard(
                        percentage: _pct34 / 100,
                        strokeWidth: 8,
                        borderRadius: 13,
                        progressStartColor: widget.colors.primaryStart,
                        progressEndColor: widget.colors.primaryEnd,
                        trackColor: widget.colors.track,
                        surfaceColor: widget.colors.surface,
                        innerBorderColor: widget.colors.innerBorder,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_pct34.round()}%',
                                style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              const Text('complete',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black45)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('without border',
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.colors.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: widget.colors.innerBorder, width: 0.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_pct34.round()}%',
                              style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            const Text('complete',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BorderProgressCard widget
// ─────────────────────────────────────────────
class BorderProgressCard extends StatelessWidget {
  final double percentage; // 0.0 → 1.0
  final Widget child;
  final double strokeWidth;
  final double borderRadius;
  final Color progressStartColor;
  final Color progressEndColor;
  final Color trackColor;
  final Color surfaceColor;
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

// ─────────────────────────────────────────────
//  CustomPainter
// ─────────────────────────────────────────────
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
    final rect = Rect.fromLTWH(half, half, size.width - strokeWidth,
        size.height - strokeWidth);

    // Track
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (percentage <= 0) return;

    // Progress path — starts top-left going clockwise
    final path = _buildPath(rect, borderRadius);
    final metrics = path.computeMetrics().first;
    final progressPath =
        metrics.extractPath(0, metrics.length * percentage);

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
    path.arcToPoint(Offset(x + w, y + rd),
        radius: Radius.circular(rd));
    path.lineTo(x + w, y + h - rd);
    path.arcToPoint(Offset(x + w - rd, y + h),
        radius: Radius.circular(rd));
    path.lineTo(x + rd, y + h);
    path.arcToPoint(Offset(x, y + h - rd),
        radius: Radius.circular(rd));
    path.lineTo(x, y + rd);
    path.arcToPoint(Offset(x + rd, y),
        radius: Radius.circular(rd));
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_RectProgressPainter old) =>
      old.percentage != percentage ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}

// ─────────────────────────────────────────────
//  Color helper — purple → teal blend
// ─────────────────────────────────────────────
Color _progressColor(
  double t, {
  required Color start,
  required Color end,
}) {
  return Color.lerp(start, end, t.clamp(0.0, 1.0))!;
}

class ShowcaseColors {
  final Color primaryStart;
  final Color primaryEnd;
  final Color pageBackground;
  final Color surface;
  final Color appBarForeground;
  final Color inputFill;
  final Color inputBorder;
  final Color track;
  final Color innerBorder;
  final Color mutedText;
  final Color buttonText;

  const ShowcaseColors({
    this.primaryStart = const Color(0xFF7F77DD),
    this.primaryEnd = const Color(0xFF1D9E75),
    this.pageBackground = const Color(0xFFF5F5F5),
    this.surface = Colors.white,
    this.appBarForeground = Colors.black87,
    this.inputFill = const Color(0xFFF5F5F5),
    this.inputBorder = const Color(0xFFD5D5D5),
    this.track = const Color(0xFFECECEC),
    this.innerBorder = const Color(0xFFECECEC),
    this.mutedText = const Color(0xFF9E9E9E),
    this.buttonText = Colors.white,
  });
}

// ─────────────────────────────────────────────
//  Small helper widgets
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Colors.grey.shade400,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: Colors.black45)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}