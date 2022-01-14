import 'expression.dart';

class NumericTermExpression extends Expression<double> {
  final String op;
  final Expression<double> a;
  final Expression<double> b;

  String get cacheKey => '${op}_${a.cacheKey}_${b.cacheKey}';

  NumericTermExpression(this.op, this.a, this.b);

  @override
  double? evaluateWithArgs(Map<String, dynamic> args) {
    final aValue = a.evaluate(args) ?? 0;
    final bValue = b.evaluate(args) ?? 0;

    switch (op) {
      case '+':
        return aValue + bValue;
      case '-':
        return aValue - bValue;
      case '*':
        return aValue * bValue;
      case '/':
        return aValue / bValue;
    }
  }
}
