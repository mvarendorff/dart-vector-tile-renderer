import 'dart:ui';

import 'package:vector_tile/vector_tile_feature.dart';
import 'package:vector_tile_renderer/src/expressions/expression.dart';

import '../context.dart';
import 'selector.dart';
import 'style.dart';
import 'theme.dart';

class DefaultLayer extends ThemeLayer {
  final FeatureSelector selector;
  final Style style;
  final String source;
  final String sourceLayer;

  DefaultLayer(String id, ThemeLayerType type,
      {required this.selector,
      required this.style,
      required this.source,
      required this.sourceLayer,
      required double? minzoom,
      required double? maxzoom})
      : super(id, type, minzoom: minzoom, maxzoom: maxzoom);

  @override
  void render(Context context) {
    context
        .tile(source)
        ?.layers
        .where((l) => l.name == sourceLayer)
        .forEach((layer) {
      selector.features(layer.features, context).forEach((feature) {
        context.featureRenderer.render(context, type, style, layer, feature);
        if (!context.tileset.preprocessed) {
          _releaseMemory(feature);
        }
      });
    });
  }

  void _releaseMemory(VectorTileFeature feature) {
    feature.properties = null;
    feature.geometry = null;
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
