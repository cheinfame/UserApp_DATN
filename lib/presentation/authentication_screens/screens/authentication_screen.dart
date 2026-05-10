import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../config/typography.dart';
import '../../../config/path.dart';
import '../../authentication_screens/screens/login_tab.dart';
import '../../authentication_screens/screens/signup_tab.dart';

class AuthenticationScreen extends StatefulWidget {
  final String? error;

  const AuthenticationScreen({Key? key, this.error}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.error != null && widget.error!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog();
      });
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            widget.error!.substring(11),
            style: AppTypography(context: context).bodyText,
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: SvgPicture.asset(
                      packare_logo_path,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shipping and Track Anytime',
                        style: AppTypography(context: context).title3,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Experience it with Packare',
                        style: AppTypography(context: context).subhead,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              TabBar(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                splashBorderRadius: BorderRadius.circular(4),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'Sign Up',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    LoginTab(),
                    SignUpTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
