// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../.const.dart';

class LocationSearchService {
  static const String _baseUrl = 'https://rsapi.goong.io';

  // Find places by query
  static Future<Map<String, dynamic>> searchPlaces(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/Place/AutoComplete?input=$query&api_key=$GOONG_API_KEY'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to search places. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }

  // Geocode the address to find lat, lng
  static Future<Map<String, dynamic>> geocodeAddress(String address) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Geocode?address=$address&api_key=$GOONG_API_KEY'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to geocode address. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error geocoding address: $e');
    }
  }

  static Future<Map<String, dynamic>> reverseGeocode(
      double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/Geocode?latlng=$latitude,$longitude&api_key=$GOONG_API_KEY'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to reverse geocode. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reverse geocoding: $e');
    }
  }
}
