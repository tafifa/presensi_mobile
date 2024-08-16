import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/attendance_service.dart';

class PresensiAction extends StatelessWidget {
  final LatLng currentLocation;
  final bool isInRange;
  final int userId;
  final int shiftId;

  const PresensiAction({
    required this.currentLocation,
    required this.isInRange,
    required this.userId,
    required this.shiftId,
    super.key,
  });

  Future<void> checkIn(BuildContext context, int userId, int shiftId, LatLng currentLocation) async {
    DateTime now = DateTime.now();
    String tanggalMasuk = DateFormat('yyyy-MM-dd').format(now);
    String waktuMasuk = DateFormat('HH:mm:ss').format(now);

    bool exists = await checkExistingAttendance(userId, tanggalMasuk, 'tanggal_masuk');

    if (!exists) {
      bool success = await insertAttendance(userId, shiftId, tanggalMasuk, waktuMasuk, currentLocation.longitude, currentLocation.latitude);

      if (success) {
        if (kDebugMode) {
          print('Record inserted successfully');
        }
        _showResultModal(context, 'Check In Berhasil');
      } else {
        if (kDebugMode) {
          print('Failed to insert record');
        }
        _showResultModal(context, 'Check In Gagal');
      }
    } else {
      if (kDebugMode) {
        print('Attendance record already exists for this date.');
      }
      _showResultModal(context, 'Check In Gagal');
    }
  }

  Future<void> checkOut(BuildContext context, int userId, LatLng currentLocation) async {
    DateTime now = DateTime.now();
    String tanggalKeluar = DateFormat('yyyy-MM-dd').format(now);
    String waktuKeluar = DateFormat('HH:mm:ss').format(now);

    bool exists = await checkExistingAttendance(userId, tanggalKeluar, 'tanggal_keluar');

    if (!exists) {
      bool success = await updateAttendance(userId, tanggalKeluar, waktuKeluar, currentLocation.longitude, currentLocation.latitude);

      if (success) {
        if (kDebugMode) {
          print('Record updated successfully');
        }
        _showResultModal(context, 'Check Out Berhasil');
      } else {
        if (kDebugMode) {
          print('Failed to update record');
        }
        _showResultModal(context, 'Check Out Gagal');
      }
    } else {
      if (kDebugMode) {
        print('No attendance record found for this date.');
      }
      _showResultModal(context, 'Check Out Gagal');
    }
  }

  void _showResultModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                foregroundColor: Colors.white,
                backgroundColor: isInRange ? Colors.green : Colors.grey, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Less curvy border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16), // Add padding
              ),
              onPressed: isInRange ? () => checkIn(context, userId, shiftId, currentLocation) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Check In'),
                  const SizedBox(height: 8),
                  Transform.rotate(
                    angle: 0, // Rotate the icon by -3.14 radians (180 degrees)
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRightToBracket,
                      // size: 18,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                foregroundColor: Colors.white,
                backgroundColor: isInRange ? Colors.red : Colors.grey, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Less curvy border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16), // Adjust padding as needed
              ),
              onPressed: isInRange ? () => checkOut(context, userId, currentLocation) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Check Out'),
                  const SizedBox(height: 8),
                  Transform.rotate(
                    angle: 3.14 / 2, // Rotate the icon by -3.14 radians (180 degrees)
                    child: const FaIcon(
                      FontAwesomeIcons.arrowUpFromBracket,
                      // size: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
