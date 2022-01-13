import 'dart:developer';

/// Filter key for [TimelineTask]s that this library records.
///
/// Asynchronous tasks that are recorded by this library will be displayed in
/// their own lane, with this value as its name.
const _timelineTaskFilterKey = 'VectorTileRenderer';

/// Prefix for [Timeline] events that this library records.
///
/// By searching for this value in the DevTools Performance page, you can find
/// all the [Timeline] events recorded by this library.
const _timelinePrefix = 'VTR';

T profileSync<T>(String name, TimelineSyncFunction<T> function) {
  return Timeline.timeSync(_name(name), function);
}

T profileAsync<T>(String name, TimelineSyncFunction<T> function) {
  final task = TimelineTask(filterKey: _timelineTaskFilterKey)
    ..start(_name(name));
  try {
    return function();
  } finally {
    task.finish();
  }
}

String _name(String name) {
  return '$_timelinePrefix::$name';
}
