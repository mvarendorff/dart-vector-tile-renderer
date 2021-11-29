import '../expression.dart';

class InExpression<T> extends Expression<bool> {
  final Expression<T>? input;
  final Iterable<Expression<T>?> items;
  final bool negated;

  InExpression(this.input, this.items, {this.negated = false});

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final value = input?.evaluate(args);
    final result =
        items.map((i) => i?.evaluate(args)).whereType<T>().contains(value);

    return negated ? !result : result;
  }
}
