import 'package:flutter/foundation.dart';

import '../config/supabase.dart';

Future<Map<String, dynamic>?> fetchUserData(int userId) async {
  try {
    final response = await supabaseClient
        .from('employees')
        .select()
        .eq('id', userId)
        .single();

    return response;
  } catch (error) {
    if (kDebugMode) {
      print('Error fetching user data: $error');
    }
    return null;
  }
}
