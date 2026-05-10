// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/blocs/order_bloc/order_bloc.dart';

import 'package:packare/config/typography.dart';
import 'package:packare/presentation/global_widgets/big_button.dart';

import '../../../config/path.dart';
import '../../../data/models/order_feedback_model.dart';
import '../../../data/models/order_model.dart';

class FeedbackScreen extends StatefulWidget {
  final Order order;

  const FeedbackScreen({Key? key, required this.order}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
        ),
        title: Text(
          'Feedback',
          style: AppTypography(context: context).title3,
        ),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.feedbackStatus == OrderFeedbackStatus.success) {
            // Feedback submitted successfully, pop the screen
            Navigator.pop(context);
          } else if (state.feedbackStatus == OrderFeedbackStatus.failure) {
            // Feedback submission failed, handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Feedback submission failed'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text(widget.order.orderId,  style: AppTypography(context: context).title3),
            const SizedBox(height: 8),
              
              Text(
              'Shipper ${widget.order.shipper!.user.lastName}',
              style: AppTypography(context: context).bodyText.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
             CircleAvatar(
                    radius: 28.0,
                    child: SvgPicture.asset(user_avatar),
                  ),
            const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _rating = i;
                        });
                      },
                      icon: Icon(
                        i <= _rating ? Icons.star : Icons.star_border,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 32),
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your comment here...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              bigButton(
                context,
                'Submit Feedback',
                () {
                  final feedback = OrderFeedback(
                    orderId: widget.order.orderId,
                    rating: _rating,
                    comment: _commentController.text,
                  );

                  context.read<OrderBloc>().add(
                        ProvideOrderFeedbackEvent(
                          orderId: widget.order.orderId,
                          feedback: feedback,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
