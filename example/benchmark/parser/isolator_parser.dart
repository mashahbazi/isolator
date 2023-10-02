import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:uuid/uuid.dart';

import '../parser.dart';

final list = [];

class IsolatorParser implements Parser {
  final uuid = Uuid();
  final Map<String, Completer> _mapTaskCompleter = {};

  Completer<IsolatePort>? _completer;

  @override
  Future<Object> parse(String json) async {
    final port = await getPort();
    final key = uuid.v4();
    // print(key);
    _mapTaskCompleter[key] = Completer();

    port.sender.send((key, json));

    return await _mapTaskCompleter[key]!.future;
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
      }else{
        _onReceiveData(data);
      }
    });

    Isolate.spawn((sendPort) {
      ReceivePort receivePort = ReceivePort("From isolate");
      receivePort.listen((message) async {
        if (message is (String, String)) {
          final (key, json) = message;
          final obj = jsonDecode(json) as Object;
          // print(obj.hashCode);
          sendPort.send((key, obj));
        }
      });
      sendPort.send(receivePort.sendPort);
    }, receivePort.sendPort);

    return completer.future;
  }

  void _onReceiveData(data) {
    if (data is (String, Object)) {
      final completer = _mapTaskCompleter[data.$1];
      if (completer != null) {
        completer.complete(data.$2);
      }
    }
  }
}

class IsolatePort {
  final SendPort sender;
  final StreamSubscription<dynamic> receiver;

  IsolatePort(this.sender, this.receiver);
}
