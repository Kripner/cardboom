import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:CardBoom/output/displayable.dart';
import 'dart:io';

class ResourceDisplayable extends Displayable {
  static const String basePath = "resources/";

  Future _initialization;
  Queue<String> _lines = new Queue<String>();
  int _width;

  ResourceDisplayable(String relativePath) {
    _initialization = _init(relativePath);
  }

  Future _init(String relativePath) async {
    File resource = new File(basePath + relativePath);
    await resource.openRead().transform(new Utf8Decoder()).transform(new LineSplitter()).forEach((line) => _lines.add(line));
    _width = _lines.map((line) => line.length).fold(0, (max, current) => current > max ? current : max);
  }

  @override
  Future<Iterator<String>> get linesIterator async {
    await _initialization;
    return _lines.iterator;
  }

  @override
  Future<int> get width async {
    await _initialization;
    return _width;
  }
}
