import 'package:flutter/foundation.dart';

import '../config/supabase.dart';

Future<List<Map<String, dynamic>>?>fetchRiwayatData(int userId, DateTime selectedDate) async {
  try {
    final response = await supabaseClient.from('attendances').select()
        .eq('employee_id', userId)
        .gte('tanggal_masuk', '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-01')
        .lte('tanggal_masuk', '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-30');

    return response;
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching riwayat data: $error');
    }
    return null;
  }
}
