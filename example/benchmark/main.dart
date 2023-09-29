import 'data/raw_json.dart';
import 'parser.dart';
import 'parser/compute_parser.dart';
import 'parser/isolate_parser.dart';
import 'parser/isolator_parser.dart';
import 'parser/simple_parser.dart';

void main() async {
  const count = 500;
  print("Test length: $count");

  for (final json in listJson) {
    print("====================================");
    print('Json Length: ${json.length}');
    print("Using simple parser");
    await parse(SimpleParser(), json, count);
    await parseAsync(SimpleParser(), json, count);
    print("Using compute parser");
    await parse(ComputeParser(), json, count);
    await parseAsync(ComputeParser(), json, count);
    print("Using isolate parser");
    await parse(IsolateParser(), json, count);
    await parseAsync(IsolateParser(), json, count);
    print("Using isolator parser");
    await parse(IsolatorParser(), json, count);
    await parseAsync(IsolatorParser(), json, count);
    print("====================================");
  }
}

Future<void> parse(Parser parser, json, int count) async {
  DateTime start = DateTime.now();
  for (int i = 0; i < count; i++) {
    await parser.parse(json);
  }
  print(
      "Parse Duration: ${DateTime.now().difference(start).inMicroseconds} Milli Second");
}

Future<void> parseAsync(Parser parser, json, int count) async {
  DateTime start = DateTime.now();
  final res = await Future.wait(
      List.filled(count, 0).map((e) async => parser.parse(json)));
  print(
      "Parse Async Duration: ${DateTime.now().difference(start).inMicroseconds} Milli Second");
}
