import 'expression.dart';

class Case<T> {
  final Expression<bool> condition;
  final Expression<T>? value;

  Case(this.condition, this.value);

  String get cacheKey => 'caseData_${condition.cacheKey}_${value?.cacheKey}';
}

class CaseExpression<T> extends Expression<T> {
  final Iterable<Case<T>> _cases;
  final Expression<T>? _fallback;

  String get cacheKey =>
      'case_${_cases.map((c) => c.cacheKey).join(',')}_${_fallback?.cacheKey}';

  CaseExpression(this._cases, this._fallback);

  @override
  T? evaluateWithArgs(Map<String, dynamic> args) {
    for (final $case in _cases) {
      final boolExpression = $case.condition.evaluate(args) ?? false;
      if (boolExpression) {
        return $case.value?.evaluate(args);
      }
    }

    return _fallback?.evaluate(args);
  }

  @override
  Set<String> properties() {
    final Set<String> result = {};

    if (_fallback != null) result.addAll(_fallback!.properties());
    for (final $case in _cases) {
      result.addAll($case.condition.properties());
      if ($case.value != null) result.addAll($case.value!.properties());
    }

    return result;
  }
}
