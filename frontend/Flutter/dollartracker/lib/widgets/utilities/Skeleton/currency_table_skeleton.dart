import 'package:dollartracker/widgets/utilities/Skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class CurrencyTableSkeleton extends StatelessWidget {
  const CurrencyTableSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Skeleton(height: 70,),
          )
        ],
      ),
    );
  }
}
