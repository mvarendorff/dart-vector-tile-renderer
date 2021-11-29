import '../expression.dart';

class HasExpression extends Expression<bool> {
  final String key;
  final bool negated;

  HasExpression(this.key, {this.negated = false});

  @override
  bool? evaluateWithArgs(Map<String, dynamic> args) {
    final result = args.containsKey(key);

    return negated ? !result : result;
  }
}
