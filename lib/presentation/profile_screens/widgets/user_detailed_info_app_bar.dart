import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/path.dart';

class UserDetailedInfoAppBar extends StatelessWidget {
  const UserDetailedInfoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
            height: 170,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.shadow,
                  colorScheme.onSurfaceVariant,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: size.width / 2 - 32,
            child: CircleAvatar(
              radius: 32,
              child: SvgPicture.asset(user_avatar),
            ),
          ),
        ],
      ),
    );
  }
}
