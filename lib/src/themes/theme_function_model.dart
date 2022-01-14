import 'dart:ui';

import 'package:vector_tile_renderer/src/expressions/expression.dart';
import 'package:vector_tile_renderer/src/parsers/parsers.dart';

class FunctionModel<T> {
  final Expression<double>? base;
  final List<FunctionStop<T>> stops;

  FunctionModel(this.base, this.stops);
}

class FunctionStop<T> {
  final Expression<double> zoom;
  final Expression<T> value;

  FunctionStop(this.zoom, this.value);

  String get cacheKey => '${zoom.cacheKey}_${value.cacheKey}';
}

class DoubleFunctionModelFactory {
  FunctionModel<double>? create(json) {
    final base = parse<double>(json['base']);
    final stops = json['stops'] as List<dynamic>?;

    if (stops == null) {
      if (base != null) {
        return FunctionModel<double>(base, []);
      }
      return null;
    }

    final modelStops = <FunctionStop<double>>[];
    for (final stop in stops) {
      final stopZoom = parse<double>(stop[0])!;
      final stopValue = parse<double>(stop[1])!;

      modelStops.add(FunctionStop<double>(stopZoom, stopValue));
    }

    return FunctionModel<double>(base, modelStops);
  }
}

class ColorFunctionModelFactory {
  FunctionModel<Color>? create(json) {
    Expression<double>? base = parse<double>(json['base']);

    final stops = json['stops'] as List<dynamic>?;
    if (stops == null) {
      if (base != null) {
        return FunctionModel<Color>(base, []);
      }
      return null;
    }
    final modelStops = <FunctionStop<Color>>[];
    for (final stop in stops) {
      final stopZoom = parse<double>(stop[0])!;
      final stopValue = parse<Color>(stop[1]);

      if (stopValue != null) {
        modelStops.add(FunctionStop<Color>(stopZoom, stopValue));
      }
    }
    return FunctionModel<Color>(base, modelStops);
  }
}
