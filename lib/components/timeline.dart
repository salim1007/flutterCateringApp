import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/progress_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeLine extends StatelessWidget {
  const OrderTimeLine(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.progressCard});
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final Widget progressCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        height: 140,
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: LineStyle(
              color: isFirst == true || isPast == true
                  ? Colors.orangeAccent
                  : Colors.grey),
          indicatorStyle: IndicatorStyle(
              width: 30,
              color: isFirst == true || isPast == true ? Colors.orangeAccent : Colors.grey,
              iconStyle: IconStyle(iconData: Icons.done, color: Colors.white)),
          endChild: ProgressCard(
            isPast: isPast,
            child: progressCard,
          ),
        ),
      ),
    );
  }
}
