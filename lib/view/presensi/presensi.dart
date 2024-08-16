import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_mobile/view/presensi/presensi_action.dart';
import 'package:presensi_mobile/view/presensi/presensi_map.dart';
import 'package:presensi_mobile/view/presensi/presensi_permission.dart';

import '../../models/check_shift.dart';
import '../../models/fetch_user_data.dart';

class Presensi extends StatefulWidget {
  final int userId;
  const Presensi({
    required this.userId,
    super.key
  });

  @override
  State<Presensi> createState() => _PresensiState();
}

class _PresensiState extends State<Presensi> {
  final LatLng _definedLocation = const LatLng(-0.05575583791780996, 109.3484786862145);
  LatLng _currentLocation = const LatLng(-0.0555, 109.3488);
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isInRange = false;
  bool _isInShift = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchUserData();
    await _checkShift();
  }

  void _changeStatus(bool isInRange) {
    setState(() {
      _isInRange = isInRange;
    });
  }

  void _updateCurrentLocation(LatLng newLocation) {
    setState(() {
      _currentLocation = newLocation;
    });
  }

  int extractHour(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    return hours;
  }

  Future<void> _fetchUserData() async {
    _userData = await fetchUserData(widget.userId);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkShift() async {
    if (_userData == null) { // Verify the availability of _userData
      setState(() {
        _isInShift = false;
      });
      return;
    }
    final shiftData = await fetchShiftData(_userData!['shift_id']);

    if (shiftData == null) { // Verify the availability of shiftData
      setState(() {
        _isInShift = false;
      });
      return;
    }

    try {
      int waktuMasuk = extractHour(shiftData['waktu_masuk']);
      int waktuKeluar = extractHour(shiftData['waktu_keluar']);

      DateTime now = DateTime.now();
      DateTime rangeStart1 = DateTime(now.year, now.month, now.day, waktuMasuk - 1, 0);
      DateTime rangeEnd1 = DateTime(now.year, now.month, now.day, waktuMasuk, 0);
      DateTime rangeStart2 = DateTime(now.year, now.month, now.day, waktuKeluar, 0);
      DateTime rangeEnd2 = DateTime(now.year, now.month, now.day, waktuKeluar + 1, 0);

      if ((now.isAfter(rangeStart1) && now.isBefore(rangeEnd1)) || // Verify if the time matches the shift time
          (now.isAfter(rangeStart2) && now.isBefore(rangeEnd2))) {
        setState(() {
          _isInShift = true;
        });
      } else {
        setState(() {
          _isInShift = false;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error checking shift: $error');
      }
      setState(() {
        _isInShift = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_isInShift) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // Semi-transparent background for the text container
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time,
                size: 50,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bukan waktu presensi!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan kembali pada waktu yang telah ditentukan.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PresensiPermission(
                        userId: widget.userId,
                        shiftId: _userData?['shift_id'] ?? 0
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  elevation: 5, // Shadow elevation
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ajukan Izin/Sakit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          PresensiMap(
            definedLocation: _definedLocation,
            currentLocation: _currentLocation,
            onStatusChange: _changeStatus,
            onUpdateCurrentLocation: _updateCurrentLocation,
          ),
          PresensiAction(
            isInRange: _isInRange,
            currentLocation: _currentLocation,
            userId: widget.userId,
            shiftId: _userData?['shift_id'] ?? 0
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PresensiPermission(
                    userId: widget.userId,
                    shiftId: _userData?['shift_id'] ?? 0
                )),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue, // Text color
              elevation: 5, // Shadow elevation
              padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 16), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ajukan Izin/Sakit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

