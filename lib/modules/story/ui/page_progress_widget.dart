import 'package:flutter/material.dart';

class PagerProgressWidget extends AnimatedWidget {
  final PageController controller;
  final int itemCount;

  late final ColorTween colorTween;

  PagerProgressWidget({
    Key? key,
    required this.controller,
    required this.itemCount,
    required Color begin,
    required Color end,
  }) : super(key: key, listenable: controller) {
    colorTween = ColorTween(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${(controller.page?.round() ?? 0) + 1} / $itemCount",
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: Theme.of(context).colorScheme.primary.withOpacity(0.36)),
    );
  }
}
