import 'package:flutter/foundation.dart';

import '../config/supabase.dart';

Future<Map<String, dynamic>?> login(String email, String password) async {
  try {
    final response = await supabaseClient
        .from('employees')
        .select('id')
        .eq('email', email)
        .eq('password', password)
        .single();
    return response;
  } catch (error) {
    if (kDebugMode) {
      print('Error during login: $error');
    }
    return null;
  }
}
