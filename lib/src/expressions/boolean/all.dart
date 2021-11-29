import '../expression.dart';

class AllExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  AllExpression(this.delegates);

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .every((d) => d.evaluate(args) ?? false);
  }
}
