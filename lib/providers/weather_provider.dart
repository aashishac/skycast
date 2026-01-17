//
import 'package:flutter/material.dart';
import 'package:skycast/models/weather_models.dart';
import 'package:skycast/services/api_service.dart';

class WeatherProvider extends ChangeNotifier {
  // private variables
  final _apiService = ApiService();
  CurrentWeather? _currentWeather;
  List<ListElement> _hourlyForecastDataList = [];
  List<DailyWeather> _dailyForecastDataList = [];

  bool _isLoading = false;
  String _errorMessage = "";
  double _loadingProgress = 0.0;
  final List<String> _searchHistoryList = [];

  // getters
  CurrentWeather? get currentWeather => _currentWeather;
  List<ListElement> get hourlyDataList => _hourlyForecastDataList;
  List<DailyWeather> get dailyDataList => _dailyForecastDataList;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  double get loadingProgress => _loadingProgress;
  List<String> get searchHistoryList => _searchHistoryList;

  // methods to communicate with ApiService
  Future<void> fetchCurrentWeather({
    required double lat,
    required double lon,
    String? cityName,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    _loadingProgress = 0.0;
    notifyListeners();

    try {
      // 33 % complete
      _loadingProgress = 0.33;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      // 66% completed
      _loadingProgress = 0.66;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));

      _currentWeather = await _apiService.fetchCurrentWeather(
        lat: lat,
        lon: lon,
      );

      // keep search history if cityName provided
      if (cityName != null &&
          !_searchHistoryList
              .map((e) => e.toLowerCase())
              .contains(cityName.toLowerCase())) {
        if (_searchHistoryList.length >= 4) {
          _searchHistoryList.removeAt(0); // remove oldest
        }
        _searchHistoryList.add(cityName);
      }

      // 100% completed
      _loadingProgress = 1;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHourlyForecast({
    required double lat,
    required double lon,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    _loadingProgress = 1;
    notifyListeners();

    try {
      _hourlyForecastDataList = await _apiService.fetchHourlyForecast(
        lat: lat,
        lon: lon,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailyForecast({
    required double lat,
    required double lon,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    _loadingProgress = 1;
    notifyListeners();

    try {
      final forecast = await _apiService.fetchDailyForecast(lat: lat, lon: lon);
      _dailyForecastDataList = forecast.list;
      debugPrint("Parsed forecast days: ${_dailyForecastDataList.length}");
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addSearch(String city) {
    _searchHistoryList.add(city);
    notifyListeners();
  }

  void deleteOnCancel(int index) {
    _searchHistoryList.removeAt(index);
    notifyListeners();
  }
}
