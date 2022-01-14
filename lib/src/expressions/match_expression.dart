import 'package:vector_tile_renderer/src/expressions/expression.dart';

class Match<Input, Output> {
  final dynamic input;
  final Expression<Output>? output;

  Match(this.input, this.output)
      : assert(input is List<Input> || input is Input);

  String get cacheKey => 'matchData_${input}_${output?.cacheKey}';
}

class MatchExpression<Output, Input> extends Expression<Output> {
  final Expression<Input>? _compare;
  final List<Match<Input, Output>> _matches;
  final Expression<Output>? _fallback;

  String get cacheKey =>
      'match_${_compare?.cacheKey}_${_matches.map((m) => m.cacheKey).join(',')}_${_fallback?.cacheKey}';

  MatchExpression(this._compare, this._matches, this._fallback);

  @override
  Output? evaluateWithArgs(Map<String, dynamic> args) {
    final compare = _compare?.evaluate(args);
    if (compare == null) {
      return _fallback?.evaluate(args);
    }

    for (final match in _matches) {
      final input = match.input;
      if (input == compare ||
          (input is List && match.input.contains(compare))) {
        return match.output?.evaluate(args);
      }
    }

    return _fallback?.evaluate(args);
  }
}
