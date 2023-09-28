import 'dart:async';
import 'dart:convert';

import '../parser.dart';

class SimpleParser implements Parser {
  @override
  FutureOr<Object> parse(String json) {
    return jsonDecode(json);
  }
}
