import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveUtil {
  static double forScreen({
    required SizingInformation sizingInfo,
    double? small,
    required double mobile,
    required double tablet,
    required double desktop,
    required double large,
  }) {
    if (sizingInfo.localWidgetSize.width > 1500) {
      // > 950px

      return large;
    }
    if (sizingInfo.deviceScreenType == DeviceScreenType.desktop) {
      // > 950px

      return desktop;
    } else if (sizingInfo.deviceScreenType == DeviceScreenType.tablet) {
      // < 950px

      return tablet;
    } else if (sizingInfo.screenSize.width <= 412 &&
        sizingInfo.screenSize.height <= 732) {
      // < 300px

      return small ?? mobile;
    } else if (sizingInfo.deviceScreenType == DeviceScreenType.mobile) {
      // < 600px

      return mobile;
    } else {
      return desktop;
    }
  }
}
