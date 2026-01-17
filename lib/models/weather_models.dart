class CurrentWeather {
  final List<Weather> weather;
  final Main main;
  final int visibility;
  final Wind wind;
  final Sys sys;
  final String name;

  CurrentWeather({
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.sys,
    required this.name,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      weather: (json['weather'] as List? ?? [])
          .map((item) => Weather.fromJson(item))
          .toList(),
      main: Main.fromJson(json['main'] ?? {}),
      visibility: json['visibility'] ?? 0,
      wind: Wind.fromJson(json['wind'] ?? {}),
      sys: Sys.fromJson(json['sys'] ?? {}),
      name: json['name'] ?? 'Unknown',
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['feels_like'] ?? 0.0).toDouble(),
      pressure: json['pressure'] ?? 0,
      humidity: json['humidity'] ?? 0,
    );
  }
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({required this.country, required this.sunrise, required this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'] ?? 'N/A',
      sunrise: json['sunrise'] ?? 0,
      sunset: json['sunset'] ?? 0,
    );
  }
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({required this.main, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'] ?? 'Unknown',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
  String get iconUrl {
    return 'http://openweathermap.org/img/wn/$icon@2x.png';
  }
}

class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: (json['speed'] ?? 0.0).toDouble());
  }
}

class HourlyForecast {
  final List<ListElement> list;

  HourlyForecast({required this.list});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      list: (json['list'] as List? ?? [])
          .map((item) => ListElement.fromJson(item))
          .toList(),
    );
  }
}

class ListElement {
  final Main main;
  final List<Weather> weather;
  final Wind wind;
  final int visibility;
  final String dtTxt;

  ListElement({
    required this.main,
    required this.weather,
    required this.wind,
    required this.visibility,
    required this.dtTxt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) {
    return ListElement(
      main: Main.fromJson(json['main'] ?? {}),
      weather: (json['weather'] as List? ?? [])
          .map((item) => Weather.fromJson(item))
          .toList(),
      wind: Wind.fromJson(json['wind'] ?? {}),
      visibility: json['visibility'] ?? 0,
      dtTxt: json['dt_txt'] ?? '',
    );
  }

  /// ✅ Getter to return the hourly icon URL
  String get iconUrl {
    return weather.isNotEmpty ? weather[0].iconUrl : '';
  }
}

class DailyForecast {
  final List<DailyWeather> list;

  DailyForecast({required this.list});

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      list: (json['list'] as List? ?? [])
          .map((item) => DailyWeather.fromJson(item))
          .toList(),
    );
  }
}

class DailyWeather {
  final int dt;
  final Temp temp;
  final List<Weather> weather; // Use Weather from CurrentWeather

  DailyWeather({required this.dt, required this.temp, required this.weather});

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      dt: json['dt'] ?? 0,
      temp: Temp.fromJson(json['temp'] ?? {}),
      weather: (json['weather'] as List? ?? [])
          .map((item) => Weather.fromJson(item))
          .toList(),
    );
  }

  // ✅ Daily icon getter
  String get iconUrl => weather.isNotEmpty ? weather[0].iconUrl : '';
}

class Temp {
  final double day;
  final double min;
  final double max;
  final double night;
  final double eve;
  final double morn;

  Temp({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: (json['day'] as num?)?.toDouble() ?? 0.0,
      min: (json['min'] as num?)?.toDouble() ?? 0.0,
      max: (json['max'] as num?)?.toDouble() ?? 0.0,
      night: (json['night'] as num?)?.toDouble() ?? 0.0,
      eve: (json['eve'] as num?)?.toDouble() ?? 0.0,
      morn: (json['morn'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
