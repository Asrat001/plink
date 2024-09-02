import 'dart:html' as html;

const _isLoggedInKey = 'isLoggedIn';

Future<bool> isLoggedIn() async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // return preferences.getBool(_isLoggedInKey) ?? false;
  return html.window.localStorage[_isLoggedInKey] == 'true';
}

Future<void> setLogginStatus(bool isSignedIn) async {
  html.window.localStorage[_isLoggedInKey] = isSignedIn.toString();
}
