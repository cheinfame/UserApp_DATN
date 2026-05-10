import 'package:flutter/material.dart';

import '../../config/typography.dart';

Widget bigButton(
    BuildContext context, String buttonString, VoidCallback callback) {
  bool isButtonEnabled = true;

  // Fixed debounce duration
  const Duration debounceDuration = Duration(milliseconds: 3000);

  // Debounced callback function
  void debouncedCallback() {
    if (isButtonEnabled) {
      isButtonEnabled = false;
      callback(); // Invoke original callback
      Future.delayed(debounceDuration, () {
        isButtonEnabled = true;
      });
    }
  }

  return Container(
    width: MediaQuery.of(context).size.width * 0.6,
    height: MediaQuery.of(context).size.height * 0.06,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: InkWell(
      onTap: debouncedCallback, // Use the debounced callback here
      child: Center(
        child: Text(
          buttonString,
          style: AppTypography(context: context).bodyText.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    ),
  );
}
