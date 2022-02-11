import 'dart:ui';

import 'package:vector_tile_renderer/src/expressions/expression.dart';

import '../context.dart';
import '../tileset.dart';
import 'selector.dart';
import 'style.dart';
import 'theme.dart';

class DefaultLayer extends ThemeLayer {
  final TileLayerSelector selector;
  final Style style;
  final String source;
  final String sourceLayer;

  DefaultLayer(
    String id,
    ThemeLayerType type, {
    required this.selector,
    required this.style,
    required this.source,
    required this.sourceLayer,
    required double? minzoom,
    required double? maxzoom,
  }) : super(id, type, minzoom: minzoom, maxzoom: maxzoom);

  @override
  void render(Context context) {
    final features = context.tileset.resolver.resolveFeatures(this.selector, debugId: id);

    for (final feature in features) {
      context.featureRenderer
          .render(context, type, style, feature.layer, feature.feature);
    }
  }
}

class BackgroundLayer extends ThemeLayer {
  final Expression<Color> fillColor;

  BackgroundLayer(String id, this.fillColor)
      : super(id, ThemeLayerType.background, minzoom: 0, maxzoom: 24);

  @override
  void render(Context context) {
    context.logger.log(() => 'rendering $id');
    final effectiveColor =
        fillColor.evaluate({'zoom': context.zoom}) ?? Color(0x00000000);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = effectiveColor;
    context.canvas.drawRect(context.tileClip, paint);
  }
}
