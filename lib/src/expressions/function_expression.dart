import 'expression.dart';

// This expression mostly exists to make the refactoring to Expressions easier.
//  It's probably desirable to work towards removing this eventually.
class FunctionExpression<T> extends Expression<T> {
  final T? Function(Map<String, dynamic> args) _evaluate;

  String get cacheKey => _evaluate.hashCode.toString();

  FunctionExpression(this._evaluate);

  @override
  T? evaluateWithArgs(Map<String, dynamic> args) => _evaluate(args);
}
