import 'dart:async';

abstract class Displayable {
  Future<Iterator<String>> get linesIterator;

  Future<int> get width;
}
