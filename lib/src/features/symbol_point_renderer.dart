import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:vector_tile_renderer/src/features/to_args_map.dart';

import '../../vector_tile_renderer.dart';
import '../constants.dart';
import '../context.dart';
import '../themes/style.dart';
import 'feature_renderer.dart';
import 'text_abbreviator.dart';
import 'text_renderer.dart';

class SymbolPointRenderer extends FeatureRenderer {
  final Logger logger;
  SymbolPointRenderer(this.logger);

  @override
  void render(Context context, ThemeLayerType layerType, Style style,
      TileLayer layer, TileFeature feature) {
    final textPaint = style.textPaint;
    final textLayout = style.textLayout;
    if (textPaint == null || textLayout == null) {
      logger.warn(() => 'point does not have a text paint or layout');
      return;
    }
    final points = feature.points;
    logger.log(() => 'rendering points');
    final args = toArgsMap(context, feature);
    final text = textLayout.text.evaluate(args);
    final abbreviated =
        text == null ? null : TextAbbreviator().abbreviate(text);
    if (text != null &&
        context.labelSpace.canAccept(abbreviated) &&
        abbreviated != null) {
      final text = TextApproximation(context, style, abbreviated, feature);
      for (final point in points) {
        final x = (point.x / layer.extent) * tileSize;
        final y = (point.y / layer.extent) * tileSize;
        final offset = Offset(x, y);
        var box = text.labelBox(offset, translated: true);
        if (box != null && context.labelSpace.canOccupy(text.text, box)) {
          box = text.renderer.labelBox(offset, translated: true);
          if (box != null && context.labelSpace.canOccupy(text.text, box)) {
            context.labelSpace.occupy(text.text, box);
            text.renderer.render(Offset(x, y));
          }
        }
      }
    } else {
      logger.warn(() => 'point with no text');
    }
  }
}
