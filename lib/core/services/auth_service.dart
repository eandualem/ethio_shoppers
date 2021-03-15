import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final apiKey = "AIzaSyAAKdnuNHN8KAwno48j0EIUFYhs6TJvweI";
  String getUrl(String serviceName) => "https://identitytoolkit.googleapis.com/v1/accounts:$serviceName?key=$apiKey";

  Future<void> authenticate(String email, String password, String action) async {
    var url;
    if( action == "signUp") url = Uri.parse(getUrl("signUp"));
    else url = Uri.parse(getUrl("signInWithPassword"));

    try {
      final response = await http.post(url, body: json.encode({
        "email":email,
        "password":password,
        "returnSecureToken":true}));

      final responseData = json.decode(response.body);
      if(responseData['error'] != null) throw responseData['error']['message'];
    }
    catch (err) {
      // TODO
    }

  }
}