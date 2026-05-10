import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:packare/config/typography.dart';

import '../../../blocs/order_bloc/create_order_process_cubit.dart';
import '../../../blocs/order_bloc/create_order_process_state.dart';
import '../widgets/floating_search_bar.dart';

class SendTab extends StatelessWidget {
  final VoidCallback nextPage;

  const SendTab({
    Key? key,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderProcessCubit, CreateOrderProcessState>(
      builder: (context, state) {
        // Check if preferred pickup time is on the same day
        final isSameDay = state.preferredPickupStartTime.day ==
            state.preferredPickupEndTime.day;

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 92,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          style: AppTypography(context: context)
                              .bodyText
                              .copyWith(fontSize: 14.0),
                          children: [
                            const TextSpan(
                              text: 'Preferred Pickup Time: ',
                            ),
                            TextSpan(
                              text: DateFormat('yyyy-MM-dd ')
                                  .format(state.preferredPickupStartTime),
                              style: AppTypography(context: context)
                                  .bodyText
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                            ),
                            TextSpan(
                              text: DateFormat('HH:mm')
                                  .format(state.preferredPickupStartTime),
                              style: AppTypography(context: context)
                                  .bodyText
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                  ),
                            ),
                            const TextSpan(
                              text: ' : ',
                            ),
                            isSameDay
                                ? const TextSpan()
                                : TextSpan(
                                    text: DateFormat('yyyy-MM-dd ')
                                        .format(state.preferredPickupEndTime),
                                    style: AppTypography(context: context)
                                        .bodyText
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                        ),
                                  ),
                            TextSpan(
                              text: DateFormat('HH:mm').format(
                                state.preferredPickupEndTime,
                              ),
                              style: AppTypography(context: context)
                                  .bodyText
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            _selectPreferredPickupTimeRange(context, state),
                        icon: const Icon(
                          Icons.alarm,
                          color: Colors.blue,
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    OutlinedButton(
                      onPressed:
                          (state.sendLocation.isNotEmpty) ? nextPage : null,
                      child: const Text('Next'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ],
            ),
            CustomFloatingSearchBar(
              isSend: true,
            ),
          ],
        );
      },
    );
  }

  void _selectPreferredPickupTimeRange(
      BuildContext context, CreateOrderProcessState state) async {
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 7)), // Limit selection to 7 days from today
    );

    if (startDate != null) {
      final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (startTime != null) {
        final DateTime? endDate = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: startDate,
          lastDate: startDate.add(const Duration(days: 7)),
        );

        if (endDate != null) {
          final TimeOfDay? endTime = await showTimePicker(
            context: context,
            initialTime: startTime,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          );

          if (endTime != null) {
            // Update the cubit state with the selected times
            BlocProvider.of<CreateOrderProcessCubit>(context)
                .updatePreferredPickupStartTime(
              DateTime(startDate.year, startDate.month, startDate.day,
                  startTime.hour, startTime.minute),
            );
            BlocProvider.of<CreateOrderProcessCubit>(context)
                .updatePreferredPickupEndTime(
              DateTime(endDate.year, endDate.month, endDate.day, endTime.hour,
                  endTime.minute),
            );
          }
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
