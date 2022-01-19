import 'dart:ui';

import 'package:vector_tile_renderer/src/features/to_args_map.dart';

import '../../vector_tile_renderer.dart';
import '../constants.dart';
import '../context.dart';
import '../themes/style.dart';
import 'feature_renderer.dart';
import 'points_extension.dart';

class PolygonRenderer extends FeatureRenderer {
  final Logger logger;
  PolygonRenderer(this.logger);

  @override
  void render(Context context, ThemeLayerType layerType, Style style,
      TileLayer layer, TileFeature feature) {
    if (style.fillPaint == null && style.outlinePaint == null) {
      logger
          .warn(() => 'polygon does not have a fill paint or an outline paint');
      return;
    }

    final polygons = feature.polygons;
    final args = toArgsMap(context, feature);

    if (polygons.length == 1) {
      logger.log(() => 'rendering polygon');
    } else if (polygons.length > 1) {
      logger.log(() => 'rendering multi-polygon');
    }

    for (final polygon in feature.polygons) {
      final path = Path();
      for (final ring in polygon) {
        path.addPolygon(ring.toPoints(layer.extent, tileSize), true);
      }
      if (!_isWithinClip(context, path)) {
        continue;
      }
      final fillPaint = style.fillPaint?.paint(args);
      if (fillPaint != null) {
        context.canvas.drawPath(path, fillPaint);
      }
      final outlinePaint = style.outlinePaint?.paint(args);
      if (outlinePaint != null) {
        context.canvas.drawPath(path, outlinePaint);
      }
    }
  }

  bool _isWithinClip(Context context, Path path) =>
      context.tileClip.overlaps(path.getBounds());
}
