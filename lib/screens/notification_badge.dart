import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotication;

  NotificationBadge({Key? key, required this.totalNotication})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "$totalNotication",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
