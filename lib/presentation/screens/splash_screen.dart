// splash_screen.dart
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // navigateAfterSplash();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: MyColors.myBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              "Fake Store",
              style: TextStyle(
                  color: MyColors.myGrey2,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
            Text(
              "Training App",
              style: TextStyle(
                  color: MyColors.myGrey2,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            SizedBox(height: 30),
            Image.asset("assets/images/splash-screen.png"),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Hussein Jdeed",
                style: TextStyle(
                    color: MyColors.myGrey2,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Future<void> navigateAfterSplash() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');
  //   final String? userJson = prefs.getString('user');
  //
  //   if (token != null && userJson != null && userJson != 'null') {
  //     try {
  //       final decoded = jsonDecode(userJson);
  //       if (decoded is Map<String, dynamic>) {
  //         final user = User.fromJson(decoded);
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           homeScreen,
  //           (route) => route.settings.name == homeScreen,
  //           arguments: user,
  //         );
  //         // Navigator.of(context)
  //         //     .pushReplacementNamed(homeScreen, arguments: user);
  //       } else {
  //         Navigator.of(context).pushReplacementNamed(loginScreen);
  //       }
  //     } catch (_) {
  //       Navigator.of(context).pushReplacementNamed(loginScreen);
  //     }
  //   } else {
  //     Navigator.of(context).pushReplacementNamed(loginScreen);
  //   }
  // }
}
