import '../expression.dart';

class NumericComparisonExpression extends Expression<bool> {
  final String op;
  final Expression<double> a;
  final Expression<double> b;

  NumericComparisonExpression(this.op, this.a, this.b);

  String get cacheKey => '${op}_${a.cacheKey}_${b.cacheKey}';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final aValue = a.evaluate(args)!;
    final bValue = b.evaluate(args)!;

    switch (op) {
      case '>=':
        return aValue >= bValue;
      case '<=':
        return aValue <= bValue;
      case '<':
        return aValue < bValue;
      case '>':
        return aValue > bValue;
    }
  }
}
