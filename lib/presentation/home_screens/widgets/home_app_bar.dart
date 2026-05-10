import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../config/path.dart';
import '../../../config/typography.dart';
import 'home_wallet_card.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 8.0,
      child: Container(
        height: 250,
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
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    child: SvgPicture.asset(user_avatar),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: AppTypography(context: context)
                            .heading1
                            .copyWith(color: colorScheme.surfaceVariant),
                      ),
                      BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, state) {
                          return Text(
                            state.status == AccountStatus.success
                                ? state.account!.user.lastName
                                : 'User',
                            style: AppTypography(context: context)
                                .heading1
                                .copyWith(color: colorScheme.surfaceVariant),
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: Badge(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
              HomeWalletCard(),
            ],
          ),
        ),
      ),
    );
  }
}
