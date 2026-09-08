import 'package:supabase_flutter/supabase_flutter.dart';

class AiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> sendMessage(String message) async {
    try {
      final response = await _supabase.functions.invoke(
        'ai-chat',
        body: {'message': message},
      );

      print('AI FUNCTION RESPONSE: ${response.data}');

      final data = response.data;

      if (data == null) {
        throw Exception('No response received from AI.');
      }

      if (data is Map && data['error'] != null) {
        throw Exception(data['error'].toString());
      }

      return data['response']?.toString() ??
          'I could not generate a response.';
    } catch (e) {
      print('AI FUNCTION ERROR: $e');
      rethrow;
    }
  }
}