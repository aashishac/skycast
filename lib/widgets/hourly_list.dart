// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:skycast/constants/helper_function.dart';
// import 'package:skycast/providers/weather_provider.dart';

// class HourlyList extends StatelessWidget {
//   const HourlyList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<WeatherProvider>();
//     final dataList = provider.hourlyDataList;

//     return SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           final data = dataList[index]; // <- use this variable
//           final format = DateFormat("yyyy-MM-dd HH:mm:ss");
//           DateTime dateTime = format.parse(data.dtTxt);
//           String timeOnly = DateFormat("h a").format(dateTime);

//           return Card(
//             elevation: 4,
//             color: Theme.of(context).cardColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             margin: const EdgeInsets.all(8),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(timeOnly),
//                   Image.network(
//                     data.iconUrl, // <- use 'data' here
//                     width: 24,
//                     height: 24,
//                     color: Theme.of(context).iconTheme.color,
//                   ),
//                   Text(
//                     '${kelvinToCelcius(data.main.temp)}°',
//                     style: TextStyle(
//                       color: Theme.of(context).textTheme.bodyLarge?.color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skycast/providers/weather_provider.dart';

class HourlyList extends StatelessWidget {
  const HourlyList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Consumer<WeatherProvider>(
        builder: (context, provider, _) {
          final dataList = provider.hourlyDataList;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              final format = DateFormat("yyyy-MM-dd HH:mm:ss");
              DateTime dateTime = format.parse(data.dtTxt);
              String timeOnly = DateFormat("h a").format(dateTime);

              return Card(
                elevation: 4,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(timeOnly),
                      Image.network(
                        data.iconUrl,
                        width: 24,
                        height: 24,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      Text(
                        '${data.main.temp.toStringAsFixed(0)}°',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
