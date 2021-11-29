import 'package:collection/collection.dart';

import '../expression.dart';

class NoneExpression extends Expression<bool> {
  final List<Expression<bool>?> delegates;

  NoneExpression(this.delegates);

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    return delegates
        .whereType<Expression<bool>>()
        .none((e) => e.evaluate(args) ?? false);
  }
}
