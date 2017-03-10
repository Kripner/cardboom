import 'package:CardBoom/card/card_color.dart';
import 'package:CardBoom/card/card_value.dart';

class Settings {
  static const int numPlayers = 4;
  static const List<String> faces = const ['face_00.txt', 'face_01.txt', 'face_02.txt', 'face_03.txt', 'face_04.txt', 'face_05.txt'];
  static const List<String> names = const ['James', 'John', 'George', 'Matthew', 'Larry', 'Gary', 'Peter', 'Jack', 'Albert'];
  static const int initialCards = 4;
  static const int roundWait = 3000; // millis
  static const int introWait = 5000; // millis

  static const int ladyMinRound = 6;
  static const double ladyProbability = 0.09;
  static const String lady = 'lady.txt';
  static const String gun = 'gun.txt';

  static void check() {
    assert(numPlayers > 1, "One or no players");
    assert(initialCards > 0, "Number of initial cards not positive");
    assert(Settings.numPlayers * Settings.initialCards < CardColor.values.length * CardValue.values.length, "Too many players");
    assert(roundWait > 0, "Negative waiting time");
    assert(faces.length >= numPlayers, "More players than faces");
    assert(names.length >= numPlayers, "More players than names");
  }
}
