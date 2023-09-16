import 'package:dollartracker/widgets/utilities/Skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Skeleton(
                  width: 50,
                  height: 10,
                ),
                SizedBox(height: 8),
                Skeleton(
                  height: 12,
                ),
                SizedBox(height: 8),
                Skeleton(
                  height: 12,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 130),
                    Expanded(
                        child: Skeleton(
                      height: 12,
                    )),
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 16),
          Skeleton(width: 130, height: 80),
        ],
      ),
    );
  }
}
