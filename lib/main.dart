import 'package:codebase/presentation/screen/user/user_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();
  // This for system status bar setup
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  // And than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(412, 915),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          locale: const Locale('en', 'US'),
          home: UserListPage(),
          title: 'Codebase',
          debugShowCheckedModeBanner: false,
        ));
  }
}
