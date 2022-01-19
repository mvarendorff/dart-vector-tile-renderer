import 'package:vector_tile_renderer/src/expressions/expression.dart';

class EqualExpression<T> extends Expression<bool> {
  final Expression<T>? a;
  final Expression<T>? b;
  final bool negated;

  EqualExpression(this.a, this.b, {this.negated = false});

  String get cacheKey => 'equal_${a?.cacheKey}_${b?.cacheKey}_$negated';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final aValue = a?.evaluate(args);
    final bValue = b?.evaluate(args);

    final equal = aValue == bValue;

    return negated ? !equal : equal;
  }

  @override
  Set<String> properties() {
    final Set<String> result = {};

    if (a != null) result.addAll(a!.properties());
    if (b != null) result.addAll(b!.properties());

    return result;
  }
}
