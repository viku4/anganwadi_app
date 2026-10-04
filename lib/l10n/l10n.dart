import 'dart:ui';

import 'package:anganwadi_connect/l10n/app_localizations.dart';
import 'package:anganwadi_connect/config/routing_service.dart';

class L10n {
  final List<Map<String, Object>> all = [
    {
      "id": 1,
      "value": "en",
      "name": "English",
      "nativeName": "English",
      "flag": "🇬🇧",
    },
    {
      "id": 2,
      "value": "hi",
      "name": "Hindi",
      "nativeName": "हिन्दी",
      "flag": "🇮🇳",
    },
  ];

  String getLangcode(String code) {
    switch (code) {
      case "en":
        return "English";

      case "hi":
        return "Hindi";

      default:
        return "English";
    }
  }

  Locale getLocale(String code) {
    return Locale(code);
  }

  AppLocalizations? getValue() {
    return AppLocalizations.of(RoutingService.navigatorKey.currentContext!);
  }

  String? getCodeFromLocale(Locale locale) {
    return all.firstWhere(
          (map) => map["value"] == locale.languageCode,
          orElse: () => {"id": 1, "value": "en"},
        )["value"]
        as String?;
  }
}
