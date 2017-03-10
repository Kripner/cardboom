import 'dart:collection';
import 'package:CardBoom/card/card.dart';
import 'package:CardBoom/card/card_color.dart';
import 'package:CardBoom/card/card_value.dart';
import 'package:CardBoom/game.dart';
import 'package:CardBoom/move.dart';
import 'package:CardBoom/output/delegate_displayable.dart';
import 'package:CardBoom/output/displayable.dart';
import 'package:CardBoom/output/resource_displayable.dart';

class Player extends DelegateDisplayable {
  static const String facesPath = "faces/";

  Displayable _face;
  Queue<Card> _deck;
  String _name;

  Player(Queue<Card> deck, String face, String name)
      : _deck = deck,
        _name = name {
    _face = new ResourceDisplayable(facesPath + face);
  }

  void add(Card card) => _deck.add(card);

  Move play(GameState state) {
    Move findPlayable(bool test(Card needed), [Move convert(Card card)]) {
      Card playable = _deck.firstWhere(test, orElse: () => null);
      if (playable == null) return null;
      _deck.remove(playable);
      return convert == null ? new Move(playable) : convert(playable);
    }

    if (state.stop) return findPlayable((card) => card.value == CardValue.eso) ?? new Move.pass();
    if (state.takeMore) return findPlayable((card) => card.value == CardValue.sedma) ?? new Move.pass();
    CardColor convenientColor = _deck.firstWhere((card) => card.value != CardValue.svrsek, orElse: () => _deck.first).color;
    return findPlayable((card) => card.value != CardValue.svrsek && (card.value == state.activeValue || card.color == state.activeColor))
        ?? findPlayable((card) => card.value == CardValue.svrsek, (card) => new Move(card, changing: convenientColor))
        ?? new Move.pass();
  }

  bool won() {
    return _deck.isEmpty;
  }

  String get name => _name;

  int get numCards => _deck.length;

  Queue<Card> get deck => _deck;

  @override
  Displayable get delegate => _face;

  @override
  String toString() {
    return _name;
  }
}
