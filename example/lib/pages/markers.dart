import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MarkerPage extends StatefulWidget {
  static const String route = '/markers';

  const MarkerPage({super.key});

  @override
  State<MarkerPage> createState() => _MarkerPageState();
}

class MarkerWithTooltip extends StatefulWidget {
  final Widget child;
  final String tooltip;
  final Function onTap;

  MarkerWithTooltip(
      {required this.child, required this.tooltip, required this.onTap});

  @override
  _MapMarkerState createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MarkerWithTooltip> {
  final key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          final dynamic tooltip = key.currentState;
          tooltip.ensureTooltipVisible();
          widget.onTap();
        },
        child: Tooltip(
          key: key,
          message: widget.tooltip,
          child: widget.child,
        ));
  }
}

class UserLocation{

  // final LatLng latLng;

  UserLocation() {
    // latLng = _determinePosition();
  }

  // LatLng latLng = new LatLng(0, 0);

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return
    var position = await Geolocator.getCurrentPosition();
    // latLng = new LatLng(position.latitude, position.longitude);
    return new LatLng(position.latitude, position.longitude);
  }

    // Future<Position> pos;
}

class _MarkerPageState extends State<MarkerPage> {
  Alignment selectedAlignment = Alignment.topCenter;
  bool counterRotate = false;

  bool popupShown = false;

  /// The Main Marker
  Container testMarkerContainer = new Container(
      child: new GestureDetector(
    behavior: HitTestBehavior.opaque,
    child: new Icon(Icons.location_on, size: 20.0, color: Colors.orange),
    onTap: () {
      /// So we want to display the marker if tapped
      // popupShown = true;
      // setState(() => {});
    },
  ));

  static const alignments = {
    315: Alignment.topLeft,
    0: Alignment.topCenter,
    45: Alignment.topRight,
    270: Alignment.centerLeft,
    null: Alignment.center,
    90: Alignment.centerRight,
    225: Alignment.bottomLeft,
    180: Alignment.bottomCenter,
    135: Alignment.bottomRight,
  };

  late final customMarkers = <Marker>[
    buildPin(const LatLng(49.26475868576362, -122.9813778720856)),
    buildPin(const LatLng(49.26455868576362, -122.98177778720856)),
  ];

  var tooltip = const Tooltip(
    message: 'Msg here',
    // key: GlobalKey(),
  );

Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return
    // var position =
    return await Geolocator.getCurrentPosition();
    // latLng = new LatLng(position.latitude, position.longitude);
    // return new LatLng(position.latitude, position.longitude);
  }

  LatLng _latLng = LatLng(0,0);
  Future<Position> _position = Future<Position>.value(Position(longitude: 0, latitude: 0,
   timestamp: DateTime(2024), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0,
    headingAccuracy: 0, speed: 0, speedAccuracy: 0));

  @override
  void initState() {
    super.initState();
    _position = _determinePosition();

    /* _position =
    _determinePosition().then((val) {
        _position = val;
    });
    _determinePosition().then((LatLng val) {
      _latLng = val;
    });*/
  }

    void _retry() {
    setState(() {
      _position = _determinePosition();
    });
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        child: MarkerWithTooltip(
            child: const Icon(Icons.location_pin, size: 40, color: Colors.teal),
            tooltip: "the tooltip text",
            onTap: () => {}),
        // ),
        /*
            IconButton(
          icon: Icon(Icons.location_pin, size: 40, color: Colors.teal),
          tooltip: 'Navigation menu ' + point.hashCode.toString(),
          onPressed: () => {
            const Tooltip(
              message: 'Tooltip msg here',
              decoration: BoxDecoration(color: Colors.amber),
            )
          },
        ),*/
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Markers')),
      drawer: const MenuDrawer(MarkerPage.route),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 130,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: 9,
                    itemBuilder: (_, index) {
                      final deg = alignments.keys.elementAt(index);
                      final align = alignments.values.elementAt(index);

                      return IconButton.outlined(
                        onPressed: () =>
                            setState(() => selectedAlignment = align),
                        icon: Transform.rotate(
                          angle: deg == null ? 0 : deg * pi / 180,
                          child: Icon(
                            deg == null ? Icons.circle : Icons.arrow_upward,
                            color: selectedAlignment == align
                                ? Colors.green
                                : null,
                            size: deg == null ? 16 : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tap the map to add markers!'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Counter-rotation'),
                        const SizedBox(width: 10),
                        Switch.adaptive(
                          value: counterRotate,
                          onChanged: (v) => setState(() => counterRotate = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: FutureBuilder<Position>(
          future: _position,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // data loaded:
              final androidDeviceInfo = snapshot.data;
              print('Locn is ${androidDeviceInfo?.latitude} and ${androidDeviceInfo?.longitude} ');
              /*return Center(
                child: Text('Android version: ${androidDeviceInfo?.latitude.toString()}'),
              );*/
              return
        FlutterMap(
              options: MapOptions(
                initialCenter:
                    // const LatLng(49.26456868576362, -122.98178778720856),
                    // _latLng,
                    LatLng(androidDeviceInfo!.latitude, androidDeviceInfo.longitude),
                    // LatLng(_position.latitude, _position.longitude)
                    // center_,
                initialZoom: 16,
                //onTap: (_, p) => setState(() => customMarkers.add(buildPin(p))),
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  rotate: counterRotate,
                  markers: const [
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      alignment: Alignment.centerLeft,
                      child: ColoredBox(
                        color: Colors.lightBlue,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('-->'),
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      alignment: Alignment.centerRight,
                      child: ColoredBox(
                        color: Colors.pink,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('<--'),
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      rotate: false,
                      child: ColoredBox(color: Colors.black),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: customMarkers,
                  rotate: counterRotate,
                  alignment: selectedAlignment,
                ),
              ],
            );
            //,

            }
          },
        ),
        /*IconButton(
          icon: Icons.circle,
          onPressed: _retry,
          child: Text('Retry'),
        )*/
         ),
        ],
      ),
    );
  }
}
