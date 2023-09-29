import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:uuid/uuid.dart';

import '../parser.dart';

class IsolatorParser implements Parser {
  final uuid = Uuid();
  final Map<String, Completer> _mapTaskCompleter = {};

  Completer<IsolatePort>? _completer;

  @override
  Future<Object> parse(String json) async {
    final port = await getPort();
    final key = uuid.v4();
    final completer = Completer();
    _mapTaskCompleter[key] = completer;

    port.receiver.onData(_onReceiveData);

    port.sender.send((key, json));

    return completer.future;
  }

  Future<IsolatePort> getPort() async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<IsolatePort>();
    final Completer<IsolatePort> completer = _completer!;
    final receivePort = ReceivePort("From Main");
    final sub = receivePort.listen((message) {});
    sub.onData((data) {
      if (data is SendPort && !completer.isCompleted) {
        completer.complete(IsolatePort(data, sub));
      }
    });

    Isolate.spawn((sendPort) {
      ReceivePort receivePort = ReceivePort("From isolate");
      receivePort.listen((message) async {
        if (message is (String, String)) {
          final (key, json) = message;
          final obj = jsonDecode(json) as Object;
          sendPort.send((key, obj));
        }
      });
      sendPort.send(receivePort.sendPort);
    }, receivePort.sendPort);
    final port = await completer.future;
    return port;
  }

  void _onReceiveData(data) {
    if (data is (String, Object)) {
      final completer = _mapTaskCompleter[data.$1];
      if (completer != null) {
        completer.complete(data.$2);
        _mapTaskCompleter.remove(data.$1);
      }
    }
  }
}

class IsolatePort {
  final SendPort sender;
  final StreamSubscription<dynamic> receiver;

  IsolatePort(this.sender, this.receiver);
}
