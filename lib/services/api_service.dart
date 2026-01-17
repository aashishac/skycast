import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:skycast/models/weather_models.dart';

class ApiService {
  final _currentWeatherBaseUrl =
      "https://api.openweathermap.org/data/2.5/weather";
  final _hourlyBaseUrl =
      "https://pro.openweathermap.org/data/2.5/forecast/hourly";
  final _dailyBaseUrl =
      "https://api.openweathermap.org/data/2.5/forecast/daily";

  final key = dotenv.get("API_KEY");

  // Current weather by lat/lon
  Future<CurrentWeather> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final url = Uri.parse(
        "$_currentWeatherBaseUrl?lat=$lat&lon=$lon&appid=$key&units=metric",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return CurrentWeather.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch current weather: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching current weather: $e');
    }
  }

  // Hourly forecast by lat/lon
  Future<List<ListElement>> fetchHourlyForecast({
    required double lat,
    required double lon,
    int count = 8,
  }) async {
    try {
      final url = Uri.parse(
        "$_hourlyBaseUrl?lat=$lat&lon=$lon&cnt=$count&appid=$key&units=metric",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final data = HourlyForecast.fromJson(jsonData);
        return data.list;
      } else {
        throw Exception(
          'Failed to fetch hourly forecast: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching hourly forecast: $e');
    }
  }

  // Daily forecast by lat/lon
  Future<DailyForecast> fetchDailyForecast({
    required double lat,
    required double lon,
    int count = 7,
  }) async {
    try {
      final url = Uri.parse(
        "$_dailyBaseUrl?lat=$lat&lon=$lon&cnt=$count&appid=$key&units=metric",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return DailyForecast.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to fetch daily forecast: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching daily forecast: $e");
    }
  }
}
