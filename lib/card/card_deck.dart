import 'dart:collection';
import 'package:CardBoom/card/card.dart';
import 'package:CardBoom/output/delegate_displayable.dart';
import 'package:CardBoom/output/displayable.dart';

class CardDeck extends DelegateDisplayable {
  Queue<Card> _deck;

  CardDeck.empty() : _deck = new Queue<Card>();

  void push(Card card) {
    _deck.add(card);
  }

  Card pop() => _deck.isEmpty ? null : _deck.removeFirst();

  Card get last => _deck.last;

  Card removeLast() => _deck.removeLast();

  int get length => _deck.length;

  bool get isEmpty => _deck.isEmpty;

  void forEachCard(void action(Card)) => _deck.forEach(action);

  @override
  Displayable get delegate => _deck.last;
}
