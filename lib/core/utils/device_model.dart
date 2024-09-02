// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String? getDeviceModel() {
  String userAgent = html.window.navigator.userAgent;

  // Check for iPhone models in the user agent string
  if (userAgent.contains('iPhone')) {
    if (userAgent.contains('iPhone13,4')) {
      return 'iPhone13,4';
    } else if (userAgent.contains('iPhone14,3')) {
      return 'iPhone14,3';
    } else if (userAgent.contains('iPhone15,3')) {
      return 'iPhone15,3';
    } else if (userAgent.contains('iPhone13,3')) {
      return 'iPhone13,3';
    } else if (userAgent.contains('iPhone14,2')) {
      return 'iPhone14,2';
    } else if (userAgent.contains('iPhone15,2')) {
      return 'iPhone15,2';
    }
    return null;
  } else {
    return null;
  }
}
