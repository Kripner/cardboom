import 'dart:async';
import 'package:CardBoom/output/displayable.dart';

class NewLineDisplayable extends Displayable {
  final int newLines;

  NewLineDisplayable({this.newLines = 1});

  @override
  Future<Iterator<String>> get linesIterator async => new EmptyValuesIterator(newLines);

  @override
  Future<int> get width async => 0;
}

class EmptyValuesIterator implements Iterator<String> {
  int newLines;

  EmptyValuesIterator(this.newLines);

  @override
  String get current => '';

  @override
  bool moveNext() {
    return --newLines >= 0;
  }
}
