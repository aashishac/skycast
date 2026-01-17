// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:skycast/models/weather_models.dart';
import 'package:skycast/providers/weather_provider.dart';
import 'package:skycast/screens/search_screen.dart';
import 'package:skycast/screens/settings.dart';
import 'package:skycast/widgets/current_weather_card.dart';
import 'package:skycast/widgets/daily_lists.dart';
import 'package:skycast/widgets/hourly_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  Weather? currentWeather;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    /// ✅ PREVENT ANALYZER + PREVIEW CRASH
    if (weatherProvider.currentWeather == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF333162),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final weather = weatherProvider.currentWeather!;

    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 216, 216, 216),

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 216, 216, 216),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 5),
            Text(weather.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          const Icon(Icons.menu),
          const SizedBox(width: 8),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentWeatherCard(
              temp: weather.main.temp.toStringAsFixed(0),
              weatherType: weather.weather.first.main,
              icon: weather.weather[0].iconUrl,
            ),

            const SizedBox(height: 8),

            // -------- INFO ROW 1 --------
            Row(
              children: [
                Expanded(
                  child: buildInfoCard(
                    context: context,
                    iconPath: Image.asset('assets/humidity.png'),
                    infoLabel: "Humidity",
                    value: "${weather.main.humidity}%",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildInfoCard(
                    context: context,
                    iconPath: Image.asset('assets/wind.png'),
                    infoLabel: "Wind",
                    value: "${weather.wind.speed} km/h",
                  ),
                ),
              ],
            ),

            // -------- INFO ROW 2 --------
            Row(
              children: [
                Expanded(
                  child: buildInfoCard(
                    context: context,
                    iconPath: Image.asset('assets/visibility.png'),
                    infoLabel: "Visibility",
                    value: "${weather.visibility / 1000}m",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildInfoCard(
                    context: context,
                    iconPath: Image.asset('assets/temp.png'),
                    infoLabel: "Feels Like",
                    value: "${weather.main.feelsLike.toStringAsFixed(0)}°",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -------- HOURLY --------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 120, child: HourlyList()),

            const SizedBox(height: 20),

            // -------- DAILY --------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Daily Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: DailyList(),
            ),

            const SizedBox(height: 25),
          ],
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
              IconButton(icon: const Icon(Icons.home), onPressed: () {}),
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

// ---------------- INFO CARD ----------------
Widget buildInfoCard({
  required BuildContext context,
  required Image iconPath,
  required String infoLabel,
  required String value,
}) {
  return Card(
    elevation: 4,
    color: Theme.of(context).cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(height: 24, width: 24, child: iconPath),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  infoLabel,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    ),
  );
}
