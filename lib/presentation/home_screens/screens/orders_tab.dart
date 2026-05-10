import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/data/models/order_model.dart';
import 'package:packare/presentation/home_screens/widgets/orders_list_item.dart';

import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../config/path.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabLabelTextStyle = AppTypography(context: context)
        .footnote
        .copyWith(fontWeight: FontWeight.normal);
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Orders",
            style: AppTypography(context: context).title3,
          ),
        ),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              physics: const AlwaysScrollableScrollPhysics(),
              labelPadding: const EdgeInsets.all(16.0),
              unselectedLabelStyle: tabLabelTextStyle,
              labelStyle: tabLabelTextStyle,
              labelColor: colorScheme.primary,
              tabs: const [
                Text("Waiting Verification"),
                Text("Waiting For Shipper"),
                Text("Shipper Accepted"),
                Text("Picking Up Order"),
                Text("On Delivery"),
                Text("Delivery Successful"),
                Text("Completed"),
                Text("Declined"),
                Text("Canceled"),
              ],
            ),
            Expanded(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state.status == OrderBlocStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == OrderBlocStatus.failure) {
                    return Center(
                        child: Text('Failed to fetch orders: ${state.error}'));
                  } else {
                    return TabBarView(
                      children: [
                        orderTab(
                          context: context,
                          status: OrderStatus.waiting,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.waiting)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.verified,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.verified)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.shipperAccepted,
                          orders: state.orders
                              .where((o) =>
                                  o.status == OrderStatus.shipperAccepted)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.verified,
                          orders: state.orders
                              .where(
                                  (o) => o.status == OrderStatus.startShipping)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.shipperPickedUp,
                          orders: state.orders
                              .where((o) =>
                                  o.status == OrderStatus.shipperPickedUp)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.delivered,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.delivered)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.completed,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.completed)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.declined,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.declined)
                              .toList(),
                        ),
                        orderTab(
                          context: context,
                          status: OrderStatus.cancelled,
                          orders: state.orders
                              .where((o) => o.status == OrderStatus.cancelled)
                              .toList(),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget orderTab({
  required BuildContext context,
  required OrderStatus status,
  required List<Order> orders,
}) {
  return orders.isEmpty
      ? RefreshIndicator(
          onRefresh: () async {
            final account = context.read<AccountBloc>().state.account;

            if (account != null) {
              context
                  .read<OrderBloc>()
                  .add(GetOrdersByUserEvent(userId: account.user.userId));
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      'Cannot find your information, please login again',
                      style: AppTypography(context: context).bodyText,
                    ),
                  );
                },
              );
              context.read<AccountBloc>().add(LogoutEvent());
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: SvgPicture.asset(
                        orders_empty,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Order',
                    style: AppTypography(context: context).title3.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ),
        )
      : RefreshIndicator(
          onRefresh: () async {
            final account = context.read<AccountBloc>().state.account;

            if (account != null) {
              context
                  .read<OrderBloc>()
                  .add(GetOrdersByUserEvent(userId: account.user.userId));
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      'Cannot find your information, please login again',
                      style: AppTypography(context: context).bodyText,
                    ),
                  );
                },
              );
              context.read<AccountBloc>().add(LogoutEvent());
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                return OrdersListItem(
                  order: orders[index],
                );
              },
            ),
          ),
        );
}
