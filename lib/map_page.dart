// @dart=2.11

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  String image = 'images/boy.png';
  BitmapDescriptor _markerIcon;
  Completer _controller = Completer();
  static final CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(51.807768, 10.341856), zoom: 18.0);
  Set<Marker> _listMarkers = <Marker>{};
  List<LatLng> longs = [
    LatLng(51.807979, 10.340948),
    LatLng(51.807768, 10.341856),
    LatLng(51.807204, 10.342045),
    LatLng(51.808285, 10.341562),
    LatLng(51.808013, 10.342656),
  ];

  void addMarkers() {
    for (var i = 0; i < longs.length; i++) {
      Marker marker = Marker(
        markerId: MarkerId(longs[i].latitude.toString()),
        position: LatLng(longs[i].latitude, longs[i].longitude),
        infoWindow: InfoWindow(
            snippet:
                '${longs[i].latitude.toString()} - ${longs[i].latitude.toString()}',
            title: 'Info Title: ${i + 1}'),
        icon: _markerIcon ?? BitmapDescriptor.defaultMarker,
      );

      _listMarkers.add(marker);

      print('Done!!!');
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(60.0, 60.0));
      await BitmapDescriptor.fromAssetImage(imageConfiguration, image,
              mipmaps: true)
          .then(_updateBitmap);
      print('Done Mark Icon: ${_markerIcon.toJson().toString()}');
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createMarkerImageFromAsset(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _cameraPosition,
          mapType: MapType.normal,
          markers: _listMarkers,
          onMapCreated: (GoogleMapController controller) {
            addMarkers();
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
