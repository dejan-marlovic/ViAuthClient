// Copyright (c) 2017, Patrick Minogue. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http show Response;

class ViAuthClient
{
  /**
   * _baseUrl: The URL of vi_auth_api/index.php, on your server
   */
  ViAuthClient(this._baseUrl);

  /**
   * Login using a one-time token, suitable for via url or a token stored in browser sessionStorage.
   * Returns a new token
   */
  Future<String> loginWithToken(String token) async
  {
    return await _httpPOST("login_with_token", {"token":token});
  }

  /**
   * Login using username password combination
   * Returns a new token
   */
  Future<String> loginWithUsernamePassword(String username, String password) async
  {
    return await _httpPOST("login_with_username_password", {"username":username, "password":password});
  }

  /**
   * Register a new user with the client
   * Returns a new token
   */
  Future<String> register(String username, [String password = null]) async
  {
    return await _httpPOST("register", {"username":username, "password":password});
  }

  /**
   * Reset the users password to the one specified
   * Returns a new token
   */
  Future<String> resetPassword(String username, String password, String token) async
  {
    return await _httpPOST("reset_password", {"username":username, "password":password, "token":token});
  }

  /**
   * Returns a new token
   */
  Future<String> resetToken(String username) async
  {
    return await _httpPOST("reset_token", {"username":username});
  }

  /**
   * Unregister the user with the client
   */
  Future unregister(String username) async
  {
    await _httpPOST("unregister", {"username":username});
  }

  /**
   * Check if the specified token is valid
   */
  Future validateToken(String token) async
  {
    await _httpPOST("validate_token", {"token":token});
  }

  Future<String> _httpPOST(String command, Map<String, String> params) async
  {
    http.Response response = await _client.post(_baseUrl + "$command", body: JSON.encode(params));
    if (response.statusCode != 200) throw new Exception("${response.body} (http status: ${response.statusCode})");
    return response.body;
  }

  final BrowserClient _client = new BrowserClient();
  final String _baseUrl;
}