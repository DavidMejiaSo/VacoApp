import 'package:flutter/material.dart';

import 'package:prueba_vaco_app/src/pages/support/frequent_questions_detail_page.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../responsive/Adapt.dart';
import '../../../service/frequent_questions_service.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';

class FrequentQuestionsPage extends StatefulWidget {
  const FrequentQuestionsPage({Key? key}) : super(key: key);

  @override
  State<FrequentQuestionsPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<FrequentQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "false",
            textoLabel: 'centro de ayuda',
            anotherButton: Container(),
            bottonBackAction: () {},
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            const BackgroundShop(),
            _body(),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      elevation: 2,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pushNamed(context, '/supportPage');
                      },
                      child: Image.asset('assets/support/supportIcon.png')),
                )),
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
                  '¿Tienes alguna pregunta?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: Adapt.px(35),
                      fontFamily: 'Montserrat-ExtraBold',
                      color: Colors.black),
                ),
              )),
          lineaDivisoria,
          askQuestion()
        ],
      ),
    );
  }

  final categoriasPreguntas = PreguntasFrecuentesService();
  Widget askQuestion() {
    return Container(
      alignment: Alignment.centerLeft,
      child: FutureBuilder(
        future: categoriasPreguntas.obtenerCategoriasPreguntas(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                child: ListView.custom(
                  shrinkWrap: true,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: Adapt.wp(5),
                                ),
                                Container(
                                  width: Adapt.wp(80),
                                  alignment: Alignment.centerLeft,
                                  height: Adapt.hp(9),
                                  child: Padding(
                                      padding: EdgeInsets.all(
                                        Adapt.px(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              snapshot.data[index]['nombre'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Adapt.px(35),
                                                  fontFamily:
                                                      'Montserrat-ExtraBold',
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Text(
                                                snapshot.data[index]
                                                    ['descripcion'],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: Adapt.px(20),
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                Container(
                                  width: Adapt.wp(15),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: Adapt.px(40),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            lineaDivisoria,
                          ],
                        ),
                        onTap: () {
                          print(snapshot.data[index]['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FrequentQuestionsDetailPage(
                                      categoria:
                                          '${snapshot.data[index]['id']}',
                                      title:
                                          '${snapshot.data[index]['nombre']}',
                                    )),
                          );
                        },
                      );
                    },
                    childCount: snapshot.data.length,
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: LoadingIndicatorW(),
            );
          }
        },
      ),
    );
  }
}
// Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SupportPageInfo(
//                                 categoria: '',
//                                 title: 'Mis devoluciones',
//                               )),
//                     )