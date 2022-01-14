import 'package:vector_tile_renderer/src/themes/theme_function_model.dart';

import '../expression.dart';
import 'interpolation_expression.dart';

class ExponentialInterpolationExpression<T> extends InterpolationExpression<T> {
  final double _base;

  String get cacheKey =>
      'inter_expo_${_base}_${input.cacheKey}_${stops.map((s) => s.cacheKey).join(',')}';

  ExponentialInterpolationExpression(
      this._base, Expression<double> input, List<FunctionStop<T>> stops)
      : super(input, stops);

  @override
  double getInterpolationFactor(
          double input, double lowerValue, double upperValue) =>
      exponentialInterpolation(input, _base, lowerValue, upperValue);
}
