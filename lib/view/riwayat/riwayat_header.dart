import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class RiwayatHeader extends StatelessWidget {
  final DateTime selectedDate;
  final Function(int) onMonthChange;

  const RiwayatHeader({
    super.key,
    required this.selectedDate,
    required this.onMonthChange,
  });

  @override
  Widget build(BuildContext context) {
    final String currentMonth = DateFormat('MMM yyyy', 'en_US').format(selectedDate);

    return Column(
      children: [
        Container(
          color: Colors.blue[900],
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Presensi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onMonthChange(-1),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 100), // Set a minimum width
                        child: Center(
                          child: Text(
                            currentMonth,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onMonthChange(1),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: FaIcon(
                            FontAwesomeIcons.chevronRight,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
