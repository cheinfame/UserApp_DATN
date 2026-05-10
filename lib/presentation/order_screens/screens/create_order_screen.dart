import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/blocs/order_bloc/create_order_process_cubit.dart';
import 'package:packare/config/typography.dart';

import '../../../locator.dart';
import 'packages_tab.dart';
import 'review_tab.dart';
import 'send_tab.dart';
import 'to_tab.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void nextPage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex + 1) % 4;
      _tabController.index = _currentPageIndex;
    });
  }

  void previousPage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex - 1) % 4;
      _tabController.index = _currentPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final typo = AppTypography(context: context);

    return BlocProvider(
      create: (context) => locator<CreateOrderProcessCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Create new order',
            style: typo.heading1,
          ),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                buildTab('Send', 1),
                buildTab('To', 2),
                buildTab('Packages', 3),
                buildTab('Review', 4),
              ],
              onTap: (index) {
                if (index == _currentPageIndex) {
                  return;
                }
                // Prevent changing tabs
                _tabController.animateTo(_currentPageIndex);
              },
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  SendTab(
                    nextPage: nextPage,
                  ),
                  ToTab(
                    nextPage: nextPage,
                    previousPage: previousPage,
                  ),
                  PackagesTab(
                    nextPage: nextPage,
                    previousPage: previousPage,
                  ),
                  ReviewTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String title, int number) {
    return Tab(
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration:
                BoxDecoration(shape: BoxShape.circle, border: Border.all()),
            child: Center(
              child: Text(
                '$number',
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(title),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
