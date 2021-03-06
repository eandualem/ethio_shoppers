import 'dart:convert';
import 'package:ethio_shoppers/core/models/http_exception.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final apiKey = "AIzaSyAAKdnuNHN8KAwno48j0EIUFYhs6TJvweI";
  String getUrl(String serviceName) => "https://identitytoolkit.googleapis.com/v1/accounts:$serviceName?key=$apiKey";

  Future<dynamic> authenticate(String email, String password, String action) async {
    var url;
    if( action == "signUp") url = Uri.parse(getUrl("signUp"));
    else url = Uri.parse(getUrl("signInWithPassword"));

    try {
      final response = await http.post(url, body: json.encode({
        "email":email,
        "password":password,
        "returnSecureToken":true}));

      final responseData = json.decode(response.body);
      if(responseData['error'] != null) throw HttpException(responseData['error']['message']);
      else return responseData;
    }
    catch (err) {
      throw err;
    }
  }
}