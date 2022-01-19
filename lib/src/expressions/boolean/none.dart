import 'package:collection/collection.dart';

import '../expression.dart';

class NoneExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  NoneExpression(this.delegates);

  String get cacheKey => 'none_${delegates.map((e) => e?.cacheKey).join(',')}';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .none((e) => e.evaluate(args) ?? false);
  }

  @override
  Set<String> properties() => delegates
      .whereType<Expression<bool>>()
      .expand((e) => e.properties())
      .toSet();
}
