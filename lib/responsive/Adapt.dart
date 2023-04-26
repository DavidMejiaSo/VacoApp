import 'package:flutter/material.dart';
import 'dart:ui';

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;
  static final double _topbarH = mediaQuery.padding.top;
  static final double _botbarH = mediaQuery.padding.bottom;
  static final double _pixelRatio = mediaQuery.devicePixelRatio;
  static final double _smallestWidth = _width > _height ? _height : _width;
  static final bool _isLargeScreen = _smallestWidth > 820;
  static final bool _isMediumScreen =
      _smallestWidth > 600 && _smallestWidth <= 820;
  static var _ratio = init(1080);
  static init(int number) {
    int uihight = number > 0 ? number : 1080;
    MediaQueryData mediaQuery2 = MediaQueryData.fromWindow(window);
    _ratio = mediaQuery2.size.height / uihight;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int) || _ratio == 0.0) {
      Adapt.init(1080);
    }
    return number * _ratio;
  }

  static onepx() {
    return 1 / _pixelRatio;
  }

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  static padTopH() {
    return _topbarH;
  }

  static padBotH() {
    return _botbarH;
  }

  static isLargeScreen() => _isLargeScreen;
  static isMediumScreen() => _isMediumScreen;
  static double wp(percentage) {
    double result = (percentage * _width) / 100;
    return result;
  }

  static double hp(percentage) {
    double result = (percentage * _height) / 100;
    return result;
  }
}
