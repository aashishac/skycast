import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:skycast/constants/theme/app_theme.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherFromLocation();
    });
  }

  Future<void> _fetchWeatherFromLocation() async {
    final provider = context.read<WeatherProvider>();
    double? latitude;
    double? longitude;

    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location services are disabled.'),
            action: SnackBarAction(
              label: 'Enable',
              onPressed: Geolocator.openAppSettings,
            ),
          ),
        );
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied.'),
              action: SnackBarAction(
                label: 'Enable',
                onPressed: Geolocator.openAppSettings,
              ),
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location permission permanently denied.'),
            action: SnackBarAction(
              label: 'Enable',
              onPressed: Geolocator.openAppSettings,
            ),
          ),
        );
        return;
      }

      // Get accurate position
      Future<Position> getAccuratePosition() async {
        // Try last known position first
        Position? lastPosition = await Geolocator.getLastKnownPosition();

        if (lastPosition != null) {
          return lastPosition;
        }

        // Force fresh GPS location
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
          ),
        );
      }

      // Get current position
      final position = await getAccuratePosition();
      latitude = position.latitude;
      longitude = position.longitude;

      debugPrint('LAT: $latitude, LNG: $longitude');

      // Get city name from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      final place = placemarks.first;
      final city =
          place.locality ??
          place.subAdministrativeArea ??
          place.administrativeArea ??
          place.country;

      debugPrint(
        'City=$city | locality=${place.locality} | '
        'subAdmin=${place.subAdministrativeArea} | '
        'admin=${place.administrativeArea} | '
        'country=${place.country}',
      );

      // Fetch weather
      // Step 1: Convert city name to lat/lon using OpenWeather Geocoding API
      final key = dotenv.get("API_KEY");
      final geoUrl = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$key",
      );
      final geoResponse = await http.get(geoUrl);

      if (geoResponse.statusCode != 200) {
        throw Exception("Failed to fetch coordinates");
      }

      final geoData = jsonDecode(geoResponse.body);
      if (geoData.isEmpty) {
        throw Exception("City not found");
      }

      final lat = geoData[0]['lat'];
      final lon = geoData[0]['lon'];

      // Step 2: Call provider methods with lat/lon
      await provider.fetchCurrentWeather(lat: lat, lon: lon, cityName: city);
      await provider.fetchHourlyForecast(lat: lat, lon: lon);
      await provider.fetchDailyForecast(lat: lat, lon: lon);

      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        if (provider.currentWeather != null &&
            provider.hourlyDataList.isNotEmpty &&
            provider.dailyDataList.isNotEmpty &&
            provider.errorMessage.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          debugPrint("Weather fetch failed: ${provider.errorMessage}");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching location: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF48309C), Color.fromARGB(255, 135, 108, 194)],
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.cloud_outlined, size: 120, color: Colors.white),
                Positioned(
                  top: 0,
                  right: -5,
                  child: Icon(
                    Icons.sunny,
                    size: 54,
                    color: Colors.yellowAccent,
                  ),
                ),
              ],
            ),
          ),
          // Title
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 220),
              child: Text(
                'Sky Cast',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Loading indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Consumer<WeatherProvider>(
                builder: (context, provider, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Fetching your weather...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 118),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: provider.loadingProgress,
                        backgroundColor: const Color.fromARGB(
                          237,
                          72,
                          53,
                          114,
                        ).withOpacity(0.6),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.highlight,
                        ),
                      ),
                    ),
                    Text(
                      '${(provider.loadingProgress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
