import 'package:vector_tile/vector_tile_feature.dart';
import 'package:vector_tile_renderer/src/vector_tile_extensions.dart';

import '../context.dart';
import '../extensions.dart';

toArgsMap(Context context, VectorTileFeature feature) => {
      ...feature.collectedProperties,
      'zoom': context.zoom,
      'geometry-type': feature.type?.toArgsString(),
      '\$type': feature.type?.toArgsString(),
    };
