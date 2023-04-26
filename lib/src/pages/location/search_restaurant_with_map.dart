import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/restaurant_service.dart';
import '../../../service/supermercado_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/appBar.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

class SearchRestaurantWithMap extends StatefulWidget {
  const SearchRestaurantWithMap({Key? key}) : super(key: key);

  @override
  State<SearchRestaurantWithMap> createState() => InfoMapState();
}

class InfoMapState extends State<SearchRestaurantWithMap> {
  bool cargaPosicion = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LatLng posicionGlobal = LatLng(0, 0);

  final Completer<GoogleMapController> _controller = Completer();
  final _listRestaurants = RestaurantService();
  final _listSupermercados = SupermercadoService();
  final location = Location();
  final Set<Marker> _markers = {};

  late GoogleMapController mapController;
  late LocationData posPin;
  late LocationData actualLocation;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

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
            textoLabel: AppLocalizations.of(context)!.ubicacion,
            anotherButton: Container(),
            bottonBack: "false",
            bottonBackAction: () {},
          ),
        ),
        body: Stack(
          children: [
            body(),
          ],
        ),
      ),
    );
  }

  double _currentSliderValue = 20;
  Widget body() {
    try {
      return Column(
        children: [
          SizedBox(
              height: Adapt.hp(56),
              child: cargaPosicion == true
                  ? GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: posicionGlobal,
                        zoom: 16,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                    )
                  : Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Lo sentimos, tuvimos un error al cargar tu ubicación",
                            style: TextStyle(
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                ),
                              ],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorSelect.primaryColorVaco,
                            ),
                          ),
                        ),
                      ),
                    )),
          Slider(
            activeColor: ColorSelect.primaryColorVaco,
            inactiveColor: Colors.grey,
            value: _currentSliderValue,
            min: 0,
            max: 100,
            onChanged: (double movValue) {
              setState(() {
                _currentSliderValue = movValue;
              });
            },
            label: '${_currentSliderValue.round()}%',
          ),
          Text(
            '${_currentSliderValue.round()} km',
            style: TextStyle(
              fontSize: Adapt.px(25),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ElevatedButtonCustom(
            textButton: AppLocalizations.of(context)!.buscar,
            onPressedAction: () {
              _markers.clear();
              getMarkers();
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
    try {
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
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(mapController) {
    if (!_controller.isCompleted) {
      _controller.complete(mapController);

      getMarkers();
      setState(() {});
    }
  }

  void getMarkers() async {
    final listaDeRestaurantes =
        await _listRestaurants.listarRestaurantesAprobados();
    final listaSupermercados =
        await _listSupermercados.listarSupermercadosAprobados();

    final Uint8List restaurantMarkerIcon =
        await getBytesFromAsset('assets/maps/pinRestaurantes.png', 100);
    final Uint8List supermercadoMarkerIcon =
        await getBytesFromAsset('assets/maps/pinSupermercados.png', 100);

    for (var i = 0; i < listaDeRestaurantes.length; i++) {
      double distancia = 0.0;
      double a = listaDeRestaurantes[i]['latitud'] + 0.000001;
      double b = listaDeRestaurantes[i]['longitud'] + 0.000001;

      distancia = (Geolocator.distanceBetween(
                  a, b, posicionGlobal.latitude, posicionGlobal.longitude)
              .round() /
          1000);
      if (distancia <= _currentSliderValue) {
        if (listaDeRestaurantes[i]['latitud'] != 0 &&
            listaDeRestaurantes[i]['longitud'] != 0) {
          _markers.add(Marker(
            draggable: false,
            infoWindow: InfoWindow(
              title: '${listaDeRestaurantes[i]['nombre']}'.toUpperCase(),
            ),
            markerId: MarkerId(
              '$i',
            ),
            onTap: () {},
            position: LatLng(listaDeRestaurantes[i]['latitud'] as double,
                listaDeRestaurantes[i]['longitud'] as double),
            icon: BitmapDescriptor.fromBytes(restaurantMarkerIcon),
          ));
        }
      }
    }
    for (var i = 0; i < listaSupermercados.length; i++) {
      double distancia = 0.0;
      double a = listaSupermercados[i]['latitud'] + 0.000001;
      double b = listaSupermercados[i]['longitud'] + 0.000001;

      distancia = (Geolocator.distanceBetween(
                  a, b, posicionGlobal.latitude, posicionGlobal.longitude)
              .round() /
          1000);
      if (distancia <= _currentSliderValue) {
        if (listaSupermercados[i]['latitud'] != 0 &&
            listaSupermercados[i]['longitud'] != 0) {
          _markers.add(Marker(
            draggable: false,
            infoWindow: InfoWindow(
              title: '${listaSupermercados[i]['nombre']}'.toUpperCase(),
            ),
            markerId: MarkerId(
              '$i',
            ),
            onTap: () {},
            position: LatLng(listaSupermercados[i]['latitud'] as double,
                listaSupermercados[i]['longitud'] as double),
            icon: BitmapDescriptor.fromBytes(supermercadoMarkerIcon),
          ));
        }
      }
    }
    setState(() {});
    if (_markers.length == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogCustom(
            bodyText: AppLocalizations.of(context)!.noHayRestaurantes,
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        },
      );
    }
  }
}
