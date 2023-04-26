import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/register_service.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/allergy_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? keyy}) : super(key: keyy);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool _mostrarPassword = true,
    _mostrarPassword2 = true,
    ischecked = false,
    terminosCerrar = false;

List<bool> listAlerys = [];
bool _check = false;
int _validarPassword = 0, _validarPassword2 = 0, _validarEmail = 0;
List alergiaSelected = [];
String name = "",
    password = "",
    password2 = "",
    lastName = "",
    email = "",
    documentType = "",
    document = "",
    phone = "",
    genderSelect = "",
    bornDate = "",
    departamentID = "",
    municipalityID = "";
List listMunicipalityTotal = [],
    listDepartamentTotal = [],
    listAlergyTotal = [],
    idListaProductosFavoritos = [];
var textBotton = "aaaa-mm-dd",
    textBotton2,
    listDepartamentsName = [""],
    listMunicipalityName = [""],
    listAlergyName,
    _gender = ["Masculino", "Femenino", "Otro"],
    listDocuments = [
      "Tarjeta de Identidad",
      "Cédula de ciudadanía",
      "Cédula de Extrangería",
      "Pasaporte",
      "Registro Civil",
      "Id Extranjero",
      "Carnet diplomático"
    ];

class _RegisterPageState extends State<RegisterPage> {
  final prefs = PreferenciasUsuario();
  final formKey22 = GlobalKey<FormState>();
  final registerService = RegisterService();
  final alergyService = getListAllergyUserService();
  final textFormFieldStyle = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorSelect.greyColor,
    ),
    borderRadius: BorderRadius.circular(30.0),
  );
  final textFormFieldStyleWrong = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
    borderRadius: BorderRadius.circular(30.0),
  );
  var spaceBetween = SizedBox(height: Adapt.hp(1));
  var spaceBetweenWidth = SizedBox(width: Adapt.wp(2));
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(20), vertical: Adapt.px(10)),
      primary: ColorSelect.primaryColorVaco,
      textStyle: TextStyle(
          fontSize: Adapt.px(30),
          fontWeight: FontWeight.bold,
          color: Colors.black));
  final ButtonStyle style2 = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(20), vertical: Adapt.px(10)),
      primary: const Color.fromARGB(255, 254, 37, 37),
      textStyle: TextStyle(
          fontSize: Adapt.px(30),
          fontWeight: FontWeight.bold,
          color: Colors.black));
  @override
  void initState() {
    getAlergy();
    super.initState();
    listAlergyName = [];
    textBotton = "INGRESE LA FECHA DE NACIMIENTO";
    name = "";
    password = "";
    password2 = "";
    lastName = "";
    email = "";
    documentType = "";
    document = "";
    phone = "";
    genderSelect = "";
    bornDate = "";

    textBotton2 = "SELECIONE ALGUNA ALERGIA";
    alergiaSelected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _body(context, style, spaceBetween, spaceBetweenWidth, style2),
            terminosCerrar ? terminosYCondiciones() : Container(),
          ],
        ),
      ),
    );
  }

  Widget cerrarTerminosYCondiciones() {
    Image imageCerrar = Image.asset(
      'assets/botones/BotonCerrar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Transform.scale(
        scale: Adapt.px(1.45),
        child: GestureDetector(
          onTap: () {
            terminosCerrar = false;
            setState(() {});
          },
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: imageCerrar.image),
        ),
      ),
    );
  }

  Widget _body(context, style, spaceBetween, spaceBetweenWidth, style2) {
    return Stack(
      children: [
        BackgroundShop(),
        Container(
          child: Column(
            children: [
              SizedBox(height: Adapt.hp(4)),
              _bodyOne(context, style, spaceBetween, spaceBetweenWidth, style2),
              Flexible(
                flex: 8,
                child: _bodyTwo(context, style, spaceBetweenWidth, style2,
                    textFormFieldStyle, textFormFieldStyleWrong),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bodyOne(context, style, spaceBetween, spaceBetweenWidth, style2) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(20)),
            child: bottonBack(),
          ),
          SizedBox(
            height: Adapt.hp(15),
            child: Column(
              children: [
                Container(
                  width: Adapt.wp(50),
                  child: Image(
                    height: Adapt.hp(10),
                    image: const AssetImage('assets/logos/LogoVaco.png'),
                  ),
                ),
                Container(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLocalizations.of(context)!.registrate,
                      style: TextStyle(
                          fontSize: Adapt.px(40),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Adapt.wp(19),
          )
        ],
      ),
    );
  }

  Widget imputName(maxLength, textoLabel, icono, keyboardType,
      textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          textoLabel.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) {
        name = value;
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

  Widget terminosYCondiciones() {
    //Ruta del PDF de terminos y condiciones
    return Container(
      width: Adapt.wp(100),
      height: Adapt.hp(100),
      child: Stack(
        children: [
          WebViewPlus(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                controller
                    .loadUrl("https://vacofood.com/user/politicasPrivacidad");
              }),
          Align(
            alignment: Alignment.topRight,
            child: cerrarTerminosYCondiciones(),
          )
        ],
      ),
    );
  }

  Widget imputLastname(maxLength, textoLabel, icono, keyboardType,
      textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          textoLabel.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) {
        lastName = value;
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

  Widget imputDocument(maxLength, textoLabel, icono, keyboardType,
      textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          textoLabel,
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
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

  Widget imputPhone(maxLength, textoLabel, icono, keyboardType,
      textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          textoLabel.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
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

  Widget _bodyTwo(context, style, spaceBetweenWidth, style2, textFormFieldStyle,
      textFormFieldStyleWrong) {
    var spaceBetween = SizedBox(height: Adapt.hp(2.5));
    return Container(
      height: Adapt.hp(100),
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(5.0),
      child: Form(
        key: formKey22,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              imputName(
                  40,
                  AppLocalizations.of(context)!.nombreUsuario,
                  FontAwesomeIcons.user,
                  TextInputType.text,
                  textFormFieldStyle,
                  textFormFieldStyleWrong),
              spaceBetween,
              imputLastname(
                  40,
                  AppLocalizations.of(context)!.apellidoUsuario,
                  FontAwesomeIcons.user,
                  TextInputType.text,
                  textFormFieldStyle,
                  textFormFieldStyleWrong),
              spaceBetween,
              emailInput(context, textFormFieldStyle, textFormFieldStyleWrong),
              spaceBetween,
              passwordInput(
                  context, textFormFieldStyle, textFormFieldStyleWrong),
              spaceBetween,
              confirmpasswordInput(
                  context, textFormFieldStyle, textFormFieldStyleWrong),
              spaceBetween,
              documentTypeInput(
                  context, textFormFieldStyle, textFormFieldStyleWrong),
              SizedBox(height: Adapt.hp(2.5)),
              imputDocument(
                  11,
                  'Numero de documento'.toUpperCase(),
                  FontAwesomeIcons.user,
                  TextInputType.phone,
                  textFormFieldStyle,
                  textFormFieldStyleWrong),
              spaceBetween,
              genderInput(context, textFormFieldStyle, textFormFieldStyleWrong),
              SizedBox(height: Adapt.hp(2.5)),
              imputPhone(
                  10,
                  AppLocalizations.of(context)!.telefono,
                  FontAwesomeIcons.phone,
                  TextInputType.text,
                  textFormFieldStyle,
                  textFormFieldStyleWrong),
              spaceBetween,
              selectAlergy(context),
              spaceBetween,
              _bodyThree(
                  context, style, spaceBetween, spaceBetweenWidth, style2),
              spaceBetween,
            ],
          ),
        ),
      ),
    );
  }

  Widget selectAlergy(context) {
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
            "$textBotton2".toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
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
        title: GestureDetector(
          child: Text(
            AppLocalizations.of(context)!.aceptoTerminos,
            style: TextStyle(
              color: Colors.black,
              fontSize: Adapt.px(20),
            ),
          ),
          onTap: () {
            terminosCerrar = true;
            setState(() {});
          },
        ),
        onChanged: (valor) {
          _check = valor!;
          setState(() {});
        });
  }

  Widget _bodyThree(context, style, spaceBetween, spaceBetweenWidth, style2) {
    return Column(
      children: [
        _checkRecordarCredenciales(context),
        Wrap(
          children: [
            SizedBox(
              width: Adapt.wp(35),
              child: ElevatedButton(
                style: style,
                child: Text(AppLocalizations.of(context)!.registrate,
                    style: TextStyle(
                        fontSize: Adapt.px(22),
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                onPressed: () {
                  if (formKey22.currentState!.validate()) {
                    if (_check) {
                      setState(() {});
                      _ingresar();
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
                style: style2,
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
                              style: style2,
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

  Widget emailInput(context, textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      maxLength: 50,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
          vertical: Adapt.px(30),
          horizontal: Adapt.px(15),
        ),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          "Email".toUpperCase(),
          style: TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) {
        email = value;
        _validarEmail = email.indexOf('@');
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          if (_validarEmail < 0) {
            return 'El ingresado correo no es un correo valido*';
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget passwordInput(context, textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: 14,
      style: const TextStyle(color: Colors.black),
      obscureText: _mostrarPassword == true ? true : false,
      decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
              vertical: Adapt.px(30), horizontal: Adapt.px(15)),
          enabledBorder: textFormFieldStyle,
          disabledBorder: textFormFieldStyle,
          focusedBorder: textFormFieldStyle,
          errorBorder: textFormFieldStyleWrong,
          focusedErrorBorder: textFormFieldStyleWrong,
          label: Text(
            AppLocalizations.of(context)!.clave.toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: InkWell(
            onTap: () {
              _mostrarPassword = !_mostrarPassword;
              setState(() {});
            },
            child: Icon(
              _mostrarPassword == true ? Icons.lock : Icons.lock_open,
              color: ColorSelect.greyColor,
            ),
          )),
      onChanged: (value) {
        password = value;
        _validarPassword = password.length;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          if (_validarPassword < 8) {
            return 'La clave debe tener al menos 8 caracteres';
          } else {
            if (password != password2) {
              return "Las contraseñas no coinciden";
            } else {
              return null;
            }
          }
        }
      },
    );
  }

  Widget confirmpasswordInput(
      context, textFormFieldStyle, textFormFieldStyleWrong) {
    return TextFormField(
      maxLength: 14,
      style: const TextStyle(color: Colors.black),
      obscureText: _mostrarPassword2 == true ? true : false,
      decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
              vertical: Adapt.px(30), horizontal: Adapt.px(15)),
          enabledBorder: textFormFieldStyle,
          disabledBorder: textFormFieldStyle,
          focusedBorder: textFormFieldStyle,
          errorBorder: textFormFieldStyleWrong,
          focusedErrorBorder: textFormFieldStyleWrong,
          label: Text(
            AppLocalizations.of(context)!.confirmarClave.toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: InkWell(
            onTap: () {
              _mostrarPassword2 = !_mostrarPassword2;
              setState(() {});
            },
            child: Icon(
              _mostrarPassword2 == true ? Icons.lock : Icons.lock_open,
              color: ColorSelect.greyColor,
            ),
          )),
      onChanged: (value) {
        password2 = value;
        _validarPassword2 = password2.length;

        print(password2);
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          if (_validarPassword2 < 8) {
            return 'La clave debe tener al menos 8 caracteres';
          } else {
            if (password != password2) {
              return "Las contraseñas no coinciden";
            } else {
              return null;
            }
          }
        }
      },
    );
  }

  Widget documentTypeInput(
      context, textFormFieldStyle, textFormFieldStyleWrong) {
    return DropdownButtonFormField(
      menuMaxHeight: 200,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(25), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          AppLocalizations.of(context)!.documento.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
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
                  color: Colors.black, fontFamily: 'Montserrat-ExtraBold')),
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

  Widget genderInput(context, textFormFieldStyle, textFormFieldStyleWrong) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        errorBorder: textFormFieldStyleWrong,
        focusedErrorBorder: textFormFieldStyleWrong,
        label: Text(
          "GENERO".toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      icon: Icon(
        FontAwesomeIcons.arrowDown,
        color: ColorSelect.greyColor,
      ),
      items: _gender.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value,
              style: const TextStyle(
                  color: Colors.black, fontFamily: 'Montserrat-ExtraBold')),
        );
      }).toList(),
      onChanged: (value) {
        switch (value) {
          case "Masculino":
            genderSelect = "61d5c8efa8f37a8fe5f54184";

            break;
          case "Femenino":
            genderSelect = "61d5c8e9a8f37a8fe5f54183";

            break;
          case "Otro":
            genderSelect = "61d5c8f3a8f37a8fe5f54185";

            break;

          default:
        }
        setState(() {});
      },
      validator: (value) => value == null ? "El campo es Obligatorio*" : null,
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
          height: Adapt.hp(4),
          alignment: Alignment.center,
          child: Text(
            "SELECCIONE ALGUNA ALERGIA",
            style: TextStyle(
                color: Colors.black,
                fontSize: Adapt.px(20),
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat-ExtraBold'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          width: Adapt.wp(90),
          height: Adapt.hp(24),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Color.fromARGB(255, 176, 176, 176),
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
                                          checkColor:
                                              ColorSelect.primaryColorVaco,
                                          activeColor:
                                              ColorSelect.primaryColorVaco,
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

  void getAlergy() async {
    listAlergyTotal = [];
    List listAlergy = await alergyService.getAllergy();
    listAlergyTotal = listAlergy;
    for (var i = 0; i < listAlergy.length; i++) {
      listAlergyName.add(listAlergy[i]["nombre"].toString());
      listAlerys.add(false);
    }

    setState(() {});
  }

  void _ingresar() async {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

    setState(() {});
    for (var i = 0; i < listAlerys.length; i++) {
      if (listAlerys[i] == true) {
        alergiaSelected.add(listAlergyTotal[i]["id"]);
      }
    }
    dynamic respuesta = await registerService.register(
        name,
        lastName,
        email,
        password,
        documentType,
        document,
        bornDate,
        genderSelect,
        phone,
        departamentID,
        municipalityID,
        idListaProductosFavoritos,
        alergiaSelected);

    if (respuesta is Map) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              bodyText:
                  "Registro exitoso,Revisa tu correo para activar tu cuenta",
              bottonAcept: ElevatedButton(
                style: style,
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
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogCustom(
            bodyText: "Lo sentimos, este correo ya ha sido registrado",
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        },
      );
    }
  }

  Widget _botonVerTerminosYCondiciones() {
    return SizedBox(
      height: Adapt.hp(10),
      width: Adapt.wp(50),
      child: ElevatedButton(
        style: style,
        child: Text("Ver Terminos y Condicionees",
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat-ExtraBold',
                color: Colors.black)),
        onPressed: () => {terminosCerrar = true, setState(() {})},
      ),
    );
  }
}
