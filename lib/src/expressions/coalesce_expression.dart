import 'expression.dart';

class CoalesceExpression<T> extends Expression<T> {
  final List<Expression<T>> _delegates;

  String get cacheKey =>
      'coalesce_${_delegates.map((e) => e?.cacheKey).join(',')}';

  CoalesceExpression(this._delegates);

  @override
  T? evaluateWithArgs(Map<String, dynamic> args) {
    for (final delegate in _delegates) {
      final result = delegate.evaluate(args);
      if (result != null) return result;
    }

    return null;
  }
}
