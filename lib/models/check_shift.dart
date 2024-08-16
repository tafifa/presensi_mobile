import 'package:flutter/foundation.dart';

import '../config/supabase.dart';

Future<Map<String, dynamic>?> fetchShiftData(int shiftId) async {
  try {
    final response = await supabaseClient
        .from('shifts')
        .select()
        .eq('id', shiftId)
        .single();

    return response;
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching shift data: $error');
    }
    return null;
  }
}
