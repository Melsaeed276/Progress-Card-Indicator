import 'package:flutter/material.dart';
import 'package:progress_card/progress_card.dart';

void main() => runApp(const ShowcaseApp());

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colors = ShowcaseColors();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors.primaryStart),
      ),
      home: const ShowcasePage(colors: colors),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  final ShowcaseColors colors;
  const ShowcasePage({super.key, required this.colors});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final _idController = TextEditingController(text: '5');
  final _stepController = TextEditingController(text: 'Review designs');
  final _stepPctController = TextEditingController(text: '60');

  double _idPct = 35;
  double _stepPct = 60;
  double _pct34 = 75;
  String _stepText = 'Review designs';
  late ShowcaseColors _colors;

  static const _presets = <String, ShowcaseColors>{
    'Default': ShowcaseColors(),
    'Ocean': ShowcaseColors(
      primaryStart: Color(0xFF3366FF),
      primaryEnd: Color(0xFF00A4CC),
      track: Color(0xFFDDE7FF),
      pageBackground: Color(0xFFF3F7FF),
    ),
    'Sunset': ShowcaseColors(
      primaryStart: Color(0xFFFF7A59),
      primaryEnd: Color(0xFFFFC145),
      track: Color(0xFFFFE6DB),
      pageBackground: Color(0xFFFFF8F3),
    ),
  };
  String _selectedPreset = 'Default';

  @override
  void initState() {
    super.initState();
    _colors = widget.colors;
  }

  @override
  void dispose() {
    _idController.dispose();
    _stepController.dispose();
    _stepPctController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({String? suffixText, String? counterText}) {
    return InputDecoration(
      suffixText: suffixText,
      counterText: counterText,
      filled: true,
      fillColor: _colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _colors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _colors.primaryStart, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.pageBackground,
      appBar: AppBar(
        title: const Text('Border Progress Cards'),
        backgroundColor: _colors.surface,
        foregroundColor: _colors.appBarForeground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Preset'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedPreset,
                  items: _presets.keys
                      .map((key) => DropdownMenuItem(value: key, child: Text(key)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedPreset = value;
                      _colors = _presets[value]!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _ColorSlider(
              label: 'Start',
              color: _colors.primaryStart,
              onChanged: (c) => setState(() => _colors = _colors.copyWith(primaryStart: c)),
            ),
            _ColorSlider(
              label: 'End',
              color: _colors.primaryEnd,
              onChanged: (c) => setState(() => _colors = _colors.copyWith(primaryEnd: c)),
            ),
            _ColorSlider(
              label: 'Track',
              color: _colors.track,
              onChanged: (c) => setState(() => _colors = _colors.copyWith(track: c)),
            ),
            const Text('1 — ID card (fits content)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    maxLength: 16,
                    decoration: _inputDecoration(counterText: ''),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(suffixText: '%'),
                    onChanged: (v) => setState(() {
                      _idPct = (double.tryParse(v) ?? 0).clamp(0, 100);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicWidth(
              child: BorderProgressCard(
                percentage: _idPct / 100,
                progressStartColor: _colors.primaryStart,
                progressEndColor: _colors.primaryEnd,
                trackColor: _colors.track,
                surfaceColor: _colors.surface,
                innerBorderColor: _colors.innerBorder,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Text(
                    _idController.text.isEmpty ? '—' : _idController.text,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            BorderProgressCard(
              percentage: _stepPct / 100,
              progressStartColor: _colors.primaryStart,
              progressEndColor: _colors.primaryEnd,
              trackColor: _colors.track,
              surfaceColor: _colors.surface,
              innerBorderColor: _colors.innerBorder,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _stepController,
                      decoration: _inputDecoration(),
                      onChanged: (v) => _stepText = v,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _stepPctController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(suffixText: '%'),
                      onChanged: (v) {
                        setState(() {
                          _stepPct = (double.tryParse(v) ?? 0).clamp(0, 100);
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(_stepText),
                    Text('${_stepPct.round()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Slider(
              value: _pct34,
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: Color.lerp(
                _colors.primaryStart,
                _colors.primaryEnd,
                _pct34 / 100,
              ),
              onChanged: (v) => setState(() => _pct34 = v),
            ),
          ],
        ),
      ),
    );
  }
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
  });

  ShowcaseColors copyWith({
    Color? primaryStart,
    Color? primaryEnd,
    Color? pageBackground,
    Color? surface,
    Color? appBarForeground,
    Color? inputFill,
    Color? inputBorder,
    Color? track,
    Color? innerBorder,
  }) {
    return ShowcaseColors(
      primaryStart: primaryStart ?? this.primaryStart,
      primaryEnd: primaryEnd ?? this.primaryEnd,
      pageBackground: pageBackground ?? this.pageBackground,
      surface: surface ?? this.surface,
      appBarForeground: appBarForeground ?? this.appBarForeground,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      track: track ?? this.track,
      innerBorder: innerBorder ?? this.innerBorder,
    );
  }
}

class _ColorSlider extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const _ColorSlider({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50, child: Text(label)),
        Expanded(
          child: Slider(
            value: HSVColor.fromColor(color).hue,
            min: 0,
            max: 360,
            onChanged: (hue) {
              final hsv = HSVColor.fromColor(color).withHue(hue);
              onChanged(hsv.toColor());
            },
          ),
        ),
      ],
    );
  }
}
