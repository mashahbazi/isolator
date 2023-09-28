import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import '../parser.dart';

class ComputeParser implements Parser {
  @override
  Future<Object> parse(String json) {
    return Isolate.run(() => jsonDecode(json));
  }
}
