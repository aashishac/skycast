import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/screens/home_screen.dart';
import 'package:skycast/screens/settings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  Future<void> _searchCity({required String query}) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Please enter city name'),
        ),
      );
      return;
    }

    try {
      // Step 1: Convert city name to lat/lon using OpenWeather Geocoding API
      final key = dotenv.get("API_KEY");
      final geoUrl = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=1&appid=$key",
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
      final provider = context.read<WeatherProvider>();
      await provider.fetchCurrentWeather(lat: lat, lon: lon, cityName: query);
      await provider.fetchHourlyForecast(lat: lat, lon: lon);
      await provider.fetchDailyForecast(lat: lat, lon: lon);

      // Step 3: Navigate to HomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text('Sky Cast'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              //search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 0,
                ),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      // inner shadow illusion
                      BoxShadow(
                        color: Theme.of(context).cardColor,
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(
                      // color: Theme.of(context).cardColor, // text white
                      fontWeight: FontWeight.w500,
                    ),
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      // purple background inside field
                      prefixIcon: const Icon(
                        Icons.search,
                        // color: Colors.white,
                      ), // icon white
                      hintText: "Search city here...",
                      hintStyle: TextStyle(
                        //color: Colors.white.withOpacity(0.7),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      _searchCity(query: value);
                    },
                  ),
                ),
              ),

              //recent search history
              Consumer<WeatherProvider>(
                builder: (context, provider, _) {
                  final history = provider.searchHistoryList;

                  if (history.isEmpty) {
                    // show placeholder when nothing searched yet
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        'No searches yet',
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                    );
                  }

                  // show header + list when history exists
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          'Recent Searched cities',
                          style: Theme.of(context).textTheme.headlineSmall!,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.44,
                        ),
                        child: SingleChildScrollView(
                          child: SearchHistoryList(
                            provider: provider,
                            onSearchCity: (city) {
                              provider.addSearch(city);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              //suggested city
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 4.0,
                ),
                child: Text(
                  'Suggested city',
                  style: Theme.of(context).textTheme.headlineSmall!,
                ),
              ),
              NavigationTile(
                isSearching: false,
                placeTitle: 'Sydney',
                placeSubtitle: 'Australia',
                navigate: () => _searchCity(query: 'Sydney'),
              ),

              NavigationTile(
                isSearching: false,
                placeTitle: 'Paris',
                placeSubtitle: 'France',
                navigate: () => _searchCity(query: 'Paris'),
              ),
              NavigationTile(
                isSearching: false,
                placeTitle: 'Dubai',
                placeSubtitle: 'United Arab Emirate',
                navigate: () => _searchCity(query: 'Dubai'),
              ), // Purple Floating Action Button
            ],
          ),
        ),
      ),
      // ---------------- FAB ----------------
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
        shape: const CircleBorder(), // ensures circular shape
        child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ---------------- BOTTOM BAR ----------------
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationTile extends StatelessWidget {
  final String placeTitle;
  final String placeSubtitle;
  final VoidCallback? navigate;
  final VoidCallback? onCancel;
  final bool isSearching;

  const NavigationTile({
    super.key,
    required this.placeTitle,
    required this.placeSubtitle,
    this.navigate,
    this.onCancel,
    this.isSearching = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: GestureDetector(
        onTap: navigate,
        child: ListTile(
          tileColor: Theme.of(context).cardColor,
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSearching ? Icons.history : Icons.location_on_outlined,
                ),
              ),
            ),
          ),
          title: Text(
            placeTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          subtitle: isSearching
              ? null
              : Text(
                  placeSubtitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
          trailing: isSearching
              ? GestureDetector(
                  onTap: onCancel, // <-- delete callback here
                  child: const Icon(Icons.cancel),
                )
              : const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }
}

class SearchHistoryList extends StatelessWidget {
  final WeatherProvider provider;
  final void Function(String city)
  onSearchCity; // optional if you want to keep adding to history

  const SearchHistoryList({
    super.key,
    required this.provider,
    required this.onSearchCity,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final historyData = provider.searchHistoryList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final city = historyData[index];
          return NavigationTile(
            placeTitle: city,
            placeSubtitle: 'Tap to search again',
            isSearching: true,
            navigate: () async {
              if (city.isNotEmpty) {
                try {
                  // Step 1: Convert city name to lat/lon
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
                  await provider.fetchCurrentWeather(
                    lat: lat,
                    lon: lon,
                    cityName: city,
                  );
                  await provider.fetchHourlyForecast(lat: lat, lon: lon);
                  await provider.fetchDailyForecast(lat: lat, lon: lon);

                  // Step 3: Navigate to HomeScreen
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            onCancel: () {
              provider.deleteOnCancel(index);
            },
          );
        },
      ),
    );
  }
}
