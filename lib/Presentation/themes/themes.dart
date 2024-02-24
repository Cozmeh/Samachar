import 'package:flutter/material.dart';
import 'package:samachar/Utils/constants.dart';

// Light mode colors
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  iconTheme: IconThemeData(color: Constants.DARK_BACKGROUND),
  colorScheme: ColorScheme.light(
      background: Constants.LIGHT_BACKGROUND,
      primary: Constants.PRIMARY,
      secondary: Constants.SECONDARY,
      surface: Constants.LIGHT_SURFACE),
);

// Dark mode colors
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  iconTheme: IconThemeData(color: Constants.LIGHT_BACKGROUND),
  colorScheme: ColorScheme.dark(
      background: Constants.DARK_BACKGROUND,
      primary: Constants.PRIMARY,
      secondary: Constants.SECONDARY,
      surface: Constants.DARK_SURFACE),
);
