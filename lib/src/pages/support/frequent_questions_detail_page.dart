import 'package:flutter/material.dart';

import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../responsive/Adapt.dart';

import '../../../service/frequent_questions_service.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';

// ignore: must_be_immutable
class FrequentQuestionsDetailPage extends StatefulWidget {
  FrequentQuestionsDetailPage(
      {Key? key, required this.title, required this.categoria})
      : super(key: key);
  String title;
  String categoria;
  @override
  State<FrequentQuestionsDetailPage> createState() => _SupportPageState();
}

final preguntasFrecuentas = PreguntasFrecuentesService();

class _SupportPageState extends State<FrequentQuestionsDetailPage> {
  final lineaDivisoria = Container(
    height: Adapt.px(1.5),
    color: Colors.grey,
  );
  @override
  void initState() {
    super.initState();
    listaPreguntas = [];
    preguntasListas = false;
    traerPreguntas();
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
            textoLabel: 'centro de ayuda',
            anotherButton: Container(),
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

  List<dynamic> listaPreguntas = [];
  bool preguntasListas = false;
  void traerPreguntas() async {
    final preguntas = await preguntasFrecuentas
        .obtenerCategoriasPreguntasPorID(widget.categoria);

    listaPreguntas = preguntas;
    preguntasListas = true;
    setState(() {});
  }

  Widget _body() {
    try {
      return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                height: Adapt.hp(7),
                child: Center(
                  child: Text(
                    '${widget.title}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: Adapt.px(35),
                        fontFamily: 'Montserrat-ExtraBold',
                        color: Colors.black),
                  ),
                )),
            preguntasListas
                ? listaPreguntas.isNotEmpty
                    ? Container(
                        width: Adapt.wp(95),
                        height: Adapt.hp(74),
                        child: ListView.custom(
                          shrinkWrap: false,
                          padding: EdgeInsets.zero,
                          childrenDelegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: Adapt.hp(23),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${listaPreguntas[index]['enunciado']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Adapt.px(30),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily:
                                                    'Montserrat-ExtraBold'),
                                          ),
                                          SizedBox(
                                            height: Adapt.hp(2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '${listaPreguntas[index]['respuesta']}',
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'Montserrat-ExtraBold'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: listaPreguntas.length,
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          height: Adapt.hp(70),
                          child: Text(
                            'No hay preguntas en esta categoría',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Adapt.px(30),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                : LoadingIndicatorW(),
          ],
        ),
      );
    } catch (e) {
      return const LoadingIndicatorW();
    }
  }
}
