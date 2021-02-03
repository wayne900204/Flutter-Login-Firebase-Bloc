import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Style {

  // const Colors();

  static const Color mainColor = const Color(0xFFF6511D);
  static const Color secondColor = const Color(0xFFF6511D);
  static const Color grey = const Color(0xFFE5E5E5);
  static const Color background = const Color(0xFFf0f1f6);
  static const Color titleColor = const Color(0xFF061857);
  static const greenGradient = const LinearGradient(
    colors: const [ Color(0xFF00E676), Color(0xFF69F0AE),Color(0xFFB2EBF2), Color(0xFF00E5FF)],
    // stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
// Color(0xFF00E676),
// Color(0xFF69F0AE),
// Colors.cyan[100],
// Color(0xFF00E5FF),