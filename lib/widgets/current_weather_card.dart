import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({
    super.key,
    required this.temp,
    required this.icon,
    required this.weatherType,
  });

  final String temp;
  final String icon;
  final String weatherType;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 263,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // -------- BACKGROUND IMAGE (optional) --------
            // Positioned.fill(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(20),
            //     child: Image.asset('assets/card_image.png', fit: BoxFit.cover),
            //   ),
            // ),

            // -------- THEME OVERLAY --------
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).cardColor, // ✅ use theme cardColor
                ),
              ),
            ),

            // -------- FOREGROUND CONTENT --------
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  icon,
                  width: 120,
                  height: 120,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // ✅ theme icon color
                ),
                const SizedBox(height: 8),
                Text(
                  '$temp°',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  weatherType,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
