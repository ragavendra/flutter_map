import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/cancellable_tile_provider.dart';
import 'package:flutter_map_example/pages/custom_crs/custom_crs.dart';
import 'package:flutter_map_example/pages/epsg3413_crs.dart';
import 'package:flutter_map_example/pages/epsg4326_crs.dart';
import 'package:flutter_map_example/pages/home.dart';
import 'package:flutter_map_example/pages/markers.dart';
import 'package:flutter_map_example/pages/polyline.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_map Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8dea88),
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        CancellableTileProviderPage.route: (context) =>
            const CancellableTileProviderPage(),
        MarkerPage.route: (context) => const MarkerPage(),
      },
    );
  }
}
