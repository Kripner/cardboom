import 'dart:async';
import 'package:CardBoom/card/card_color.dart';
import 'package:CardBoom/card/card_value.dart';
import 'package:CardBoom/output/displayable.dart';
import 'package:CardBoom/utils.dart';

const List<String> cardColors = const ['♠', '♥', '♦', '♣'];
const List<String> cardValues = const ['7', '8', '9', '10', 'J', 'Q', 'K', 'A'];

class Card implements Displayable {
  final CardValue value;
  final CardColor color;

  Card(this.value, this.color);

  String get valueRepresentation => cardValues[value.index];
  String get colorRepresentation => cardColors[color.index];

  @override
  Future<Iterator<String>> get linesIterator async => new CardPrintingIterator(this);

  @override
  Future<int> get width async => CardPrintingIterator.width;

  @override
  String toString() {
    return '${cardValues[value.index]}${cardColors[color.index]}';
  }
}

class CardPrintingIterator implements Iterator<String> {
  static const int width = 34;
  static const int height = 26;

  final Card _card;
  int row = 0;

  CardPrintingIterator(this._card);

  @override
  String get current {
    if (row == 0 || row > height) return null;
    if (row == 1) return '┌${multiple('─', width - 2)}┐';
    if (row == 3) return '│ ${_card.valueRepresentation}${multiple(' ', width - 3 - _card.valueRepresentation.length)}│';
    if (row == height ~/ 2 || row == height ~/ 2 + 1)
      return '│'
          '${multiple(' ', width ~/ 2 - 2)}'
          '${_card.colorRepresentation}${_card.colorRepresentation}'
          '${multiple(' ', width ~/ 2 - 2)}'
          '│';
    if (row == height - 2) return '│${multiple(' ', width - 3 - _card.valueRepresentation.length)}${_card.valueRepresentation} │';
    if (row == height) return '└${multiple('─', width - 2)}┘';
    return '│${multiple(' ', width - 2)}│';
  }

  @override
  bool moveNext() {
    return ++row <= height;
  }
}
