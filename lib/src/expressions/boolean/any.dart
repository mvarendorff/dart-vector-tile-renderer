import '../expression.dart';

class AnyExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  AnyExpression(this.delegates);

  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .any((element) => element.evaluate(args) ?? false);
  }
}
