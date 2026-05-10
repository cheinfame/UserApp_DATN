import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/config/typography.dart';

class HomeWalletCard extends StatelessWidget {
  const HomeWalletCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: Row(
          children: [
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My balance",
                      style: AppTypography(context: context).bodyText,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(state.account!.wallet.balance),
                      style: AppTypography(context: context).title3,
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'Top Up',
                  style: AppTypography(context: context).footnote,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: Colors.black,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
