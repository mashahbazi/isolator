import 'dart:async';

abstract interface class Parser {
  FutureOr<Object> parse(String json);
}
