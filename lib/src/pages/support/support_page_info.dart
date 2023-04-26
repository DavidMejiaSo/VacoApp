import 'package:flutter/material.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../responsive/Adapt.dart';
import '../../../service/frequent_questions_service.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';

// ignore: must_be_immutable
class SupportPageInfo extends StatefulWidget {
  SupportPageInfo({Key? key, required this.title, required this.categoria})
      : super(key: key);
  String title;
  String categoria;
  @override
  State<SupportPageInfo> createState() => _SupportPageState();
}

final preguntasFrecuentas = PreguntasFrecuentesService();

class _SupportPageState extends State<SupportPageInfo> {
  void traerListaDePreguntas() async {
    await preguntasFrecuentas.obtenerPreguntas();
    isReady = true;
    setState(() {});
  }

  bool isReady = false;
  @override
  void initState() {
    traerListaDePreguntas();
    super.initState();
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
            SingleChildScrollView(child: _body()),
          ],
        )),
      ),
    );
  }

  final lineaDivisoria = Container(
    height: Adapt.px(1.5),
    color: Colors.grey,
  );
  Widget _body() {
    try {
      return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                height: Adapt.hp(10),
                child: Center(
                  child: Text(
                    '${widget.title}',
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: Adapt.px(35), color: Colors.black),
                  ),
                )),
            isReady
                ? FutureBuilder(
                    future: preguntasFrecuentas.obtenerPreguntas(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Container(
                        width: Adapt.wp(95),
                        child: ListView.custom(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          childrenDelegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              try {
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
                                              '${snapshot.data[index]['titulo']}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Adapt.px(35),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'Montserrat-ExtraBold'),
                                            ),
                                            SizedBox(
                                              height: Adapt.hp(2),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                '${snapshot.data[index]['descripcion']}',
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
                              } catch (e) {
                                print(e);
                                return const LoadingIndicatorW();
                              }
                            },
                            childCount: snapshot.data.length,
                          ),
                        ),
                      );
                    },
                  )
                : const LoadingIndicatorW()
          ],
        ),
      );
    } catch (e) {
      return const LoadingIndicatorW();
    }
  }
}
