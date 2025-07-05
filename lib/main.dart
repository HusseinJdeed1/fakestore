import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'business_logic/cubit/theme_cubit.dart';
import 'business_logic/cubit/theme_state.dart';
import 'constants/my_strings.dart';
import 'data/models/user.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? userJson = prefs.getString('user');

  String initialRoute;
  User? initialUser;

  if (token != null && userJson != null && userJson != 'null') {
    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        initialUser = User.fromJson(decoded);
        initialRoute = homeScreen;
      } else {
        initialRoute = loginScreen;
      }
    } catch (_) {
      initialRoute = loginScreen;
    }
  } else {
    initialRoute = loginScreen;
  }

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: FakeStore(
        appRouter: AppRouter(),
        initialRoute: initialRoute,
        initialUser: initialUser,
      ),
    ),
  );
}

class FakeStore extends StatefulWidget {
  final AppRouter appRouter;
  final String initialRoute;
  final User? initialUser;

  FakeStore({
    Key? key,
    required this.appRouter,
    required this.initialRoute,
    this.initialUser,
  }) : super(key: key);

  @override
  State<FakeStore> createState() => _FakeStoreState();
}

class _FakeStoreState extends State<FakeStore> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fake Store',
          themeMode: themeState.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: widget.initialRoute,
          onGenerateRoute: (settings) {
            if (settings.name == homeScreen) {
              final args = settings.arguments ?? widget.initialUser;
              return widget.appRouter.generateRoute(
                RouteSettings(name: settings.name, arguments: args),
              );
            }
            return widget.appRouter.generateRoute(settings);
          },
        );
      },
    );
  }
}
