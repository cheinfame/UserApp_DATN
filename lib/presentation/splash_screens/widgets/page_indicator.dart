import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator(
      {super.key, required this.currentPage, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentPage,
        count: pageCount,
        effect: ScaleEffect(
            scale: 1,
            dotHeight: 3,
            dotWidth: 20,
            dotColor: Theme.of(context).colorScheme.primaryContainer,
            activeDotColor: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }
}
