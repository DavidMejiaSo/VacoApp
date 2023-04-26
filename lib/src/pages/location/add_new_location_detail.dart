import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/backgroundShop.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../preferences/preferences_user.dart';
import '../../../provider/location_provider.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/location_user_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/appBar.dart';
import '../../widgets/elevated_button.dart';
import '../profile/profile.dart';

class NewLocationDetail extends StatefulWidget {
  NewLocationDetail({Key? key}) : super(key: key);

  @override
  State<NewLocationDetail> createState() => _NewLocationDetailState();
}

class _NewLocationDetailState extends State<NewLocationDetail> {
  @override
  void initState() {
    super.initState();
    getAddressFromLatLong();
    direccion = "";
    setState(() {});
  }

  Image imageRegreso = Image.asset(
    'assets/botones/BotonRegresar.png',
    fit: BoxFit.cover,
  );
  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 77, 77, 77),
    ),
    borderRadius: BorderRadius.circular(10),
  );
  Map infoUserLocation = {};
  String direccion = "";
  final prefs = PreferenciasUsuario();
  final userLocations = LocationUserService();
  bool serviceEnabled = false;

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
            textoLabel: AppLocalizations.of(context)!.nuevaDireccion,
            anotherButton: Container(
              width: Adapt.wp(12),
            ),
            bottonBackAction: () {
              Navigator.pushReplacementNamed(context, '/listLocations');
            },
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            const BackgroundShop(),
            serviceEnabled ? _body() : Container()
          ],
        )),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: Adapt.hp(10)),
          infoLocationDireccionTextfield(),
          SizedBox(height: Adapt.hp(1)),
          infoLocationDepartamentoTextfield(),
          SizedBox(height: Adapt.hp(1)),
          infoLocationMunicipioTextfield(),
          ElevatedButtonCustom(
            textButton: AppLocalizations.of(context)!.nuevaDireccion,
            onPressedAction: () {
              createLocaion(direccion);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogCustom(
                    bodyText: AppLocalizations.of(context)!.direccionGuardada,
                    bottonAcept: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          primary: ColorSelect.primaryColorVaco,
                          textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      child: Text(AppLocalizations.of(context)!.aceptar,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/listLocations');
                        setState(() {});
                      },
                    ),
                    bottonCancel: Container(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget infoLocationDireccionTextfield() {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        maxLength: 30,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          label: Text(
            AppLocalizations.of(context)!.direccion.toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          counterText: "",
        ),
        initialValue: infoUserLocation['direccion'].toString(),
        onChanged: (value) {
          setState(() {
            direccion = value;
          });
        },
        validator: null,
      ),
    );
  }

  Widget infoLocationDepartamentoTextfield() {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        maxLength: 30,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          label: Text(
            AppLocalizations.of(context)!.departamento.toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          counterText: "",
        ),
        initialValue: infoUserLocation['departamento'].toString(),
        onChanged: null,
        validator: null,
      ),
    );
  }

  Widget infoLocationMunicipioTextfield() {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        maxLength: 30,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          label: Text(
            AppLocalizations.of(context)!.municipio.toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          counterText: "",
        ),
        initialValue: infoUserLocation['municipio'] as String,
        onChanged: (String valor) {},
        validator: null,
      ),
    );
  }

  Future<void> getAddressFromLatLong() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    if (locationProvider.ubicacionDot.latitude != 0 &&
        locationProvider.ubicacionDot.longitude != 0) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationProvider.ubicacionDot.latitude,
          locationProvider.ubicacionDot.longitude);

      Placemark place = placemarks[0];

      infoUserLocation = {
        'direccion': place.street,
        "departamento": place.administrativeArea,
        "municipio": place.subAdministrativeArea,
        "latitud": locationProvider.ubicacionDot.latitude,
        "longitud": locationProvider.ubicacionDot.longitude,
        "porDefecto": false,
        "idUsuario": prefs.usuario
      };
    }
    serviceEnabled = true;
    setState(() {});
  }

  void createLocaion(direccion) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    direccion == '' ? direccion = infoUserLocation['direccion'] : direccion;
    await userLocations.crearteLocation(
        direccion,
        infoUserLocation["departamento"],
        infoUserLocation["municipio"],
        locationProvider.ubicacionDot.latitude,
        locationProvider.ubicacionDot.longitude);
  }

  void getDepartaments() async {
    listDepartamentsName = [];
    List listDepartaments = await registerService.getDepartamentos();
    listDepartamentTotal = listDepartaments;

    for (var i = 0; i < listDepartaments.length; i++) {
      listDepartamentsName.add(listDepartaments[i]["departamento"].toString());
    }

    for (var i = 0; i < listDepartaments.length; i++) {
      if (infoUserData["idDepartamento"] ==
          listDepartamentTotal[i]["departamento"]) {
        actuallyDepartentSelectedUser =
            listDepartamentTotal[i]["id_departamento"];
      }
    }
    try {
      getMunicipality(int.parse(actuallyDepartentSelectedUser));
    } catch (e) {}
  }

  void getMunicipality(numberID) async {
    List listMunicipality = await registerService.getMunicipio(numberID);
    for (var i = 0; i < listMunicipality.length; i++) {
      listMunicipalityName.add(listMunicipality[i]["municipio"].toString());
      if (listMunicipality[i]["id_municipio"] == infoUserData["idMunicipio"]) {
        actuallyMunicipalySelectedUser = listMunicipality[i]["municipio"];
      }
    }

    setState(() {});
  }
}
