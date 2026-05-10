import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';

import '../../../config/path.dart';
import '../../../config/typography.dart';

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Profile',
              style: AppTypography(context: context).heading1.copyWith(
                    color: colorScheme.surfaceVariant,
                  ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    return Text(
                      state.status == AccountStatus.success
                          ? state.account!.user.lastName
                          : "User",
                      style: AppTypography(context: context).heading1.copyWith(
                            color: colorScheme.surfaceVariant,
                          ),
                    );
                  },
                ),
                CircleAvatar(
                  radius: 32.0,
                  child: SvgPicture.asset(user_avatar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
