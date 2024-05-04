import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, required this.isPast, required this.child});
  final bool isPast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isPast == true ?  Colors.orangeAccent : Colors.grey,
        borderRadius: BorderRadius.circular(10)
      ),
      child: child,
    );
  }
}