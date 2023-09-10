import 'package:flutter/services.dart';

extension KeyPressed on RawKeyEvent {
  bool isPressed(List<LogicalKeyboardKey>? keys, {bool isCtrl = false, bool isAlt = false, bool isShift = false}) {
    if (keys == null) return false;
    if (isCtrl && !isControlPressed) return false;
    if (isAlt && !isAltPressed) return false;
    if (isShift && !isShiftPressed) return false;
    for (final key in keys) {
      if (isKeyPressed(key)) {
        return true;
      }
    }
    return false;
  }
}
