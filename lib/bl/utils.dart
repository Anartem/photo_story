import 'dart:async';
import 'dart:isolate';

class Utils {
  static Future<T> isolate<T>(FutureOr<T> Function() function) async {
    final Worker<T> worker = Worker();
    await worker.isolateReady;
    return worker.work(function).whenComplete(() => worker.dispose());
  }
}

class Worker<T> {
  late SendPort _sendPort;
  late Isolate _isolate;

  Completer<T>? _completer;

  final _isolateReady = Completer<void>();

  Worker() {
    init();
  }

  Future<T> work(Function function) {
    _sendPort.send(function);
    _completer = Completer();
    return _completer!.future;
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
  }

  Future<void> get isolateReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  static void _isolateEntry(dynamic message) {
    late SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((message) async {
      assert (message is Function);
      sendPort.send(await message.call());
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }

    if (message is T) {
      _completer?.complete(message);
      _completer = null;
      return;
    }
  }
}
