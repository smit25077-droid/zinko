import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserData(UserData userToCache);
  Future<UserData?> getLastUserData();
  Future<void> clearCache();
}

const CACHED_USER_DATA = 'CACHED_USER_DATA';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUserData(UserData userToCache) {
    return sharedPreferences.setString(
      CACHED_USER_DATA,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserData?> getLastUserData() {
    final jsonString = sharedPreferences.getString(CACHED_USER_DATA);
    if (jsonString != null) {
      return Future.value(UserData.fromJson(json.decode(jsonString)));
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.clear();
  }
}
