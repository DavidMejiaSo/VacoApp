import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../preferences/preferences_user.dart';
import 'package:provider/provider.dart';
import '../../../provider/promotions_provider.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/allergy_service.dart';
import '../../../service/login_service.dart';
import '../../../service/register_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

// ignore: must_be_immutable
class RegisterWithFacebook extends StatefulWidget {
  RegisterWithFacebook(
      {Key? key,
      required this.email,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.gender})
      : super(key: key);

  @override
  State<RegisterWithFacebook> createState() => _RegisterWithFacebookState();
  String email, id, firstName, lastName, gender;
}

final loginService = LoginService();
List<bool> listAlerys = [];
bool _check = false;
List alergiaSelected = [], allergyListByID = [];
String _tokenLogin = '';
String documentType = "",
    document = "",
    phone = "",
    departaments = "",
    municipioFinal = "",
    genderSelect = "",
    bornDate = "",
    departamentID = "",
    textBotton = "aaaa-mm-dd",
    textBotton2 = "",
    municipalityID = "";
final ButtonStyle style = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    padding:
        EdgeInsets.symmetric(horizontal: Adapt.px(20), vertical: Adapt.px(10)),
    primary: ColorSelect.primaryColorVaco,
    textStyle: TextStyle(
        fontSize: Adapt.px(30),
        fontWeight: FontWeight.bold,
        color: Colors.black));
var listDocuments = [
      "Tarjeta de Identidad",
      "Cédula de ciudadanía",
      "Cédula de Extrangería",
      "Pasaporte",
      "Registro Civil",
      "Id Extranjero",
      "Carnet diplomático"
    ],
    spaceBetween = SizedBox(height: Adapt.hp(2.5));

final prefs = PreferenciasUsuario();
final primaryFormKey = GlobalKey<FormState>();
final registerService = RegisterService();
final alergyService = getListAllergyUserService();
final textFFStyleOK = OutlineInputBorder(
  borderSide: BorderSide(
    color: ColorSelect.greyColor,
  ),
  borderRadius: BorderRadius.circular(30.0),
);
final textFFStyleWrong = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.red),
  borderRadius: BorderRadius.circular(30.0),
);
final ButtonStyle okButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    padding:
        EdgeInsets.symmetric(horizontal: Adapt.px(20), vertical: Adapt.px(10)),
    primary: ColorSelect.primaryColorVaco,
    textStyle: TextStyle(
        fontSize: Adapt.px(30),
        fontWeight: FontWeight.bold,
        color: Colors.black));
final ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    padding:
        EdgeInsets.symmetric(horizontal: Adapt.px(20), vertical: Adapt.px(10)),
    primary: const Color.fromARGB(255, 254, 37, 37),
    textStyle: TextStyle(
        fontSize: Adapt.px(30),
        fontWeight: FontWeight.bold,
        color: Colors.black));

class _RegisterWithFacebookState extends State<RegisterWithFacebook> {
  @override
  void initState() {
    listAlerys = [];
    _getAlergy();
    super.initState();
    allergyListByID = [];
    textBotton = "INGRESE LA FECHA DE NACIMIENTO";
    documentType = "";
    document = "";
    phone = "";
    departaments = "";
    municipioFinal = "";
    genderSelect = "";
    bornDate = "";
    departamentID = "";
    municipalityID = "";
    textBotton2 = "SELECIONE ALGUNA ALERGIA";
    alergiaSelected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoInicio.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          _bodyOne(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'continuar logueo',
              style: TextStyle(
                  fontSize: Adapt.px(40),
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: Adapt.hp(5)),
          _bodyTwo(),
          _bodyThree(),
        ],
      ),
    );
  }

  Widget _bodyOne() {
    return Container(
      width: Adapt.wp(100),
      child: Row(
        children: [
          Container(
            width: Adapt.wp(25),
            child: Center(
              child: Align(alignment: Alignment.topCenter, child: bottonBack()),
            ),
          ),
          SizedBox(
            child: Center(
              child: Container(
                width: Adapt.wp(50),
                child: Image(
                  height: Adapt.hp(10),
                  image: const AssetImage('assets/logos/LogoVaco.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyTwo() {
    return Container(
      height: Adapt.hp(60),
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(10.0),
      child: Form(
        key: primaryFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              documentTypeInput(),
              spaceBetween,
              imputDocument(),
              spaceBetween,
              imputPhone(),
              spaceBetween,
              selectAlergy()
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyThree() {
    return Column(
      children: [
        _checkRecordarCredenciales(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Adapt.wp(35),
              child: ElevatedButton(
                style: okButtonStyle,
                child: Text(AppLocalizations.of(context)!.registrate,
                    style: TextStyle(
                        fontSize: Adapt.px(22),
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                onPressed: () {
                  if (primaryFormKey.currentState!.validate()) {
                    if (_check) {
                      setState(() {});
                      _facebookRegister();
                      print("voy a registrar, parece bien");
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogCustom(
                              bodyText:
                                  AppLocalizations.of(context)!.aceptarTerminos,
                              bottonAcept: ElevatedButton(
                                style: style,
                                child: Text(
                                    AppLocalizations.of(context)!.aceptar,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              bottonCancel: Container(),
                            );
                          });
                    }
                  } else {
                    print("no valido");
                  }
                },
              ),
            ),
            SizedBox(width: Adapt.wp(5)),
            SizedBox(
              width: Adapt.wp(35),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.symmetric(
                        horizontal: Adapt.px(20), vertical: Adapt.px(10)),
                    primary: const Color.fromARGB(255, 254, 37, 37),
                    textStyle: TextStyle(
                        fontSize: Adapt.px(30),
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                child: Text(AppLocalizations.of(context)!.cancelar,
                    style: TextStyle(
                        fontSize: Adapt.px(22),
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogCustom(
                          bodyText: 'desea salirse?',
                          bottonAcept: ElevatedButton(
                            style: style,
                            child: Text(AppLocalizations.of(context)!.aceptar,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                          bottonCancel: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Adapt.px(20),
                                      vertical: Adapt.px(10)),
                                  primary:
                                      const Color.fromARGB(255, 254, 37, 37),
                                  textStyle: TextStyle(
                                      fontSize: Adapt.px(30),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              child: Text(
                                AppLocalizations.of(context)!.cancelar,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget documentTypeInput() {
    return DropdownButtonFormField(
      menuMaxHeight: 200,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(25), horizontal: Adapt.px(15)),
        enabledBorder: textFFStyleOK,
        disabledBorder: textFFStyleOK,
        focusedBorder: textFFStyleOK,
        errorBorder: textFFStyleWrong,
        focusedErrorBorder: textFFStyleWrong,
        label: Text(
          AppLocalizations.of(context)!.documento.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      icon: Icon(
        FontAwesomeIcons.arrowDown,
        color: ColorSelect.greyColor,
      ),
      items: listDocuments.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat-Regular')),
        );
      }).toList(),
      onChanged: (value) {
        switch (value) {
          case "Tarjeta de Identidad":
            documentType = "61d5c9fba8f37a8fe5f54188";

            break;
          case "Cédula de ciudadanía":
            documentType = "61d5ca04a8f37a8fe5f54189";

            break;
          case "Cédula de Extrangería":
            documentType = "61d5ca0aa8f37a8fe5f5418a";

            break;
          case "Pasaporte":
            documentType = "61d5cba6a8f37a8fe5f5418b";

            break;
          case "Registro Civil":
            documentType = "61e34b0faf69da10268d92fc";

            break;
          case "Id Extranjero":
            documentType = "61e34b52af69da10268d92fd";

            break;
          case "Carnet diplomático":
            documentType = "61e34be0af69da10268d92fe";

            break;
          default:
        }
        setState(() {});
        print(documentType);
      },
      validator: (value) => value == null ? "El campo es Obligatorio*" : null,
    );
  }

  Widget imputDocument() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFFStyleOK,
        disabledBorder: textFFStyleOK,
        focusedBorder: textFFStyleOK,
        errorBorder: textFFStyleWrong,
        focusedErrorBorder: textFFStyleWrong,
        label: Text(
          'Numero de documento'.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onChanged: (value) {
        document = value;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          return null;
        }
      },
    );
  }

  Widget imputPhone() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.text,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFFStyleOK,
        disabledBorder: textFFStyleOK,
        focusedBorder: textFFStyleOK,
        errorBorder: textFFStyleWrong,
        focusedErrorBorder: textFFStyleWrong,
        label: Text(
          AppLocalizations.of(context)!.telefono.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onChanged: (value) {
        phone = value;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          return null;
        }
      },
    );
  }

  Widget selectAlergy() {
    return SizedBox(
      height: Adapt.hp(7),
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(Adapt.px(10))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: ColorSelect.greyColor,
              ),
            ),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "$textBotton2",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => selectListAlergy(),
          );
        },
      ),
    );
  }

  Widget _checkRecordarCredenciales(BuildContext context) {
    return CheckboxListTile(
        value: _check,
        side: BorderSide(color: ColorSelect.primaryColorVaco, width: 1.5),
        activeColor: ColorSelect.primaryColorVaco,
        checkColor: ColorSelect.primaryColorVaco,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          AppLocalizations.of(context)!.aceptoTerminos,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: Adapt.px(20),
          ),
        ),
        onChanged: (valor) {
          _check = valor!;
          setState(() {});
        });
  }

  Widget bottonBack() {
    Image imageRegreso = Image.asset(
      'assets/botones/BotonRegresar.png',
      fit: BoxFit.cover,
    );
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: CircleAvatar(
          backgroundColor: Colors.white, backgroundImage: imageRegreso.image),
    );
  }

  Widget selectListAlergy() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.white,
      title: Center(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "SELECCIONE     ALGUNA ALERGIA",
            style: TextStyle(
              color: Colors.black,
              fontSize: Adapt.px(28),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          width: Adapt.wp(90),
          height: Adapt.hp(25),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: ColorSelect.greyColor,
                width: 2,
              ),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: FutureBuilder(
                future: alergyService.getAllergy(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.0,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 5.0,
                          mainAxisExtent: 20.0,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Adapt.hp(2.5),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor:
                                            ColorSelect.primaryColorVaco,
                                      ),
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                        return Checkbox(
                                          checkColor: Colors.black,
                                          focusColor: Colors.black,
                                          hoverColor: Colors.black,
                                          onChanged: (bool? value) {
                                            listAlerys[index] = value!;

                                            setState(() {});
                                          },
                                          value: listAlerys[index],
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(Adapt.px(2)),
                                    height: Adapt.hp(15),
                                    width: Adapt.wp(50),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        snapshot.data[index]["nombre"],
                                        style: TextStyle(
                                          fontSize: Adapt.px(30),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const LoadingIndicatorW();
                  }
                },
              )),
        ),
        Center(
          child: ElevatedButtonCustom(
              textButton: AppLocalizations.of(context)!.aceptar,
              onPressedAction: () {
                textBotton2 = 'ALERGIA SELECIONADA EXITOSAMENTE';
                setState(() {});
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  void _getAlergy() async {
    List listAlergy = await alergyService.getAllergy();

    for (var i = 0; i < listAlergy.length; i++) {
      allergyListByID.add(listAlergy[i]["id"].toString());
      listAlerys.add(false);
    }

    setState(() {});
  }

  void _facebookRegister() async {
    for (var i = 0; i < listAlerys.length; i++) {
      if (listAlerys[i] == true) {
        alergiaSelected.add(allergyListByID[i]);
      }
    }
    if (widget.gender == 'male') {
      genderSelect = "61d5c8efa8f37a8fe5f54184";
    } else if (widget.gender == 'female') {
      genderSelect = "61d5c8e9a8f37a8fe5f54183";
    } else {
      genderSelect = "61d5c8f3a8f37a8fe5f54185";
    }

    dynamic respuestaRegistro = await registerService.registerFacebook(
      widget.firstName,
      widget.lastName,
      widget.email,
      widget.id,
      documentType,
      document,
      genderSelect,
      phone,
      alergiaSelected,
    );

    if (respuestaRegistro is Map) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              bodyText: "Datos cargados Correctamente",
              bottonAcept: ElevatedButton(
                style: okButtonStyle,
                child: Text(AppLocalizations.of(context)!.iniciarSesion,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                onPressed: () async {
                  String tipoAcceso = "FACEBOOK";
                  dynamic respuestaLogin = await loginService.login(
                      widget.email, widget.id, tipoAcceso);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/mainScreen', (Route<dynamic> route) => false);

                  PromotionsProvider promocionesProvider =
                      Provider.of<PromotionsProvider>(context, listen: false);

                  promocionesProvider.cargarPromociones();

                  _tokenLogin = respuestaLogin['token'];
                  prefs.token = _tokenLogin;
                },
              ),
              bottonCancel: Container(),
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogCustom(
            bodyText: "Ha ocurrido algún error",
            bottonAcept: ElevatedButton(
              style: okButtonStyle,
              child: Text(AppLocalizations.of(context)!.aceptar,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
            bottonCancel: Container(),
          );
        },
      );
    }
  }
}
