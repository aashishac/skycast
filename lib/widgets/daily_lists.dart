import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skycast/models/weather_models.dart';
import 'package:skycast/providers/weather_provider.dart';

class DailyList extends StatelessWidget {
  const DailyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider, List<DailyWeather>>(
      selector: (_, provider) => provider.dailyDataList,
      builder: (context, dataList, child) {
        if (dataList.isEmpty) {
          return const Center(child: Text("No daily forecast available"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];

            // dt is an int (UNIX timestamp in seconds)
            final dateTime = DateTime.fromMillisecondsSinceEpoch(
              data.dt * 1000,
            );

            // Weekday variable (Today, Tomorrow, or actual weekday)
            final today = DateTime.now();
            final tomorrow = today.add(const Duration(days: 1));

            String weekday;
            final formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);
            if (formattedDate == DateFormat("yyyy-MM-dd").format(today)) {
              weekday = "Today";
            } else if (formattedDate ==
                DateFormat("yyyy-MM-dd").format(tomorrow)) {
              weekday = "Tomorrow";
            } else {
              weekday = DateFormat("EEEE").format(dateTime); // e.g. Friday
            }

            // Temperatures (already in Celsius if you used &units=metric)
            final tempMax = data.temp.max.toStringAsFixed(0);
            final tempMin = data.temp.min.toStringAsFixed(0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Card(
                elevation: 4,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          weekday,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.network(
                            data.iconUrl, // full URL string
                            width: 50,
                            height: 50,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "$tempMax° / $tempMin°",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
