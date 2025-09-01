import 'dart:async';

import 'package:flutter_refresh_token/services/api_service.dart';
import 'package:flutter_refresh_token/services/secure_storage_service.dart';

class TokenRefresher {
  static Completer<String?>? _refreshCompleter;

  /// Run refresh if it is not already running
  static Future<String?> refreshToken(
      ApiService api, String refreshToken) async {
    if (_refreshCompleter != null) {
      // refresh is already in progress - waiting for it
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    try {
      final newTokens = await api.refreshToken(refreshToken);
      await SecureStorageManager.writeData(
          'accessToken', newTokens.accessToken!);
      if (newTokens.refreshToken != null) {
        await SecureStorageManager.writeData(
            'refreshToken', newTokens.refreshToken!);
      }
      _refreshCompleter!.complete(newTokens.accessToken);
      return newTokens.accessToken;
    } catch (e) {
      await SecureStorageManager.clearAllData();
      _refreshCompleter!.completeError(e);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}
