import '../expression.dart';

class AllExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  AllExpression(this.delegates);

  String get cacheKey => 'all_${delegates.map((e) => e?.cacheKey).join(',')}';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .every((d) => d.evaluate(args) ?? false);
  }
}
