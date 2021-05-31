import 'package:flutter/material.dart';

class CustomTheme {
  static const Color mainColor = const Color.fromRGBO(255, 89, 106, 1.0);

  static const Color mainDarkColor = const Color.fromRGBO(193, 29, 46, 1.0);
  static const Color textColor1 = const Color.fromRGBO(68, 74, 79, 1.0);
  static const Color textColor2 = const Color.fromRGBO(125, 125, 125, 1.0);
  static const Color textColor3 = const Color.fromRGBO(129, 144, 176, 1.0);

  static const Color redColor = const Color.fromRGBO(255, 89, 106, 1.0);
  static const Color yellowColor = const Color.fromRGBO(251, 173, 18, 1.0);
  static const Color goldColor = const Color.fromRGBO(255, 217, 3, 1.0);
  static const Color purpleColor = const Color.fromRGBO(235, 30, 195, 1.0);

  static const Color greenColor = const Color.fromRGBO(56, 224, 172, 1.0);
  static const Color green2Color = const Color.fromRGBO(104, 190, 142, 1.0);
  static const Color green3Color = const Color.fromRGBO(92, 208, 104, 1.0);

  static const Color greyColor = const Color.fromRGBO(210, 210, 210, 1.0);
  static const Color grey2Color = const Color.fromRGBO(165, 165, 165, 1.0);
  static const Color grey3Color = const Color.fromRGBO(245, 245, 245, 1.0);

  static const Color blue1Color = const Color.fromRGBO(0, 88, 255, 1.0);
  static const Color blue2Color = const Color.fromRGBO(0, 132, 255, 1.0);
  static const Color blue3Color = const Color.fromRGBO(52, 189, 247, 1.0);

  static const String familySourceSansPro = 'SourceSansPro';
  static const String familyNunito = 'Nunito';
  static const String primaryFont = 'Nunito';

  ThemeData get theme {
    final original = ThemeData.light();
    final textTheme = original.textTheme;

    return original.copyWith(
      primaryColor: mainColor,
      appBarTheme: original.appBarTheme.copyWith(
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.white,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: textColor2,
        ),
      ),
      textTheme: original.textTheme.copyWith(
        bodyText1: textTheme.bodyText1.copyWith(
          fontFamily: primaryFont,
          color: textColor1,
        ),
        bodyText2: textTheme.bodyText2.copyWith(
          fontFamily: primaryFont,
          color: textColor2,
        ),
        caption: textTheme.caption.copyWith(
          fontFamily: primaryFont,
          color: textColor2,
        ),
        headline1: textTheme.headline1.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        headline2: textTheme.headline2.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        headline3: textTheme.headline3.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        headline4: textTheme.headline4.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        headline5: textTheme.headline5.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        headline6: textTheme.headline6.copyWith(
          fontFamily: primaryFont,
          color: mainColor,
        ),
        overline: textTheme.overline.copyWith(
          fontFamily: primaryFont,
          color: textColor2,
        ),
        subtitle1: textTheme.subtitle1.copyWith(
          fontFamily: primaryFont,
          color: textColor1,
        ),
        subtitle2: textTheme.subtitle2.copyWith(
          fontFamily: primaryFont,
          color: textColor1,
        ),
        button: textTheme.button.copyWith(
          fontFamily: primaryFont,
          fontWeight: FontWeight.w600,
          fontSize: 17.0,
        ),
      ),
    );
  }
}
