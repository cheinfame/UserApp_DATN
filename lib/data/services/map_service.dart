import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../.const.dart';
import '../models/route_model.dart';

class MapService {
  MapService();

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else if (response.statusCode == 400) {
      throw Exception(data['message'] ?? 'Bad request');
    } else if (response.statusCode == 401) {
      throw Exception(data['message'] ?? 'Unauthorized');
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createRoute(String token,
      {required LatLng startCoords,
      required LatLng endCoords,
      List<LatLng>? waypoints}) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUri/map/create-route'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'startCoords': {
            'lat': startCoords.latitude,
            'lng': startCoords.longitude
          },
          'endCoords': {'lat': endCoords.latitude, 'lng': endCoords.longitude},
          'waypoints': waypoints
              ?.map((waypoint) =>
                  {'lat': waypoint.latitude, 'lng': waypoint.longitude})
              .toList(),
        }),
      );

      return await _handleResponse(response);
    } catch (error) {
      print('Error creating route: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> saveRoute(String token, Route routeData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUri/map/save-route'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(routeData.toJson()),
      );

      return await _handleResponse(response);
    } catch (error) {
      print('Error saving route: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getShipperRoutes(
      String token, String shipperId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUri/map/shipper/$shipperId/routes'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          });

      return await _handleResponse(response);
    } catch (error) {
      print('Error getting shipper routes: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRouteById(
      String token, String routeId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUri/map/route/$routeId/get-route'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          });

      return await _handleResponse(response);
    } catch (error) {
      print('Error getting route by ID: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateRouteById(
      String token, String routeId, Route updateData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUri/map/route/$routeId/update-route'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateData.toJson()),
      );

      return await _handleResponse(response);
    } catch (error) {
      print('Error updating route by ID: $error');
      rethrow;
    }
  }

  Future<void> deleteRouteById(String token, String routeId) async {
    try {
      final response = await http.delete(
          Uri.parse('$baseUri/map/route/$routeId/delete-route'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
          });

      await _handleResponse(response);
    } catch (error) {
      print('Error deleting route by ID: $error');
      rethrow;
    }
  }
}
