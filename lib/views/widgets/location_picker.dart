import 'package:catalog/controllers/property_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerView extends StatefulWidget {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.363149, 35.932120),
    zoom: 13,
  );

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  MapType _currentMapType = MapType.normal;
  Set<Marker> myMarker = new Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.layers),
        onPressed: () => {
          setState(() {
            _currentMapType = (_currentMapType == MapType.normal)
                ? MapType.satellite
                : MapType.normal;
          })
        },
        heroTag: null,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: LocationPickerView._initialCameraPosition,
            zoomControlsEnabled: false,
            onTap: (tapPosition) {
              Get.find<PropertyController>()
                  .setLocation(tapPosition.latitude, tapPosition.longitude);
              Future.delayed(const Duration(seconds: 2), () {
                Get.back();
              });

              setState(() {
                myMarker = new Set();
                myMarker.add(Marker(
                    markerId: MarkerId(tapPosition.toString()),
                    position: tapPosition));
              });
            },
            markers: myMarker,
            onMapCreated: (controller) => Get.find<PropertyController>()
                .setGoolgeMapController(controller),
            compassEnabled: true,
            rotateGesturesEnabled: false,
            mapType: _currentMapType,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
          ),
        ],
      )),
    );
  }
}
