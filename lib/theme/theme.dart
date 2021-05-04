import 'package:flutter/material.dart';

class CustomTheme {
  static final Color mainColor = Color.fromRGBO(255, 89, 106, 1.0);

  static final Color mainDarkColor = Color.fromRGBO(193, 29, 46, 1.0);
  static final Color textColor1 = Color.fromRGBO(68, 74, 79, 1.0);
  static final Color textColor2 = Color.fromRGBO(125, 125, 125, 1.0);

  static final Color redColor = Color.fromRGBO(255, 89, 106, 1.0);
  static final Color yellowColor = Color.fromRGBO(251, 173, 18, 1.0);
  static final Color greenColor = Color.fromRGBO(162, 243, 219, 1.0);
  static final Color greyColor = Color.fromRGBO(34, 34, 34, 0.2);
  static final Color purpleColor = Color.fromRGBO(235, 30, 195, 0.2);

  static ThemeData theme() {
    ThemeData original = ThemeData.light();
    var textTheme = original.textTheme;

    return original.copyWith(
      primaryColor: mainColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: textColor2),
      ),
      textTheme: original.textTheme.copyWith(
        bodyText1: textTheme.bodyText1
            .copyWith(fontFamily: 'SourceSansPro', color: textColor1),
        bodyText2: textTheme.bodyText2
            .copyWith(fontFamily: 'SourceSansPro', color: textColor2),
        caption: textTheme.caption
            .copyWith(fontFamily: 'SourceSansPro', color: textColor2),
        headline1: textTheme.headline1
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        headline2: textTheme.headline2
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        headline3: textTheme.headline3
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        headline4: textTheme.headline4
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        headline5: textTheme.headline5
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        headline6: textTheme.headline6
            .copyWith(fontFamily: 'SourceSansPro', color: mainColor),
        overline: textTheme.overline
            .copyWith(fontFamily: 'SourceSansPro', color: textColor2),
        subtitle1: textTheme.subtitle1
            .copyWith(fontFamily: 'SourceSansPro', color: textColor2),
        subtitle2: textTheme.subtitle2
            .copyWith(fontFamily: 'SourceSansPro', color: textColor2),
        button: textTheme.button.copyWith(
          fontSize: 17.0,
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
