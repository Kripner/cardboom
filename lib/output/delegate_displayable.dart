import 'dart:async';
import 'package:CardBoom/output/displayable.dart';

abstract class DelegateDisplayable extends Displayable {
  Displayable get delegate;

  @override
  Future<Iterator<String>> get linesIterator => delegate.linesIterator;

  @override
  Future<int> get width => delegate.width;
}
