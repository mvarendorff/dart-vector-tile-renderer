import 'package:vector_tile_renderer/src/themes/theme_function_model.dart';

import '../expression.dart';
import 'interpolation_expression.dart';

class LinearInterpolationExpression<T> extends InterpolationExpression<T> {
  String get cacheKey =>
      'inter_lin_${input.cacheKey}_${stops.map((s) => s.cacheKey).join(',')}';

  LinearInterpolationExpression(
      Expression<double> input, List<FunctionStop<T>> stops)
      : super(input, stops);

  @override
  double getInterpolationFactor(
          double input, double lowerValue, double upperValue) =>
      exponentialInterpolation(input, 1, lowerValue, upperValue);
}
