import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../provider/location_provider.dart';
import '../../../responsive/Adapt.dart';
import '../../widgets/appBar.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

class AddNewLocationMap extends StatefulWidget {
  const AddNewLocationMap({Key? key}) : super(key: key);

  @override
  State<AddNewLocationMap> createState() => LocationMapState();
}

class LocationMapState extends State<AddNewLocationMap> {
  final Completer<GoogleMapController> _controller = Completer();

  final location = Location();
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> _markers = {};
  late LocationData posPin;
  late LocationData actualLocation;
  bool cargaPosicion = false;
  LatLng posicionGlobal = LatLng(0, 0);
  Image imageRegreso = Image.asset(
    'assets/botones/BotonRegresar.png',
    fit: BoxFit.cover,
  );
  @override
  void initState() {
    super.initState();
    _getInitialPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "",
            textoLabel: AppLocalizations.of(context)!.ubicacion,
            anotherButton: Container(
              width: Adapt.wp(12),
            ),
            bottonBackAction: () {
              Navigator.pushReplacementNamed(context, '/listLocations');
            },
          ),
        ),
        body: Stack(
          children: [
            body(),
            Positioned(
                top: Adapt.hp(35.5),
                right: Adapt.wp(46),
                child: Image.asset(
                  'assets/maps/pinUsuario.png',
                  height: 30,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }

  Widget body() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    try {
      return Column(
        children: [
          Container(
              height: Adapt.hp(76),
              child: cargaPosicion == true
                  ? GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: posicionGlobal,
                        zoom: 14.4746,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      onTap: (location) {},
                      onCameraMove: (CameraPosition position) {
                        locationProvider.ubicacionDot = position.target;
                      },
                    )
                  : Container()),
          ElevatedButtonCustom(
            textButton: AppLocalizations.of(context)!.aceptar,
            onPressedAction: () {
              Navigator.pushReplacementNamed(context, '/newLocationDetails');
            },
          ),
        ],
      );
    } catch (e) {
      print(e);
      return const LoadingIndicatorW();
    }
  }

  void _getInitialPosition() async {
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) throw 'GPS service is disabled';
    }
    if (await location.hasPermission() == PermissionStatus.denied) {
      if (await location.requestPermission() != PermissionStatus.granted) {
        throw 'No GPS permissions';
      }
    }

    final LocationData currentLocation = await location.getLocation();

    posicionGlobal =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    cargaPosicion = true;
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final LocationData data2 = await location.getLocation();
    locationProvider.ubicacionDot = LatLng(data2.latitude!, data2.longitude!);

    if (!_controller.isCompleted) {
      _controller.complete(controller);
      setState(() {});
    }
  }
}
