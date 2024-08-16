import 'package:flutter/material.dart';
import 'package:presensi_mobile/view/riwayat/riwayat_item.dart';

import '../../models/fetch_riwayat_data.dart';

class RiwayatList extends StatefulWidget {
  final DateTime selectedDate;
  final int userId;

  const RiwayatList({
    super.key,
    required this.selectedDate,
    required this.userId,
  });

  @override
  State<RiwayatList> createState() => _RiwayatListState();
}

class _RiwayatListState extends State<RiwayatList> {
  List<Map<String, dynamic>> _riwayatData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayatData();
  }

  @override
  void didUpdateWidget(RiwayatList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _fetchRiwayatData();
    }
  }

  Future<void> _fetchRiwayatData() async {
    _riwayatData = (await fetchRiwayatData(widget.userId, widget.selectedDate))!;
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: CircularProgressIndicator()
        ),
      );
    }

    if (_riwayatData.isEmpty) {
      return const Center(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Text('Tidak ada data tersedia'),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children:
        _riwayatData.map((data) {
          return RiwayatItem(
            presensiDate: data['tanggal_masuk'] ?? '-',
            presensiStatusMasuk: data['status_masuk'] ?? '-',
            presensiWaktuMasuk: data['waktu_masuk'] ?? '-',
            presensiStatusKeluar: data['status_keluar'] ?? '-',
            presensiWaktuKeluar: data['waktu_keluar'] ?? '-',
          );
        }).toList(),
      ),
    );
  }
}
