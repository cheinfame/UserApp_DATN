// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/presentation/home_screens/screens/home_tab.dart';
import 'package:packare/presentation/home_screens/screens/orders_tab.dart';
import 'package:packare/presentation/order_screens/screens/create_order_screen.dart';
import 'package:packare/presentation/profile_screens/screens/user_profile_screen.dart';

import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../data/services/websocket_service.dart';
import '../../../locator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // body vars
  late final PageController _pageController;
  int _currentIndex = 0;

  // bottom nav bar vars
  List<IconData> bottomBarIconList = [
    Icons.home_outlined,
    Icons.list_alt_rounded,
    Icons.credit_card,
    Icons.person_outline,
  ];
  List<IconData> activeBottomBarIconList = [
    Icons.home,
    Icons.list_alt_rounded,
    Icons.credit_card,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    final account = context.read<AccountBloc>().state.account!;
    context
        .read<AccountBloc>()
        .add(GetUserProfileEvent(userId: account.user.userId));
    locator<WebSocketService>().sendUserId(account.user.userId);
    context
        .read<OrderBloc>()
        .add(GetOrdersByUserEvent(userId: account.user.userId));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeTab(),
          OrdersTab(),
          // RoutesTab(),
          OrdersTab(),
          UserProfileScreen(),
        ],
      ), //destination screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CreateOrderScreen(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  }));
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: bottomBarIconList.length,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            isActive
                ? activeBottomBarIconList[index]
                : bottomBarIconList[index],
            size: 24,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          );
        },
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }),
      ),
    );
  }
}
