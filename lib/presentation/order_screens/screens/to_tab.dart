import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:packare/blocs/order_bloc/create_order_process_cubit.dart';
import 'package:packare/presentation/global_widgets/info_text_field.dart';
import '../../../blocs/order_bloc/create_order_process_state.dart';
import '../../../config/typography.dart';
import '../widgets/floating_search_bar.dart';

class ToTab extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;

  const ToTab({
    Key? key,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  @override
  State<ToTab> createState() => _ToTabState();
}

class _ToTabState extends State<ToTab> {
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();

  @override
  void dispose() {
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderProcessCubit, CreateOrderProcessState>(
      builder: (context, state) {
        // Check if preferred delivery time is on the same day
        final isSameDay = state.preferredDeliveryStartTime.day ==
            state.preferredDeliveryEndTime.day;

        receiverNameController.text = state.receiverName;
        receiverPhoneController.text =
            context.watch<CreateOrderProcessCubit>().state.receiverPhone;

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 78.0, 16.0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  InfoTextField(
                      context: context,
                      isObscure: false,
                      isValid: true,
                      hintText: 'Receiver Name',
                      label: 'Receiver Name',
                      textFieldController: receiverNameController,
                      onChanged: (value) => context
                          .read<CreateOrderProcessCubit>()
                          .updateReceiverName(value)),
                  const SizedBox(height: 8),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      prefixIcon: null,
                      label: Text(
                        'Phone Number',
                        style: AppTypography(context: context).bodyText,
                      ),
                      hintText: 'Phone Number',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                    initialCountryCode: 'VN',
                    onChanged: (phone) {
                      context
                          .read<CreateOrderProcessCubit>()
                          .updateReceiverPhone(phone.number);
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      if (phone.number.length != 9) {
                        return 'Please enter a valid 9-digit phone number';
                      }
                      return null; // Return null if validation succeeds
                    },
                    onSaved: (phone) {
                      receiverPhoneController.text = phone!.completeNumber;
                    },
                    disableLengthCheck: true,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                                text: 'Preferred Delivery Time: ',
                              ),
                              TextSpan(
                                text: DateFormat('yyyy-MM-dd ')
                                    .format(state.preferredDeliveryStartTime),
                                style: AppTypography(context: context)
                                    .bodyText
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                              ),
                              TextSpan(
                                text: DateFormat('HH:mm')
                                    .format(state.preferredDeliveryStartTime),
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
                                      text: DateFormat('yyyy-MM-dd ').format(
                                          state.preferredDeliveryEndTime),
                                      style: AppTypography(context: context)
                                          .bodyText
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                          ),
                                    ),
                              TextSpan(
                                text: DateFormat('HH:mm').format(
                                  state.preferredDeliveryEndTime,
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
                              _selectPreferredDeliveryTimeRange(context),
                          icon: const Icon(
                            Icons.alarm,
                            color: Colors.blue,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: widget.previousPage,
                        child: const Text('Previous'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlinedButton(
                        onPressed: state.receiveLocation.isNotEmpty &&
                                state.receiverName.isNotEmpty &&
                                state.receiverPhone.length == 9
                            ? widget.nextPage
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            CustomFloatingSearchBar(
              isSend: false,
            ),
          ],
        );
      },
    );
  }

  void _selectPreferredDeliveryTimeRange(BuildContext context) async {
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
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
            context
                .read<CreateOrderProcessCubit>()
                .updatePreferredDeliveryStartTime(startDate);
            context
                .read<CreateOrderProcessCubit>()
                .updatePreferredDeliveryEndTime(endDate);
          }
        }
      }
    }
  }
    
  @override
  bool get wantKeepAlive => true;
}
