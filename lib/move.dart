import 'package:CardBoom/card/card.dart';
import 'package:CardBoom/card/card_color.dart';

class Move {
  final Card played;
  final CardColor changing;
  final bool passed;

  Move(this.played, {this.changing}) : passed = false;

  Move.pass()
      : passed = true,
        played = null,
        changing = null;

  bool get isChanging => changing != null;
}
