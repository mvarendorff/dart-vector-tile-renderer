import 'expression.dart';

class ValueExpression<T> extends Expression<T> {
  final T? _value;
  ValueExpression(this._value);

  T? evaluateWithArgs(Map<String, dynamic> values) => _value;
}
