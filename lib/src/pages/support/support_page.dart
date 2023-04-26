import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/frequent_questions_service.dart';
import '../../../service/support_help_service.dart';
import '../../widgets/appBar.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final peticionesService = SupportService();
  final categoriasPreguntas = PreguntasFrecuentesService();

  String asunto = "";
  String descripcion = "";

  final lineaDivisoria = Container(
    height: Adapt.px(1.5),
    color: Colors.grey,
  );
  final textFormFieldStyle = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorSelect.greyColor,
    ),
    borderRadius: BorderRadius.circular(10.0),
  );
  final textFormFieldStyleWrong = OutlineInputBorder(
    borderSide: BorderSide(color: ColorSelect.greyColor),
    borderRadius: BorderRadius.circular(10.0),
  );
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "",
            textoLabel: 'Necesitas ayuda?',
            anotherButton: Container(
              width: Adapt.wp(12),
            ),
            bottonBackAction: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            const BackgroundShop(),
            _body(),
          ],
        )),
      ),
    );
  }

  Widget _body() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.topCenter,
              height: Adapt.hp(10),
              child: Center(
                child: Text(
                  'Tienes alguna pregunta?',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: Adapt.px(35), color: Colors.black),
                ),
              )),
          SizedBox(height: Adapt.hp(4)),
          imputAsk()
        ],
      ),
    );
  }

  final formKey = GlobalKey<FormState>();
  Widget imputAsk() {
    return Container(
      height: Adapt.hp(68),
      width: Adapt.wp(90),
      alignment: Alignment.centerLeft,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            asuntoTextf(),
            SizedBox(height: Adapt.hp(2)),
            comentaryBox(),
            SizedBox(height: Adapt.hp(4)),
            botonEnviar(context)
          ],
        ),
      ),
    );
  }

  Widget asuntoTextf() {
    return TextFormField(
      maxLength: 35,
      keyboardType: TextInputType.text,
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
          'asunto'.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      onChanged: (value) {
        asunto = value;
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

  bool _validate = false;
  final _text = TextEditingController();
  Widget comentaryBox() {
    return Padding(
        padding: EdgeInsets.all(Adapt.px(5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorSelect.greyColor, width: 1),
          ),
          height: Adapt.hp(15),
          child: Center(
            child: TextField(
              controller: _text,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: Adapt.px(30), color: Colors.black),
              maxLines: 3,
              decoration: InputDecoration(
                errorText: _validate ? 'El campo es obligatorio *' : null,
                contentPadding: EdgeInsets.all(Adapt.px(5)),
                border: InputBorder.none,
                hintText: "Escribe tu comentario",
                hintStyle: TextStyle(
                  fontSize: Adapt.px(30),
                  color: ColorSelect.greyColor,
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  descripcion = value;
                });
              },
            ),
          ),
        ));
  }

  Widget botonEnviar(context) {
    return Container(
      width: Adapt.wp(40),
      height: Adapt.hp(5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              primary: ColorSelect.primaryColorVaco,
              textStyle: TextStyle(
                  fontSize: Adapt.px(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          child: Text(AppLocalizations.of(context)!.enviar.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          onPressed: () async {
            setState(() {});
            _text.text.isEmpty ? _validate = true : _validate = false;
            if (formKey.currentState!.validate() && _validate == false) {
              final FocusScopeNode focus = FocusScope.of(context);
              if (!focus.hasPrimaryFocus && focus.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              dynamic respuesta =
                  await peticionesService.enviarPeticion(asunto, descripcion);
              print(respuesta);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 20,
                      backgroundColor: Colors.white,
                      title: Center(
                          child: Text(
                        AppLocalizations.of(context)!.saludo,
                        style: TextStyle(
                            fontSize: 36, color: ColorSelect.primaryColorVaco),
                      )),
                      content: SizedBox(
                        height: Adapt.hp(6),
                        child: Center(
                          child: Text(
                            'Pregunta enviada correctamente',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                            maxLines: 15,
                          ),
                        ),
                      ),
                      actions: [
                        Center(
                          child: SizedBox(
                              height: Adapt.hp(6),
                              width: Adapt.wp(50),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 15),
                                      primary: ColorSelect.primaryColorVaco,
                                      textStyle: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  child: Text(
                                    AppLocalizations.of(context)!.aceptar,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  })),
                        ),
                        SizedBox(
                          height: Adapt.hp(1),
                        )
                      ],
                    );
                  });
            } else {
              print('false');
            }
          }),
    );
  }
}
