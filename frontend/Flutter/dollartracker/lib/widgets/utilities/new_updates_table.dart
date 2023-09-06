import 'package:flutter/material.dart';

class NewUpdatesTable extends StatelessWidget {
  const NewUpdatesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Row(
          children: [
            Text(
              "data",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
