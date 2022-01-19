import 'expression.dart';

class ValueExpression<T> extends Expression<T> {
  final T? _value;

  String get cacheKey => 'val_$_value';

  ValueExpression(this._value);

  T? evaluateWithArgs(Map<String, dynamic> values) => _value;

  @override
  Set<String> properties() => {};
}
