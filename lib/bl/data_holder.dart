import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

enum DataState { progress, complete, error }

class DataModel<V> {
  final DataState state;
  final V? value;

  DataModel._({this.state = DataState.progress, this.value});
}

class DataHolder<V> implements Disposable {
  final StreamController<DataModel<V>> _controller = StreamController.broadcast();
  DataModel<V> _last = DataModel._(state: DataState.progress);

  Stream<DataModel<V>> get stream => _controller.stream;
  DataModel<V> get last => _last;
  V? get lastValue => _last.value;

  void progress([V? value]) => _notify(DataModel._(state: DataState.progress, value: value ?? lastValue));

  void complete([V? value]) => _notify(DataModel._(state: DataState.complete, value: value ?? lastValue));

  void error([V? value]) => _notify(DataModel._(state: DataState.error, value: value ?? lastValue));

  void _notify(DataModel<V> data) {
    if (!_controller.isClosed) {
      _last = data;
      _controller.add(data);
    }
  }



  @override
  void dispose() {
    _controller.close();
  }
}
