import 'package:flutter/material.dart';

import '../../../config/typography.dart';

Widget locationIconColumn(context, String from, String to) {
  final cardTextStyle = AppTypography(context: context).bodyText.copyWith(
    fontSize: 12.0,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 36,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              "From: $from",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: cardTextStyle,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 3,
      ),
      SizedBox(
        width: 36,
        child: Center(
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      SizedBox(
        width: 36,
        child: Center(
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      SizedBox(
        width: 36,
        child: Center(
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 36,
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              "To: $to",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: cardTextStyle,
            ),
          ),
        ],
      ),
    ],
  );
}
