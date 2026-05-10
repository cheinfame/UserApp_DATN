import 'package:flutter/material.dart';

class AppTypography {
  final BuildContext context;

  AppTypography._privateConstructor(
      {required this.context}); // Private constructor

  factory AppTypography({required BuildContext context}) {
    return AppTypography._privateConstructor(
        context: context); // Return the singleton instance
  }

  TextStyle get title1 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title2 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  TextStyle get title3 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get heading1 => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      );

  TextStyle get bodyText => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 17,
      );

  TextStyle get subhead => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 15,
      );

  TextStyle get footnote => TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 13,
      fontWeight: FontWeight.w200);
}
