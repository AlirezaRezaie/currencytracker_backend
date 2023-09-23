import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;

  const Skeleton({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }
}
