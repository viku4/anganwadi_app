import 'package:flutter/material.dart';

LanguageProvider languageProvider = LanguageProvider();

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  bool get isEnglish => languageCode == 'en';

  bool get isHindi => languageCode == 'hi';

  void changeLanguage(String languageCode) {
    if (languageCode != 'en' && languageCode != 'hi') {
      return;
    }
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void changeToEnglish() {
    changeLanguage('en');
  }

  void changeToHindi() {
    changeLanguage('hi');
  }
}
