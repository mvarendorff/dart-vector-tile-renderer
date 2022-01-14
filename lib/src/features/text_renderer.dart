import 'package:flutter/widgets.dart';
import 'package:vector_tile/vector_tile_feature.dart';
import 'package:vector_tile_renderer/src/expressions/expression.dart';

import '../context.dart';
import '../themes/style.dart';
import 'to_args_map.dart';

class TextApproximation {
  final Context context;
  final Style style;
  final String text;
  final VectorTileFeature feature;
  Offset? _translation;
  Size? _size;
  TextRenderer? _renderer;

  TextApproximation(this.context, this.style, this.text, this.feature) {
    final args = toArgsMap(context, feature);
    double? textSize = style.textLayout!.textSize.evaluate(args);
    if (textSize != null) {
      if (context.zoomScaleFactor > 1.0) {
        textSize = textSize / context.zoomScaleFactor;
      }
      final approximateWidth =
          (textSize / 1.9 * (text.length + 1)).ceilToDouble();
      final approximateHeight = (textSize * 1.28).ceilToDouble();
      final size = Size(approximateWidth, approximateHeight);
      _size = size;
      _translation = _offset(size, style.textLayout!.anchor?.evaluate(args));
    }
  }

  Size? get size => _size;
  Offset? get translation => _translation;

  bool get hasRenderer => _renderer != null;

  TextRenderer get renderer {
    var result = _renderer;
    if (result == null) {
      result = TextRenderer(context, style, text, feature);
      _renderer = result;
    }
    return result;
  }

  Rect? labelBox(Offset offset, {required bool translated}) {
    if (size == null) {
      return null;
    }
    return _labelBox(offset, _translation, size!.width, size!.height,
        translated: translated);
  }
}

class TextRenderer {
  final Context context;
  final Style style;
  final String text;
  final VectorTileFeature feature;

  late final TextPainter? _painter;
  late final Offset? _translation;

  TextRenderer(this.context, this.style, this.text, this.feature) {
    _painter = _createTextPainter(context, style, text);
    _translation = _layout();
  }

  double get textHeight => _painter!.height;
  Offset? get translation => _translation;

  Rect? labelBox(Offset offset, {required bool translated}) {
    if (_painter == null) {
      return null;
    }
    return _labelBox(offset, _translation, _painter!.width, _painter!.height,
        translated: translated);
  }

  void render(Offset offset) {
    TextPainter? painter = _painter;
    if (painter == null) {
      return;
    }

    if (_translation != null) {
      context.canvas.save();
      context.canvas.translate(_translation!.dx, _translation!.dy);
    }
    painter.paint(context.canvas, offset);
    if (_translation != null) {
      context.canvas.restore();
    }
  }

  TextPainter? _createTextPainter(Context context, Style style, String text) {
    final args = toArgsMap(context, feature);

    final foreground = style.textPaint!.paint(args);
    if (foreground == null) {
      return null;
    }
    double? textSize = style.textLayout!.textSize.evaluate(args);
    if (textSize != null) {
      if (context.zoomScaleFactor > 1.0) {
        textSize = textSize / context.zoomScaleFactor;
      }
      double? spacing;
      Expression<double>? spacingFunction = style.textLayout!.textLetterSpacing;
      if (spacingFunction != null) {
        spacing = spacingFunction.evaluate(args);
      }
      final shadows = style.textHalo?.evaluate(args);
      final textStyle = TextStyle(
          foreground: foreground,
          fontSize: textSize,
          letterSpacing: spacing,
          shadows: shadows,
          fontFamily: style.textLayout?.fontFamily,
          fontStyle: style.textLayout?.fontStyle);
      final textTransform = style.textLayout?.textTransform;
      final transformedText =
          textTransform == null ? text : textTransform(text);
      return TextPainter(
          text: TextSpan(style: textStyle, text: transformedText),
          textDirection: TextDirection.ltr)
        ..layout();
    }
  }

  Offset? _layout() {
    if (_painter == null) {
      return null;
    }
    final args = toArgsMap(context, feature);
    return _offset(_painter!.size, style.textLayout!.anchor?.evaluate(args));
  }
}

Offset? _offset(Size size, String? name) {
  final anchor = LayoutAnchor.fromName(name);

  switch (anchor) {
    case LayoutAnchor.center:
      return Offset(-size.width / 2, -size.height / 2);
    case LayoutAnchor.top:
      return Offset(-size.width / 2, 0);
  }
}

Rect? _labelBox(Offset offset, Offset? translation, double width, double height,
    {required bool translated}) {
  double x = offset.dx;
  double y = offset.dy;
  if (translation != null && translated) {
    x += (translation.dx);
    y += (translation.dy);
  }
  return Rect.fromLTWH(x, y, width, height);
}
