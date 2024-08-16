import 'package:flutter/material.dart';
import 'package:presensi_mobile/view/riwayat/riwayat_header.dart';
import 'package:presensi_mobile/view/riwayat/riwayat_list.dart';

class Riwayat extends StatefulWidget {
  final int userId;
  const Riwayat({
    required this.userId,
    super.key
  });

  @override
  RiwayatState createState() => RiwayatState();
}

class RiwayatState extends State<Riwayat> {
  DateTime _selectedDate = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + increment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          RiwayatHeader(
            selectedDate: _selectedDate,
            onMonthChange: _changeMonth,
          ),
          RiwayatList(
            userId: widget.userId,
            selectedDate: _selectedDate,
          ),
        ],
      ),
    );
  }
}
