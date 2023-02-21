import 'package:flutter/material.dart';

class LBDateRangeBtnUI extends StatelessWidget {
  final DateTime startDate, endDate;
  final Function() onTap;
  const LBDateRangeBtnUI({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.teal.shade300.withAlpha(50),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    " From: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${startDate.day}-${startDate.month}-${startDate.year}',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    " To: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${endDate.day}-${endDate.month}-${endDate.year}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
