import 'package:vector_tile_renderer/src/expressions/argument_expression.dart';
import 'package:vector_tile_renderer/src/expressions/boolean/none.dart';
import 'package:vector_tile_renderer/src/expressions/boolean/not.dart';
import 'package:vector_tile_renderer/src/expressions/value_expression.dart';

import '../expressions/boolean/all.dart';
import '../expressions/boolean/any.dart';
import '../expressions/boolean/equal.dart';
import '../expressions/boolean/has.dart';
import '../expressions/boolean/in.dart';
import '../expressions/boolean/numeric_comparisons.dart';
import '../expressions/expression.dart';
import 'parser.dart';
import 'parsers.dart' as Parsers;

class BooleanParser extends ExpressionParser<bool> {
  @override
  Expression<bool>? parse(dynamic data) {
    if (data is! List) {
      return null;
    }

    assert(
      data.length > 1 || (data.length == 1 && data.first == 'all'),
      'A boolean expression must be at least two elements long. A string '
      'literal defining the operation followed by the operation\'s arguments.\n'
      'See https://docs.mapbox.com/mapbox-gl-js/style-spec/expressions/#decision '
      'for a list of available boolean expressions.\n'
      'Failed parsing expression $data',
    );

    final op = data.first;
    if (op == 'has') {
      return _parseHas(data);
    } else if (op == '!has') {
      return _parseHas(data, negated: true);
    } else if (op == '<=' || op == '>=' || op == '<' || op == '>') {
      return _parseNumericComparison(data);
    } else if (op == 'all') {
      return _parseAll(data);
    } else if (op == 'any') {
      return _parseAny(data);
    } else if (op == 'none') {
      return _parseNone(data);
    } else if (op == '!') {
      return _parseNot(data);
    }

    if (data.length < 3) {
      throw Exception('Yikes $data');
    }

    final expressionType = determineInputType(data[2]);

    if (expressionType == String) {
      return _parseTyped<String>(data);
    } else if (expressionType == bool) {
      return _parseTyped<bool>(data);
    } else if (expressionType == double) {
      return _parseTyped<double>(data);
    }

    return null;
  }

  Expression<bool>? _parseTyped<T>(List<dynamic> data) {
    final op = data[0];
    if (op == '==') {
      return _parseEqual<T>(data);
    } else if (op == '!=') {
      return _parseEqual<T>(data, negated: true);
    } else if (op == 'in') {
      return _parseIn<T>(data);
    } else if (op == '!in') {
      return _parseIn<T>(data, negated: true);
    }
  }

  Expression<bool>? _parseHas(List<dynamic> data, {bool negated = false}) {
    assert(
      data.length == 2,
      'Using "has" with an object as argument is not supported yet.',
    );

    final key = data[1];
    return HasExpression(key, negated: negated);
  }

  Expression<bool>? _parseNumericComparison(List<dynamic> data) {
    final op = data[0];
    final a = _parseArgumentOrExpression<double>(data[1]);
    final b = Parsers.parse<double>(data[2])!;

    return NumericComparisonExpression(op, a, b);
  }

  Expression<bool>? _parseAll(List<dynamic> data) {
    if (data.length == 1) return ValueExpression(true);
    return AllExpression(_parseList(data));
  }

  Expression<bool>? _parseAny(List<dynamic> data) {
    return AnyExpression(_parseList(data));
  }

  Expression<bool>? _parseNone(List<dynamic> data) {
    return NoneExpression(_parseList(data));
  }

  List<Expression<bool>?> _parseList(List<dynamic> data) {
    final list = data.sublist(1);

    assert(
      list is List,
      '$list is not a list. A list is required for this kind of expression. Failed parsing expression $data',
    );

    return list.map((e) => Parsers.parse<bool>(e)).toList();
  }

  Expression<bool>? _parseNot(List<dynamic> data) {
    final delegate = Parsers.parse<bool>(data[1])!;
    return NotExpression(delegate);
  }

  Expression<bool>? _parseEqual<T>(List<dynamic> data, {bool negated = false}) {
    final a = _parseArgumentOrExpression<T>(data[1]);
    final b = Parsers.parse<T>(data[2]);

    return EqualExpression<T>(a, b, negated: negated);
  }

  Expression<bool>? _parseIn<T>(List<dynamic> data, {bool negated = false}) {
    final input = _parseArgumentOrExpression<T>(data[1]);

    assert(
      data.length > 2,
      'An "in" expression must have at least three parts: The string literal '
      '"in", followed by an expression indicating the input, followed by the '
      'values to compare to.\n'
      'See https://docs.mapbox.com/mapbox-gl-js/style-spec/expressions/#in for '
      'more information.\n'
      'Failed parsing expression $data',
    );

    final compareList = data.sublist(2).map((i) => Parsers.parse<T>(i));
    return InExpression<T>(input, compareList, negated: negated);
  }

  _parseArgumentOrExpression<T>(dynamic data) {
    return data.runtimeType == String
        ? ArgumentExpression<T>(data)
        : Parsers.parse<T>(data);
  }
}
