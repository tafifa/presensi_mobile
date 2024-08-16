import 'package:flutter/foundation.dart';

import '../config/supabase.dart';

Future<bool> checkExistingAttendance(int userId, String date, String column) async {
  try {
    final existingData = await supabaseClient
        .from('attendances')
        .select()
        .eq('employee_id', userId)
        .eq(column, date);

    return existingData.isNotEmpty;
  } catch (error) {
    if (kDebugMode) {
      print('Error checking existing attendance: $error');
    }
    return false;
  }
}

Future<bool> insertAttendance(int userId, int shiftId, String date, String time, double longitude, double latitude) async {
  try {
    final response = await supabaseClient.from('attendances').insert({
      'employee_id': userId,
      'shift_id': shiftId,
      'tanggal_masuk': date,
      'waktu_masuk': time,
      'long_masuk': longitude,
      'lat_masuk': latitude,
      'status_masuk': 'Hadir',
    });
    return response == null;
  } catch (error) {
    if (kDebugMode) {
      print('Error inserting attendance: $error');
    }
    return false;
  }
}

Future<bool> updateAttendance(int userId, String date, String time, double longitude, double latitude) async {
  try {
    final response = await supabaseClient.from('attendances').update({
      'tanggal_keluar': date,
      'waktu_keluar': time,
      'long_keluar': longitude,
      'lat_keluar': latitude,
      'status_keluar': 'Hadir',
    }).eq('employee_id', userId).eq('tanggal_masuk', date);

    return response == null;
  } catch (error) {
    if (kDebugMode) {
      print('Error updating attendance: $error');
    }
    return false;
  }
}
