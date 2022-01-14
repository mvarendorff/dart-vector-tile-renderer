import '../expression.dart';

class NotExpression extends Expression<bool> {
  final Expression<bool> delegate;

  NotExpression(this.delegate);

  String get cacheKey => 'not_${delegate.cacheKey}';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final result = delegate.evaluate(args) ?? false;
    return !result;
  }
}
