import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:pet_care/screens/home_screen/home_screen.dart';
import 'package:pet_care/screens/login_screen/login_screen.dart';
import 'package:pet_care/screens/splash_screen/splash_screen.dart';
import 'package:pet_care/shared_preference/shared_preference.dart';
import 'package:pet_care/shared_preference/user_preference.dart';

import 'constants/colors.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init(); //init local storage
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        title: 'Flutter Demo',

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Urbanist',
          textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.primaryBlue),
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.deepGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:AppColors.deepGrey),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            fillColor: Colors.transparent,
            filled: true,
          ),
        ),
        home:  SafeArea(child: UserPreferences.getFirstTimeState()==true?SplashScreen():UserPreferences.getLoginState()==true?const BottomNavBar(): const LoginScreen()),
      ),
    );
  }
}