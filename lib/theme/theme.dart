import 'package:flutter/material.dart';

class CustomTheme {
  static final Color mainColor = Color.fromRGBO(255, 89, 106, 1.0);

  static final Color mainDarkColor = Color.fromRGBO(193, 29, 46, 1.0);
  static final Color textColor1 = Color.fromRGBO(68, 74, 79, 1.0);
  static final Color textColor2 = Color.fromRGBO(125, 125, 125, 1.0);
  static final Color textColor3 = Color.fromRGBO(129, 144, 176, 1.0);

  static final Color redColor = Color.fromRGBO(255, 89, 106, 1.0);
  static final Color yellowColor = Color.fromRGBO(251, 173, 18, 1.0);
  static final Color goldColor = Color.fromRGBO(255, 217, 3, 1.0);
  static final Color purpleColor = Color.fromRGBO(235, 30, 195, 1.0);

  static final Color greenColor = Color.fromRGBO(56, 224, 172, 1.0);
  static final Color green2Color = Color.fromRGBO(104, 190, 142, 1.0);
  static final Color green3Color = Color.fromRGBO(92, 208, 104, 1.0);

  static final Color greyColor = Color.fromRGBO(210, 210, 210, 1.0);
  static final Color grey2Color = Color.fromRGBO(165, 165, 165, 1.0);
  static final Color grey3Color = Color.fromRGBO(245, 245, 245, 1.0);

  static final Color blue1Color = Color.fromRGBO(0, 88, 255, 1.0);
  static final Color blue2Color = Color.fromRGBO(0, 132, 255, 1.0);
  static final Color blue3Color = Color.fromRGBO(52, 189, 247, 1.0);

  static final String familySourceSansPro = 'SourceSansPro';
  static final String familyNunito = 'Nunito';
  static final String primaryFont = 'Nunito';

  static ThemeData theme() {
    ThemeData original = ThemeData.light();
    var textTheme = original.textTheme;

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
