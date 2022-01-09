import '../../vector_tile_renderer.dart';
import '../context.dart';
import '../expressions/expression.dart';
import '../features/to_args_map.dart';
import 'expression/expressionle_renderer/src/expressions/value_expression.dart';

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
