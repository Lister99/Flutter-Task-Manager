import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/controllers/c_etiquetas.dart';
import 'package:scheduleapp/controllers/c_home.dart';
import 'package:scheduleapp/controllers/c_rutina.dart';
import 'package:scheduleapp/s_home.dart';
import 'package:scheduleapp/utils/themes.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();

  // _getTimeZone();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() async {
    return '';
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    return true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => EtiquetaProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => RutinaProvider()),
        ],
        child: ThemeModeHandler(
            manager: MyManager(),
            builder: (ThemeMode themeMode) {
              return MaterialApp(
                title: 'Task Manager',
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('es'),
                  const Locale('en', ''),
                  //const Locale('es'),
                ],
                locale: Locale('en', ''),
                darkTheme: Themes.dark,
                theme: Themes.light,
                home: HomeScreen(),
              );
            }));
  }
}
