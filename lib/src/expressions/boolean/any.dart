import '../expression.dart';

class AnyExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  AnyExpression(this.delegates);

  String get cacheKey => 'any_${delegates.map((e) => e?.cacheKey).join(',')}';

  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .any((element) => element.evaluate(args) ?? false);
  }

  @override
  Set<String> properties() => delegates
      .whereType<Expression<bool>>()
      .expand((e) => e.properties())
      .toSet();
}
