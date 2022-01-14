import '../expression.dart';

class HasExpression extends Expression<bool> {
  final String key;
  final bool negated;

  HasExpression(this.key, {this.negated = false});

  String get cacheKey => 'has_${key}_$negated}';

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final result = args.containsKey(key);

    return negated ? !result : result;
  }
}
