import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class TextScale {
  static const systemTextScale = 'SYSTEM_TEXT_SCALE';
  static const systemTextScaleReadableName = 'System';
  static const systemTextScaleValue = 1.0;

  static const smallTextScale = 'SMALL_TEXT_SCALE';
  static const smallTextScaleReadableName = 'Small';
  static const smallTextScaleValue = 0.8;

  static const mediumTextScale = 'MEDIUM_TEXT_SCALE';
  static const mediumTextScaleReadableName = 'Medium';
  static const mediumTextScaleValue = 1.0;

  static const largeTextScale = 'LARGE_TEXT_SCALE';
  static const largeTextScaleReadableName = 'Large';
  static const largeTextScaleValue = 1.2;

  static const hugeTextScale = 'HUGE_TEXT_SCALE';
  static const hugeTextScaleReadableName = 'Huge';
  static const hugeTextScaleValue = 1.4;

  static getTextScale(final String textScaleId) {
    if (DataUtils.isNotBlank(textScaleId)) {
      switch (textScaleId) {
        case systemTextScale:
          return systemTextScaleReadableName;
        case smallTextScale:
          return smallTextScaleReadableName;
        case mediumTextScale:
          return mediumTextScaleReadableName;
        case largeTextScale:
          return largeTextScaleReadableName;
        case hugeTextScale:
          return hugeTextScaleReadableName;
        default:
          throw Exception('Invalid uiTheme : $textScaleId');
      }
    }
  }

  static getTextScaleValue(final String textScaleId) {
    LogUtil.debug("TextScale", "textScaleValue : $textScaleId value");
    if (DataUtils.isNotBlank(textScaleId)) {
      switch (textScaleId) {
        case systemTextScale:
          return systemTextScaleValue;
        case smallTextScale:
          return smallTextScaleValue;
        case mediumTextScale:
          return mediumTextScaleValue;
        case largeTextScale:
          return largeTextScaleValue;
        case hugeTextScale:
          return hugeTextScaleValue;
        default:
          throw Exception('Invalid uiTheme : $textScaleId');
      }
    }
  }
}