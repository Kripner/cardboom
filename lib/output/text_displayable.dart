import 'dart:async';
import 'package:CardBoom/output/displayable.dart';

class TextDisplayable implements Displayable {
  final String _text;

  TextDisplayable(this._text);

  @override
  Future<Iterator<String>> get linesIterator async => new SingeValueIterator(_text);

  @override
  Future<int> get width async => _text.length;
}

class SingeValueIterator implements Iterator<String> {
  String _text;
  bool active = false;

  SingeValueIterator(this._text);

  @override
  String get current => active ? _text : null;

  @override
  bool moveNext() {
    if (!active) return active = true;
    _text = null;
    return false;
  }
}
