// Copyright (c) 2017, Patrick Minogue. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http show Response;

class ViAuthClient
{
  /**
   * _baseUrl: The URL of vi_auth_api folder, on your server, including trailing slash
   */
  ViAuthClient(this._baseUrl, this._clientName);

  Future<String> fetchLastLogin(String username) async
  {
    return await _httpPOST("fetch_last_login", {"username":username});
  }

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
   * Update the users' password to the one specified
   * Returns a new token
   */
  Future<String> updatePassword(String username, String password, String token) async
  {
    return await _httpPOST("update_password", {"username":username, "password":password, "token":token});
  }

  /**
   * Send email/sms message to the specified user with new credentials,
   * or a custom message if for example the users account has become inactive
   * %token% placeholders are replaced server-side by a new valid token
   * %password% placeholders are replaced server-side by a new auto-generated password
   * %username% placeholders are replaced server-side by the users username
   */
  Future<String> sendCredentials(String username, {String emailFrom = null, String emailMessage = null, String emailSubject = null, String smsMessage = null, String smsFrom = null}) async
  {
    if (emailMessage == null && smsMessage == null) throw new ArgumentError.notNull("emailMessage + smsMesssage");

    return await _httpPOST("send_credentials", {"username":username, "email_from":emailFrom, "email_subject":emailSubject, "email_message":emailMessage, "sms_from":smsFrom, "sms_message":smsMessage});
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
    params["client"] = _clientName;
    _loading = true;
    http.Response response = await _browserClient.post(_baseUrl + "$command", body: JSON.encode(params));
    _loading = false;
    if (response.statusCode != 200) throw new Exception("${response.body}");
    return response.body;

  }

  bool get loading => _loading;

  bool _loading = false;
  final BrowserClient _browserClient = new BrowserClient();
  final String _baseUrl;
  final String _clientName;
}