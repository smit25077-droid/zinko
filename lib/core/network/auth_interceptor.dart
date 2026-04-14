import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/global_network_overlay.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/data/models/auth_responses.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor(this.sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. Centralized Token Addition
    final jsonString = sharedPreferences.getString(CACHED_USER_DATA);
    if (jsonString != null) {
      try {
        final userData = UserData.fromJson(json.decode(jsonString));
        if (userData.token.isNotEmpty) {
          final cleanToken = userData.token.trim().replaceAll('"', '');
          options.headers['Authentication'] = cleanToken;
        }
      } catch (_) {
        // Handle malformed JSON if necessary
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 2. Global Token Expiration/Unauthorized Handling (401 or 403)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Clear session cache
      sharedPreferences.remove(CACHED_USER_DATA);

      // Navigate to login screen and clear history
      // Note: pushing to the route automatically clears the stack
      zinkoNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    }
    super.onError(err, handler);
  }
}
