import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import '../parser.dart';

class IsolateParser implements Parser {
  @override
  Future<Object> parse(String json) async {
    final receivePort = ReceivePort("From Main");
    final completer = Completer();
    late Isolate isolate;

    receivePort.first.then((data) {
      isolate.kill();
      completer.complete(data);
    });

    isolate = await Isolate.spawn((message) {
      final (json, sendPort) = message;
      final obj = jsonDecode(json) as Object;
      sendPort.send(obj);
    }, (json, receivePort.sendPort));

    final res = await completer.future;
    receivePort.close();
    isolate.kill();
    return res;
  }
}
