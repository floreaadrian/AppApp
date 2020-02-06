import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';

class BusinessMap extends StatefulWidget {
  final BusinessInfo businessInfo;

  BusinessMap({Key key, @required this.businessInfo}) : super(key: key);

  @override
  _BusinessMapState createState() => _BusinessMapState();
}

class _BusinessMapState extends State<BusinessMap> {
  Set markers = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: widget.businessInfo.latLng,
      zoom: 15,
    );
    markers.add(
      Marker(
        markerId: MarkerId(widget.businessInfo.id),
        position: widget.businessInfo.latLng,
        infoWindow: InfoWindow(title: widget.businessInfo.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      // 2
      initialCameraPosition: _myLocation,
      // 3
      mapType: MapType.normal,
      // 4
      onMapCreated: (GoogleMapController controller) {
        _setStyle(controller);
        _controller.complete(controller);
      },
    );
  }
}
