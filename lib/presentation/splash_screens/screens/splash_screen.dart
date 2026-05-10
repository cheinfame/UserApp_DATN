import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/config/path.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/global_widgets/big_button.dart';
import 'package:packare/presentation/authentication_screens/screens/authentication_screen.dart';
import '../widgets/page_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    setState(() {
      _currentPage = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: <Widget>[
              onboard(
                context,
                warehouse_logo_path,
                "onboard1",
                "1 ",
                "Continue",
                () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
              ),
              onboard(
                context,
                delivery_bike_logo_path,
                "onboard2",
                "2 ",
                "Continue",
                () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
              ),
              onboard(
                context,
                map_logo_path,
                "onboard3",
                "3 ",
                "Get Started",
                () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AuthenticationScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: PageIndicator(
              currentPage: _currentPage,
              pageCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}

Widget onboard(BuildContext context, String svg, String headTitle, String body,
    String buttonString, VoidCallback callback) {
  final Size size = MediaQuery.of(context).size;
  final double height = size.height;
  final double width = size.width;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: height * 0.4,
        width: width * 0.4,
        child: SvgPicture.asset(svg),
      ),
      Text(
        headTitle,
        style: AppTypography(context: context).heading1,
      ),
      Text(
        body,
        style: AppTypography(context: context).bodyText,
      ),
      const SizedBox(
        height: 10,
      ),
      bigButton(context, buttonString, callback)
    ],
  );
}
