import 'package:meta/meta.dart';

abstract class Expression<T> {
  String get cacheKey;

  // This function may be used to implement a performant cache based on the
  //  the expression (this) and the args.
  T? evaluate(Map<String, dynamic> args) {
    return this.evaluateWithArgs(args);
  }

  @protected
  T? evaluateWithArgs(Map<String, dynamic> args);
}
