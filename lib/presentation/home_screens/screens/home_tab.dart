import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/blocs/order_bloc/order_bloc.dart';
import 'package:packare/config/path.dart';
import 'package:packare/presentation/home_screens/widgets/home_app_bar.dart';
import 'package:packare/presentation/order_screens/screens/order_detail_screen.dart';
import '../../../config/typography.dart';
import '../widgets/home_current_order_list_item.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // app bar
          const HomeAppBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Text(
              'Available Orders',
              style: AppTypography(context: context).bodyText.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
            ),
          ),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) => state.status ==
                      OrderBlocStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.ordersNotCompleted.isEmpty ||
                          state.status == OrderBlocStatus.failure
                      ? RefreshIndicator(
                          onRefresh: () async {
                            final account =
                                context.read<AccountBloc>().state.account;

                            if (account != null) {
                              context.read<OrderBloc>().add(
                                  GetOrdersByUserEvent(
                                      userId: account.user.userId));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Cannot find your information, please login again',
                                      style: AppTypography(context: context)
                                          .bodyText,
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
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: SvgPicture.asset(
                                        packare_logo_path,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'No Order Available',
                                    style: AppTypography(context: context)
                                        .title3
                                        .copyWith(
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
                            final account =
                                context.read<AccountBloc>().state.account;

                            if (account != null) {
                              context.read<OrderBloc>().add(
                                  GetOrdersByUserEvent(
                                      userId: account.user.userId));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Cannot find your information, please login again',
                                      style: AppTypography(context: context)
                                          .bodyText,
                                    ),
                                  );
                                },
                              );
                              context.read<AccountBloc>().add(LogoutEvent());
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.ordersNotCompleted.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 12.0);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDetailScreen(
                                                  orderId: state
                                                      .orders[index].orderId))),
                                  child:

                                      // User Order Item

                                      HomeCurrentOrderListItem(
                                    order: state.ordersNotCompleted[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
