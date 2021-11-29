import 'package:vector_tile/vector_tile.dart';
import 'package:vector_tile_renderer/src/expressions/value_expression.dart';

import '../context.dart';
import '../expressions/expression.dart';
import '../features/to_args_map.dart';

class FeatureSelector {
  final Expression<bool> expression;

  FeatureSelector(this.expression);

  Iterable<VectorTileFeature> features(
    Iterable<VectorTileFeature> features,
    Context context,
  ) =>
      features.where((f) => _featureIsSelected(f, context));

  bool _featureIsSelected(VectorTileFeature feature, Context context) {
    final args = toArgsMap(context, feature);
    return expression.evaluate(args) ?? false;
  }
}

class NoopFeatureSelector extends FeatureSelector {
  NoopFeatureSelector() : super(ValueExpression(true));
}
