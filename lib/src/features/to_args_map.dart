import 'package:vector_tile/vector_tile_feature.dart';

import '../context.dart';
import '../extensions.dart';

Map<String, dynamic> toArgsMap(Context context, VectorTileFeature feature) => {
      ...featureToArgsMap(feature),
      'zoom': context.zoom,
    };

Map<String, dynamic> featureToArgsMap(VectorTileFeature feature) => {
      ...feature.decodeProperties(),
      'geometry-type': feature.type?.toArgsString(),
      '\$type': feature.type?.toArgsString(),
    };
