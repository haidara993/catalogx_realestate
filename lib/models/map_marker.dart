import 'package:latlong2/latlong.dart';

class MapMarker {
  final String image;
  final String title;
  final String address;
  final LatLng location;

  const MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
}

final _locations = [
  LatLng(35.370838, 35.919310),
  LatLng(35.366656, 35.930243),
  LatLng(35.363375, 35.919911),
  LatLng(35.343517, 35.922023),
];

const _path = 'assets/images/';

final mapMarkers = [
  MapMarker(
      image: _path,
      title: 'الفروة',
      address: 'جبلة -الكورنيش - أخر شارع الفروة',
      location: _locations[0]),
  MapMarker(
      image: _path,
      title: 'بيتي',
      address: 'جبلة - النقعة - غرب تجمع الإناث',
      location: _locations[1]),
  MapMarker(
      image: _path,
      title: 'الغزالات',
      address: 'جبلة - الكورنيش -أخر شارع الغازالات',
      location: _locations[2]),
  MapMarker(
      image: _path,
      title: 'ضاحية المجد',
      address: 'جبلة - ضاحية المجد',
      location: _locations[3]),
];
