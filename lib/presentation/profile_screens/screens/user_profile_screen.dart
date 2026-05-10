import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/profile_screens/screens/change_password_screen.dart';
import 'package:packare/presentation/profile_screens/screens/user_info_screen.dart';
import 'package:packare/presentation/profile_screens/widgets/settings_list_item.dart';
import 'package:packare/presentation/profile_screens/widgets/user_profile_app_bar.dart';

import '../../../blocs/account_bloc/account_bloc.dart';
import '../../authentication_screens/screens/authentication_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            UserProfileAppBar(),

            // settings lists
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'My Account',
                    style: AppTypography(context: context).title3,
                  ),
                  const SizedBox(height: 10), // Add spacing between sections
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final icon_list = [
                        Icon(Icons.person_outline),
                        Icon(Icons.payment_outlined),
                        Icon(Icons.lock_outline),
                        Icon(Icons.logout)
                      ];
                      final list_titles = [
                        'User Information',
                        'Payment Method',
                        'Change Password',
                        'Logout'
                      ];
                      final callbacks = [
                        () {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoScreen()));
                        },
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoScreen()));
                        },
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangePasswordScreen()));
                        },
                        () {
                          context.read<AccountBloc>().add(LogoutEvent());

                          // Pop all screens and navigate to logging screen
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => AuthenticationScreen(),
                          ));
                        }
                      ];
                      return SettingsListItem(
                        buttonText: list_titles[index],
                        icon: icon_list[index],
                        callback: callbacks[index],
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Add spacing between sections
                  Text(
                    'General',
                    style: AppTypography(context: context).title3,
                  ),
                  const SizedBox(height: 10), // Add spacing between sections
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final icon_list = [
                        Icon(Icons.settings_outlined),
                        Icon(Icons.language_outlined),
                        Icon(Icons.more_horiz)
                      ];
                      final list_titles = ['Settings', 'Language', 'About Us'];
                      final callbacks = [() {}, () {}, () {}];
                      return SettingsListItem(
                        buttonText: list_titles[index],
                        icon: icon_list[index],
                        callback: callbacks[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
