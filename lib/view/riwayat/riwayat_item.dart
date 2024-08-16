import 'package:flutter/material.dart';

class RiwayatItem extends StatelessWidget {
  final String presensiStatusMasuk;
  final String presensiDate;
  final String presensiWaktuMasuk;
  final String presensiStatusKeluar;
  final String presensiWaktuKeluar;

  const RiwayatItem({
    super.key,
    required this.presensiStatusMasuk,
    required this.presensiDate,
    required this.presensiWaktuMasuk,
    required this.presensiStatusKeluar,
    required this.presensiWaktuKeluar,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'absen':
      case 'tidak hadir':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Icons.check_circle;
      case 'absen':
      case 'tidak hadir':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add navigation or other functionality here
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(...)));
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                presensiDate,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getStatusIcon(presensiStatusMasuk),
                    color: _getStatusColor(presensiStatusMasuk),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Masuk: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Text(
                    '$presensiStatusMasuk ($presensiWaktuMasuk)',
                    style: TextStyle(color: _getStatusColor(presensiStatusMasuk)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getStatusIcon(presensiStatusKeluar),
                    color: _getStatusColor(presensiStatusKeluar),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Text(
                    '$presensiStatusKeluar ($presensiWaktuKeluar)',
                    style: TextStyle(color: _getStatusColor(presensiStatusKeluar)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
