import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/core/utils/app_strings.dart';
import 'package:task/features/products/presentation/widgets/row_text_info.dart';

class ProductGoogleMap extends StatefulWidget {
  const ProductGoogleMap({
    super.key,
  });

  @override
  State<ProductGoogleMap> createState() => _ProductGoogleMapState();
}

class _ProductGoogleMapState extends State<ProductGoogleMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTextInfo(title: "${AppStrings.store}: ", value: "Apple Store",),
        SizedBox(height: 12.h,),
        SizedBox(
          height: 250.h,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(24.782199, 46.686502),
              zoom: 11,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              const Marker(
                markerId: MarkerId('Riyad'),
                position: LatLng(24.782199, 46.686502),
              )
            },
          ),
        ),
      ],
    );
  }
}
