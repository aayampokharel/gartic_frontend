import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  String httpBody;
  ApiService._(this.httpBody);

  static Future<String> post(String name) async {
    var response = await http.post(
        Uri.parse(
            "http://localhost:8080/currentcheck"), //!adds the current player in the list and returns the first player ELSE THIS SHOULD BE MADE TO RECEIVE IF ALL ARE IN BREAK, THEN INSTEAD OF NAME I SHOULD GET THE BREAK THING .
        body: json.encode(name));
    var httpBody = response.body;

    return httpBody;
  }
}
//! try to return Apiservice._(-----);