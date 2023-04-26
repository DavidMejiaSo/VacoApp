import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/src/pages/cart/grocery_store_cart_detail.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/location_user_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/appBar.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../widgets/elevated_botton_cancel.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

class HomeListLocation extends StatefulWidget {
  const HomeListLocation({Key? key}) : super(key: key);

  @override
  State<HomeListLocation> createState() => _HomeListLocationState();
}

List listIdLocationUser = [];
final userLocations = LocationUserService();

class _HomeListLocationState extends State<HomeListLocation> {
  Image imageRegreso = Image.asset(
    'assets/botones/BotonRegresar.png',
    fit: BoxFit.cover,
  );
  @override
  void initState() {
    listIdLocationUser = [];
    super.initState();
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
            textoLabel: AppLocalizations.of(context)!.misDirecciones,
            anotherButton: Container(
              width: Adapt.wp(12),
            ),
            bottonBackAction: () {
              Navigator.pushReplacementNamed(context, '/mainScreen');
            },
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [const BackgroundShop(), _body()],
        )),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          FutureBuilder(
            future: userLocations.getLocationsByUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length != 0) {
                  return Center(
                    child: Container(
                      height: Adapt.hp(72),
                      child: ListView.custom(
                        childrenDelegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return InkWell(
                              child: Container(
                                height: Adapt.hp(11),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Padding(
                                      padding: EdgeInsets.all(
                                        Adapt.px(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          snapshot.data[index]['porDefecto'] ==
                                                  true
                                              ? Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      Adapt.px(5),
                                                    ),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .circleCheck,
                                                      size: Adapt.px(30),
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              : Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      Adapt.px(5),
                                                    ),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .circleCheck,
                                                      size: Adapt.px(30),
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: Adapt.wp(4),
                                          ),
                                          bodyPart1(snapshot.data[index]
                                              ["direccion"]),
                                          SizedBox(
                                            width: Adapt.wp(4),
                                          ),
                                          Flexible(
                                            child: SizedBox(
                                              height: Adapt.hp(12),
                                              child: IconButton(
                                                iconSize: Adapt.px(30),
                                                icon: const Icon(
                                                  FontAwesomeIcons.trashCan,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  deleteLocationAlert(snapshot
                                                      .data[index]["id"]
                                                      .toString());
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              onTap: () {
                                setPresetLocation(
                                    snapshot.data, snapshot.data[index]["id"]);

                                prefs.defaultLocation =
                                    snapshot.data[index]["direccion"];
                                prefs.latitud = double.parse(
                                    snapshot.data[index]["latitud"]);
                                prefs.longitud = double.parse(
                                    snapshot.data[index]["longitud"]);
                              },
                            );
                          },
                          childCount: snapshot.data.length,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text(AppLocalizations.of(context)!.noTienesDirecciones,
                      style: const TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 1.0,
                            color: Color.fromARGB(255, 248, 248, 248),
                          ),
                        ],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ));
                }
              } else {
                return const Center(
                  child: LoadingIndicatorW(),
                );
              }
            },
          ),
          SizedBox(
            height: Adapt.hp(1),
            width: Adapt.wp(30),
          ),
          ElevatedButtonCustom(
            textButton: AppLocalizations.of(context)!.nuevaDireccion,
            onPressedAction: () {
              Navigator.pushReplacementNamed(context, '/addNewLocationMap');
            },
          ),
          //
        ],
      ),
    );
  }

  Widget bodyPart1(textSnapshop) {
    return Container(
      height: Adapt.hp(5),
      decoration: BoxDecoration(
        border: const Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 212, 212, 212),
              width: 2,
            ),
            top: BorderSide(
              color: Color.fromARGB(255, 212, 212, 212),
              width: 2,
            ),
            right: BorderSide(
              color: Color.fromARGB(255, 212, 212, 212),
              width: 2,
            ),
            left: BorderSide(
              color: Color.fromARGB(255, 212, 212, 212),
              width: 2,
            )),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.wp(1),
          ),
          SizedBox(
            width: Adapt.wp(5),
            child: Icon(
              FontAwesomeIcons.locationDot,
              size: Adapt.px(30),
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: Adapt.wp(1),
          ),
          SizedBox(
            width: Adapt.wp(65),
            child: Padding(
              padding: EdgeInsets.all(Adapt.px(5)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  textSnapshop,
                  style: TextStyle(fontSize: Adapt.px(30), color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteLocationAlert(idUbicacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCustom(
          bodyText: AppLocalizations.of(context)!.confirmarEliminacionDireccion,
          bottonAcept: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                primary: ColorSelect.primaryColorVaco,
                textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            child: Text(AppLocalizations.of(context)!.aceptar,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            onPressed: () {
              deleteLocation(idUbicacion);
              setState(() {});
              Navigator.pushReplacementNamed(context, '/listLocations');
            },
          ),
          bottonCancel: ElevatedButtonCancelCustom(),
        );
      },
    );
  }

  void deleteLocation(idUbicacion) async {
    await userLocations.deleteLocation(idUbicacion);
  }

  void setPresetLocation(totalDeDatos, idUbicacion) async {
    listIdLocationUser = [];
    for (var i = 0; i < totalDeDatos.length; i++) {
      // listIdLocationUser.add(totalDeDatos[i]['id']);
      if (totalDeDatos[i]['id'] != idUbicacion) {
        await userLocations.unsetFavoriteLocation(totalDeDatos[i]['id']);
      }
    }
    await userLocations.setFavoriteLocation(idUbicacion);

    setState(() {});
  }
}
