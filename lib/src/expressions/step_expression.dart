import 'expression.dart';

class Step<T> {
  final num step;
  final Expression<T>? value;

  Step(this.step, this.value);

  String get cacheKey => 'stepData_${step}_${value?.cacheKey}';
}

class StepExpression<T> extends Expression<T> {
  final Expression<double> _input;
  final Expression<T> _base;
  final List<Step<T>> _steps;

  String get cacheKey =>
      'step_${_input.cacheKey}_${_base.cacheKey}_${_steps.map((s) => s.cacheKey).join(',')}';

  StepExpression(this._input, this._base, this._steps)
      : assert(_steps.isNotEmpty);

  @override
  T? evaluateWithArgs(Map<String, dynamic> args) {
    final input = _input.evaluate(args)!;

    if (input <= _steps.first.step) {
      return _base.evaluate(args);
    }

    final lastLessThanStop = _steps.lastWhere(
      (stop) => stop.step < input,
    );
    return lastLessThanStop.value?.evaluate(args);
  }

  @override
  Set<String> properties() {
    final Set<String> result = {..._input.properties(), ..._base.properties()};

    for (final step in _steps) {
      if (step.value != null) result.addAll(step.value!.properties());
    }

    return result;
  }
}
