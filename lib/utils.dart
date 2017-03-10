import 'dart:io';

void printMultiple(String what, int times) {
  stdout.write(multiple(what, times));
}

String multiple(String what, int times) {
  StringBuffer result = new StringBuffer();
  for (int i = 0; i < times; ++i) {
    result.write(what);
  }
  return result.toString();
}

List<T> newList<T>(int length, T value) {
  return newListGenerate(length, (i) => value);
}

List<T> newListGenerate<T>(int length, T getValue(int)) {
  List<T> result = new List<T>(length);
  for (int i = 0; i < length; ++i) {
    result[i] = getValue(i);
  }
  return result;
}
