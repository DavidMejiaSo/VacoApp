import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/backgroundShop.dart';
import '../../../preferences/preferences_user.dart';
import '../../../responsive/Color.dart';
import '../../../service/allergy_service.dart';
import '../../../service/change_data_user_service.dart';
import '../../../service/register_service.dart';
import '../../../service/user_information_service.dart';
import '../../widgets/elevated_botton_cancel.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final registerService = RegisterService();
final alergyService = getListAllergyUserService();
final changeInfoUser = ChangeUserInfoService();
final traerAlergias = getListAllergyUserService();
bool _editProfile = false;
String municipalityID = "",
    departamentID = "",
    departamentNumber = "",
    nameEdited = "",
    lastNameEdited = "",
    cellphoneEdited = "",
    departamentEdited = "",
    municipalyEdited = "",
    municipalityNumber = "",
    actuallyDepartentSelectedUser = "",
    actuallyMunicipalySelectedUser = "";
List listMunicipalityTotal = [],
    listDepartamentTotal = [],
    alergiasNombre = [],
    userAlergy = [];
List<bool> ischecked = [];
Map infoUserData = {};
var listDepartamentsName = [""],
    listMunicipalityName = [""],
    textBotton2 = "EDITAR ALERGIAS";

class _ProfilePageState extends State<ProfilePage> {
  final prefs = PreferenciasUsuario();
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      primary: ColorSelect.primaryColorVaco,
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  final ButtonStyle style2 = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: EdgeInsets.all(0),
      primary: const Color.fromARGB(255, 255, 0, 0),
      textStyle: TextStyle(
          fontSize: Adapt.px(30),
          fontWeight: FontWeight.bold,
          color: Colors.white));
  @override
  void initState() {
    super.initState();
    _editProfile = false;
    nameEdited = '';
    lastNameEdited = '';
    cellphoneEdited = '';
    departamentEdited = '';
    municipalyEdited = '';
    textBotton2 = "EDITAR ALERGIAS";
    infoUserData = {};
    _getUserData();
    ischecked = [];
    getAleryUser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "false",
            textoLabel: AppLocalizations.of(context)!.misPedidosYServicios,
            anotherButton: botonEditInfo(),
            bottonBackAction: () {
              setState(() {});
              if (_editProfile != false) {
                alertGetBack(style, style2);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const BackgroundShop(),
            infoUserData.isEmpty
                ? const LoadingIndicatorW()
                : SingleChildScrollView(child: _body(style2)),
          ],
        ),
      ),
    );
  }

  Widget botonEditInfo() {
    return SizedBox(
      width: Adapt.wp(18),
      child: Padding(
        padding: EdgeInsets.only(right: Adapt.px(10)),
        child: FloatingActionButton(
            elevation: 1,
            heroTag: "btn2",
            backgroundColor: Colors.white,
            onPressed: () {
              _editProfile = true;
              setState(() {});
            },
            child: Icon(Icons.edit,
                size: Adapt.px(35), color: ColorSelect.primaryColorVaco)),
      ),
    );
  }

  Widget _body(style2) {
    final style = BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: ColorSelect.greyColor, width: 1),
    );
    final spaceBetween = SizedBox(
      height: Adapt.hp(2),
    );

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: Adapt.hp(10),
          ),
          const CircleAvatar(
            child: Image(
              height: 62,
              image: AssetImage('assets/logos/icono.png'),
            ),
            radius: 50,
            backgroundColor: Colors.white,
          ),
          spaceBetween,
          SizedBox(
              height: Adapt.hp(60),
              width: Adapt.wp(90),
              child: _editProfile == false
                  ? _showInfoUserTotal(style, spaceBetween)
                  : _editInfoUserTotal(style, spaceBetween)),
          spaceBetween,
          Align(
            alignment: Alignment.bottomCenter,
            child: _editProfile == true ? _botonConfirmChanges() : Container(),
          )
        ],
      ),
    );
  }

  Widget _showInfoUserTotal(style, spaceBetween) {
    final textFormFieldStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorSelect.greyColor,
      ),
      borderRadius: BorderRadius.circular(30),
    );
    return Container(
      width: Adapt.screenW(),
      child: Column(
        children: [
          _textFieldReply(AppLocalizations.of(context)!.nombreUsuario,
              textFormFieldStyle, infoUserData["nombre"]),
          spaceBetween,
          _textFieldReply(AppLocalizations.of(context)!.apellidoUsuario,
              textFormFieldStyle, infoUserData["apellido"]),
          spaceBetween,
          _textFieldReply(AppLocalizations.of(context)!.correo,
              textFormFieldStyle, infoUserData["username"]),
          spaceBetween,
          _textFieldReply(AppLocalizations.of(context)!.documento,
              textFormFieldStyle, infoUserData["documento"]),
          spaceBetween,
          _textFieldReply(AppLocalizations.of(context)!.telefono,
              textFormFieldStyle, infoUserData["celular"]),
          spaceBetween,
          infoUserData['idAlergias'].length > 0
              ? _showInfoUserAlergy(style)
              : _showInfoUserNotAlergy(textFormFieldStyle, style)
        ],
      ),
    );
  }

  Widget _textFieldReply(labelText, textFormFieldStyle, initialValue) {
    return TextFormField(
      style: TextStyle(
        fontSize: Adapt.px(20),
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        label: Text(
          labelText.toUpperCase(),
          style: TextStyle(
            fontSize: Adapt.px(20),
            color: Colors.black,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: null,
      readOnly: true,
      initialValue: initialValue,
    );
  }

  Widget _showInfoUserAlergy(style) {
    return Container(
        margin: const EdgeInsets.only(top: 0),
        alignment: Alignment.topCenter,
        height: Adapt.hp(10),
        width: Adapt.wp(95),
        decoration: style,
        child: SingleChildScrollView(
            child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(ischecked.length, (index) {
            return ischecked[index]
                ? Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        alergiasNombre[index]["nombre"],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
        ))));
  }

  Widget _showInfoUserNotAlergy(textFormFieldStyle, style) {
    return TextFormField(
      style: TextStyle(
        fontSize: Adapt.px(20),
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: textFormFieldStyle,
        disabledBorder: textFormFieldStyle,
        focusedBorder: textFormFieldStyle,
        label: Text(
          AppLocalizations.of(context)!.alergias,
          style: TextStyle(
            fontSize: Adapt.px(20),
            color: Colors.black,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: null,
      readOnly: true,
      initialValue: AppLocalizations.of(context)!.noTienesAlergias,
    );
  }

  Widget _editInfoUserTotal(style, spaceBetween) {
    final textFormFieldStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorSelect.greyColor,
      ),
      borderRadius: BorderRadius.circular(30),
    );
    return Container(
        child: Column(children: [
      _editInfoUserName(AppLocalizations.of(context)!.nombreUsuario, style,
          textFormFieldStyle),
      spaceBetween,
      _editInfoUserLastName(AppLocalizations.of(context)!.apellidoUsuario,
          style, textFormFieldStyle),
      spaceBetween,
      _textFieldReply(AppLocalizations.of(context)!.correo, textFormFieldStyle,
          infoUserData["username"]),
      spaceBetween,
      _textFieldReply(AppLocalizations.of(context)!.documento,
          textFormFieldStyle, infoUserData["documento"]),
      spaceBetween,
      _editInfoUserPhone(
          AppLocalizations.of(context)!.telefono, style, textFormFieldStyle),
      spaceBetween,
      _selectAlergy(context, style),
    ]));
  }

  Widget _editInfoUserName(labelText, style, styleTextFromField) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: styleTextFromField,
        disabledBorder: styleTextFromField,
        focusedBorder: styleTextFromField,
        label: Text(labelText.toUpperCase(),
            style: TextStyle(fontSize: Adapt.px(20), color: Colors.black)),
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(
          Icons.edit,
          size: Adapt.wp(6.5),
          color: ColorSelect.primaryColorVaco,
        ),
      ),
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: Adapt.px(20),
        color: Colors.black,
      ),
      maxLines: 1,
      initialValue: infoUserData["nombre"],
      onChanged: (valor) {
        if (valor != infoUserData["nombre"]) {
          nameEdited = valor;
        }
      },
    );
  }

  Widget _editInfoUserLastName(labelText, style, styleTextFromField) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: styleTextFromField,
        disabledBorder: styleTextFromField,
        focusedBorder: styleTextFromField,
        label: Text(labelText.toUpperCase(),
            style: TextStyle(fontSize: Adapt.px(20), color: Colors.black)),
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(
          Icons.edit,
          size: Adapt.wp(6.5),
          color: ColorSelect.primaryColorVaco,
        ),
      ),
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: Adapt.px(20),
        color: Colors.black,
      ),
      maxLines: 1,
      initialValue: infoUserData["apellido"],
      onChanged: (valor) {
        if (valor != infoUserData["apellido"]) {
          lastNameEdited = valor;
        }
      },
    );
  }

  Widget _editInfoUserPhone(labelText, style, styleTextFromField) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: Adapt.px(30), horizontal: Adapt.px(15)),
        enabledBorder: styleTextFromField,
        disabledBorder: styleTextFromField,
        focusedBorder: styleTextFromField,
        label: Text(labelText.toUpperCase(),
            style: TextStyle(fontSize: Adapt.px(20), color: Colors.black)),
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(
          Icons.edit,
          size: Adapt.wp(6.5),
          color: ColorSelect.primaryColorVaco,
        ),
      ),
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: Adapt.px(20),
        color: Colors.black,
      ),
      maxLines: 1,
      initialValue: infoUserData["celular"],
      onChanged: (valor) {
        if (valor != infoUserData["celular"]) {
          cellphoneEdited = valor;
        }
      },
    );
  }

  Widget _selectAlergy(context, style) {
    return Container(
      height: Adapt.hp(7.5),
      width: Adapt.wp(95),
      child: TextButton(
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side:
                        BorderSide(color: ColorSelect.greyColor, width: 1.0)))),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            textBotton2,
            style: TextStyle(
              fontSize: Adapt.px(20),
              color: Colors.black,
            ),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _selectListAlergy(style),
          );
        },
      ),
    );
  }

  Widget _selectListAlergy(style) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: ColorSelect.primaryColorVaco, width: 2.0)),
      backgroundColor: Colors.white,
      title: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppLocalizations.of(context)!.selecioneAlgunaAlergia,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
      actions: [
        Center(
          child: Container(
            width: Adapt.wp(95),
            height: Adapt.hp(30),
            decoration: style,
            child: Padding(
                padding: EdgeInsets.all(Adapt.px(10)),
                child: FutureBuilder(
                  future: alergyService.getAllergy(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.0,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: 22.0,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: Adapt.hp(30),
                                    width: Adapt.wp(10),
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
                                            if (ischecked[index] == false) {
                                              addAlergy(
                                                  "${userAlergy[index]["id"]}");

                                              ischecked[index] = value!;
                                            } else {
                                              deleteAlergy(
                                                  "${userAlergy[index]["id"]}");

                                              ischecked[index] = value!;
                                            }
                                            setState(() {});
                                          },
                                          value: ischecked[index],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
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
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const LoadingIndicatorW();
                    }
                  },
                )),
          ),
        ),
        SizedBox(
          height: Adapt.hp(1),
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                primary: ColorSelect.primaryColorVaco,
                textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            child: Text(AppLocalizations.of(context)!.aceptar,
                style: const TextStyle(color: Colors.black)),
            onPressed: () {
              textBotton2 =
                  AppLocalizations.of(context)!.algunaSeleccionadaExitosamente;
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _botonConfirmChanges() {
    final spaceBetween = SizedBox(height: Adapt.wp(20));
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: Adapt.wp(90),
        height: Adapt.hp(6),
        child: ElevatedButton(
          style: style,
          onPressed: () {
            textBotton2 = AppLocalizations.of(context)!.editarAlergia;

            if (nameEdited == '' &&
                lastNameEdited == '' &&
                cellphoneEdited == '' &&
                departamentEdited == '') {
              _editProfile = false;
              setState(() {});
            } else {
              guardarCambios(spaceBetween, style);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(AppLocalizations.of(context)!.confirmarCambios,
                style: TextStyle(
                    fontSize: Adapt.px(30),
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ),
      ),
    );
  }

  void changeInfo(campo, valor) async {
    dynamic respuesta = await changeInfoUser.changeInfo(campo, valor);
    setState(() {});
    print(respuesta);
  }

  void getAleryUser() async {
    dynamic alergyUser = await alergyService.getAllergy();
    alergiasNombre = alergyUser;
  }

  void getUserAlergy() async {
    userAlergy = [];

    dynamic respuesta = await alergyService.getAllergy();
    userAlergy = respuesta;

    for (var i = 0; i < respuesta.length; i++) {
      ischecked.add(false);
    }

    for (var i = 0; i < userAlergy.length; i++) {
      for (var j = 0; j < infoUserData["idAlergias"].length; j++) {
        if (infoUserData["idAlergias"][j] == userAlergy[i]["id"]) {
          ischecked[i] = (true);
          break;
        }
      }
    }
    setState(() {});
  }

  void _getUserData() async {
    final getDataUser = GetUserInfoService();
    dynamic respuesta = await getDataUser.getInfo();

    infoUserData = respuesta;
    getUserAlergy();
    setState(() {});
  }

  void addAlergy(alergia) async {
    try {
      await traerAlergias.addAllergy(alergia);
      print("agregando");
    } catch (e) {
      print(e);
    }

    infoUserData["idAlergias"].add(alergia);
  }

  void deleteAlergy(alergia) async {
    try {
      await traerAlergias.deleteAllergy(alergia);
      print("eliminando");
    } catch (e) {
      print(e);
    }
    infoUserData["idAlergias"].remove(alergia);
  }

  void alertGetBack(style, style2) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogCustom(
              bodyText: AppLocalizations.of(context)!.descartarCamios,
              bottonAcept: ElevatedButton(
                style: style,
                child: Text(AppLocalizations.of(context)!.aceptar,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              bottonCancel: ElevatedButtonCancelCustom());
        });
  }

  void confirmarCambios(style) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogCustom(
            bodyText: AppLocalizations.of(context)!.cambiosGuardados,
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        });
  }

  void guardarCambios(spaceBetween, style) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogCustom(
            bodyText: AppLocalizations.of(context)!.preguntaGuardarCambios,
            bottonAcept: ElevatedButton(
              style: style,
              child: Text(AppLocalizations.of(context)!.aceptar,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              onPressed: () {
                _editProfile = false;

                if (nameEdited != infoUserData["nombre"] && nameEdited != '') {
                  infoUserData["nombre"] = nameEdited;
                  changeInfo("nombre", nameEdited);
                }
                if (lastNameEdited != infoUserData["apellido"] &&
                    lastNameEdited != '') {
                  infoUserData["apellido"] = lastNameEdited;
                  changeInfo("apellido", lastNameEdited);
                }
                if (cellphoneEdited != infoUserData["celular"] &&
                    cellphoneEdited != '') {
                  infoUserData["celular"] = cellphoneEdited;
                  changeInfo("celular", cellphoneEdited);
                }

                Navigator.pop(context);
                textBotton2 = AppLocalizations.of(context)!.editarAlergia;
                confirmarCambios(style);
                setState(() {});
              },
            ),
            bottonCancel: ElevatedButtonCancelCustom(),
          );
        });
  }
}
