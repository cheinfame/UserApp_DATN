// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:packare/config/typography.dart';

class SettingsListItem extends StatelessWidget {
  final String buttonText;
  final Icon icon;
  final VoidCallback callback;
  const SettingsListItem({
    Key? key,
    required this.buttonText,
    required this.icon,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: callback,
      icon: icon,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      label: SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              buttonText,
              style: AppTypography(context: context).bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
