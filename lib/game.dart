// Copyright (c) 2017, Matěj Kripner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:CardBoom/card/card.dart';
import 'package:CardBoom/card/card_color.dart';
import 'package:CardBoom/card/card_deck.dart';
import 'package:CardBoom/card/card_value.dart';
import 'package:CardBoom/move.dart';
import 'package:CardBoom/output/newline_displayable.dart';
import 'package:CardBoom/output/printer.dart';
import 'package:CardBoom/output/resource_displayable.dart';
import 'package:CardBoom/output/text_displayable.dart';
import 'package:CardBoom/player.dart';
import 'package:CardBoom/settings.dart';

class GameState {
  static const TAKE_NORMAL = 1;

  CardValue activeValue;
  CardColor activeColor;
  bool stop = false;
  int take = TAKE_NORMAL;

  bool get takeMore => take > TAKE_NORMAL;
}

class Game {
  final Printer _printer = new Printer();
  final ResourceDisplayable _lady = new ResourceDisplayable(Settings.lady);
  final ResourceDisplayable _gun = new ResourceDisplayable(Settings.gun);
  final Random _random = new Random();

  List<Player> _players = [];
  int _nextPlayer = 0;
  CardDeck _receivingDeck = new CardDeck.empty();
  CardDeck _supplyingDeck = new CardDeck.empty();
  GameState _state = new GameState();
  int round = 0;
  bool ladyCame = false;

  Game() {
    Settings.check();
    List<String> faces = Settings.faces.toList()..shuffle();
    List<String> names = Settings.names.toList()..shuffle();
    List<Card> cards = CardValue.values.fold(new List<Card>(), (List<Card> list, value) {
      CardColor.values.forEach((color) => list.add(new Card(value, color)));
      return list;
    });
    cards.shuffle();
    Queue<Card> playersDeck = new Queue();
    for (Card card in cards) {
      if (_players.length < Settings.numPlayers) {
        if ((playersDeck..add(card)).length == Settings.initialCards) {
          _players.add(new Player(playersDeck, faces.removeLast(), names.removeLast()));
          playersDeck = new Queue();
        }
      } else
        _supplyingDeck.push(card);
    }

    var initCard = _supplyingDeck.pop();
    var initMove = new Move(initCard, changing: (initCard.value == CardValue.svrsek ? _supplyingDeck.last.color : null));
    _cardPlayed(initMove);
  }

  void launch() {
    intro();
    new Future.delayed(const Duration(milliseconds: Settings.introWait), () {
      print('May the game start!');
      _printState();
      new Future.delayed(const Duration(milliseconds: Settings.roundWait), () {
        print('** And ${_players[_nextPlayer]} beginns! **');
        _iteration();
      });
    });
  }

  void intro() {
    _printer.printObject(_gun);
    print('''
    Welcome to the wild salon.
    This is where guns rule and weak don\'t live long. If you\'re brave enough, sit down and watch the cowboys play their evening game.
    ''');
  }

  Future _iteration() async {
    bool playing = true;
    if (!ladyCame && round >= Settings.ladyMinRound && _random.nextDouble() < Settings.ladyProbability) {
      lady();
    } else {
      playing = await _playMove();
      await _printState();
      ++round;
    }
    if (playing) {
      new Future.delayed(const Duration(milliseconds: Settings.roundWait ~/ 2), () {
        print('** ${_players[_nextPlayer].name} to play **');
      });
      new Future.delayed(const Duration(milliseconds: Settings.roundWait), _iteration);
    }
  }

  Future<bool> _playMove() async {
    bool playing = true;
    Move move = _players[_nextPlayer].play(_state);
    if (_players[_nextPlayer].won()) {
      print('And ${_players[_nextPlayer].name} threw their last card! We have the winner ladies and gentlemen!');
      playing = false;
    }
    if (move.passed)
      _passed();
    else
      _cardPlayed(move);
    _nextPlayer = (_nextPlayer + 1) % _players.length;
    return playing;
  }

  void _passed() {
    if (!_state.stop) {
      if (_supplyingDeck.length < _state.take) {
        if (_receivingDeck.length < _state.take) throw "Not enough cards for pass";
        _supplyingDeck = _receivingDeck;
        _receivingDeck = new CardDeck.empty()..push(_supplyingDeck.removeLast());
      }
      while (--_state.take >= 0) _players[_nextPlayer].add(_supplyingDeck.pop());
      _state.take = GameState.TAKE_NORMAL;
    }
    _state.stop = false;
  }

  void _cardPlayed(Move move) {
    _receivingDeck.push(move.played);
    _state.activeValue = move.played.value;
    _state.activeColor = move.isChanging ? move.changing : move.played.color;
    _state.stop = move.played.value == CardValue.eso;
    _state.take = move.played.value == CardValue.sedma ? _state.take * 2 : GameState.TAKE_NORMAL;
  }

  Future _printState() async {
    List<TextDisplayable> infoPanel = [];
    for (Player player in _players) {
      infoPanel.addAll([
        new NewLineDisplayable(),
        new TextDisplayable(player.name),
        new TextDisplayable('Cards: ' + player.numCards.toString()),
        new NewLineDisplayable(newLines: 4)
      ]);
    }
    await _printer.printObjects([
      _players,
      infoPanel,
      [_receivingDeck]
    ], indentation: 3);
    print('Active color: ${cardColors[_state.activeColor.index]}\n');
//    _debugPrintState();
  }

  void _debugPrintState() {
    print('lizej: ${_state.take}, stuj: ${_state.stop}, active: ${new Card(_state.activeValue, _state.activeColor)}');
    for (Player p in _players) {
      stdout.write('${p.name}: ');
      for (Card c in p.deck) {
        stdout.write(c.toString() + ' ');
      }
      stdout.writeln();
    }
    print('receiving: ');
    _receivingDeck.forEachCard((card) => stdout.write(card.toString() + ' '));
    stdout.writeln();
    print('supplying: ');
    _supplyingDeck.forEachCard((card) => stdout.write(card.toString() + ' '));
    stdout.writeln();
  }

  void lady() {
    ladyCame = true;
    print("Suddenly, a lady comes to the salon, disrupting each and every player.");
    _printer.printObject(_lady);
  }
}
