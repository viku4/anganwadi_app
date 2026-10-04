import 'package:anganwadi_connect/controllers/employee_provider.dart';
import 'package:anganwadi_connect/controllers/home_provider.dart';
import 'package:anganwadi_connect/controllers/language_provider.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/controllers/role_controller.dart';
import 'package:anganwadi_connect/core/theme/app_theme.dart';
import 'package:anganwadi_connect/core/theme/theme_provider.dart';
import 'package:anganwadi_connect/l10n/l10n.dart' show L10n;
import 'package:anganwadi_connect/services/network/local/shared_prefrences/local_auth_sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/router_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FocusManager.instance.primaryFocus?.unfocus();
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
  prefs = await SharedPreferences.getInstance();
  await AuthStorage.getUser();
  await AuthStorage.getUserAccessToken();
  await AuthStorage.getUserRefreshAccessToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>.value(value: homeProvider),

        ChangeNotifierProvider<RoleController>.value(value: roleController),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ChangeNotifierProvider<LoginProvider>.value(value: loginProvider),
        ChangeNotifierProvider<EmployeeProvider>.value(value: employeeProvider),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  GoRouter router = PageRouter().router;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<LanguageProvider>(
      builder: (BuildContext context, value, Widget? child) =>
          MaterialApp.router(
            title: 'Hotel Management',
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            supportedLocales: L10n().all
                .map((e) => Locale(e["value"]! as String))
                .toList(),
            locale: value.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          ),
    );
  }
}
