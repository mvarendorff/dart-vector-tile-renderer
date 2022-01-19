import '../../vector_tile_renderer.dart';
import '../context.dart';
import '../extensions.dart';

Map<String, dynamic> toArgsMap(Context context, TileFeature feature) => {
      ...featureToArgsMap(feature),
      'zoom': context.zoom,
    };

Map<String, dynamic> featureToArgsMap(TileFeature feature) => {
      ...feature.properties,
      'geometry-type': feature.type.toArgsString(),
      '\$type': feature.type.toArgsString(),
    };
