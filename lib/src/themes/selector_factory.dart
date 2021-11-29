import 'package:vector_tile_renderer/src/parsers/parsers.dart';

import '../logger.dart';
import 'selector.dart';

class SelectorFactory {
  final Logger logger;
  SelectorFactory(this.logger);

  FeatureSelector create(themeLayer) {
    final sourceLayer = themeLayer['source-layer'];
    if (sourceLayer != null && sourceLayer is String) {
      List<dynamic>? filter = themeLayer['filter'] as List<dynamic>?;
      if (filter == null) {
        return NoopFeatureSelector();
      }

      final expression = parse<bool>(filter)!;
      return FeatureSelector(expression);
    }
    throw Exception('theme layer has no source-layer: ${themeLayer['id']}');
  }
}
