import 'dart:async';
import 'dart:io';
import 'package:CardBoom/output/displayable.dart';
import 'package:CardBoom/utils.dart';

class Printer {
  Future printObjects(List<List<Displayable>> objects, {int indentation = 0}) async {
    List<int> widths = newList(objects.length, 0);
    for (int i = 0; i < objects.length; ++i) {
      assert(objects[i] != null);
      for (int j = 0; j < objects[i].length; ++j) {
        if (await objects[i][j].width > widths[i]) widths[i] = await objects[i][j].width;
      }
    }

    List<Future<Iterator<String>>> iterators = newListGenerate(objects.length, (i) => objects[i].first.linesIterator);
    List<int> progress = newList(objects.length, 0);

    bool printing = true;
    while (printing) {
      printing = false;
      for (int j = 0; j < objects.length; ++j) {
        int printed = 0;
        if (await iterators[j] != null) {
          while ((await iterators[j] == null || !(await iterators[j]).moveNext()) && ++progress[j] < objects[j].length) {
            iterators[j] = objects[j][progress[j]]?.linesIterator;
          }
          if (progress[j] < objects[j].length) {
            printing = true;
            stdout.write((await iterators[j]).current);
            printed += (await iterators[j]).current.length;
          }
        }
        printMultiple(' ', widths[j] - printed + indentation);
      }
      stdout.writeln();
    }
  }

  Future printObject(Displayable object) async {
    Iterator<String> iterator = await object.linesIterator;
    while (iterator.moveNext()) {
      String line = iterator.current;
      stdout.write(line);
      printMultiple(' ', await object.width - line.length);
      stdout.writeln();
    }
  }
}
