import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/adversting_service.dart';

import '../../../model/controller_arg_restaurantes.dart';
import '../../../provider/global_provider.dart';
import '../../../service/restaurant_service.dart';
import '../../widgets/loading_indicator.dart';

class AdverstingHome extends StatefulWidget {
  const AdverstingHome({Key? key}) : super(key: key);

  @override
  State<AdverstingHome> createState() => _AdverstingHomeState();
}

final adverstingService = AdverstingService();

bool state = false;
double _currentPage = 0.0;
dynamic answerAdvertising;
List publicidadAprobada = [];
bool isLoading = false;
String idRestaurante = "";
List nombreRestauranteObteniedo = [];
List imageRestaurant = [];

class _AdverstingHomeState extends State<AdverstingHome> {
  final restaurantService = RestaurantService();

  List infoTotalRestaurante = [];
  void loadData() async {
    infoTotalRestaurante = [];
    answerAdvertising = await adverstingService.allAdversting();
    if (answerAdvertising.length == 0) {
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);
      globalProvider.esPublicidad = false;
    } else {
      for (var i = 0; i < answerAdvertising.length; i++) {
        idRestaurante = answerAdvertising[i]['restaurante'];
        dynamic respuestaServicio = await restaurantService
            .obtenerRestaurante(answerAdvertising[i]['restaurante']);
        infoTotalRestaurante.add(respuestaServicio);

        if (answerAdvertising[i]['estado'] == 'Aprobado') {
          publicidadAprobada.add(answerAdvertising[i]);
        }
      }
    }
  }

  final _pageController = PageController();
  void _listener() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void initState() {
    loadData();

    _pageController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.5),
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        listado(context),
        // Positioned(
        //   top: Adapt.hp(16),
        //   left: Adapt.wp(87),
        //   child: cerrarCajaSorpresa(),
        // )
      ],
    );
  }

  Widget cerrarCajaSorpresa() {
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
            final globalProvider =
                Provider.of<GlobalProvider>(context, listen: false);
            globalProvider.esPublicidad = false;
          },
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: imageCerrar.image),
        ),
      ),
    );
  }

  Widget listado(BuildContext context) {
    if (!state) {
      return FutureBuilder(
        future: adverstingService.allAdversting(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  height: Adapt.hp(60),
                  width: Adapt.wp(90),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        final percent = _currentPage - index;
                        final value = percent.clamp(0.0, 1.0);
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateX(value * 0.5 * pi),
                              child: GestureDetector(
                                onTap: () {
                                  final globalProvider =
                                      Provider.of<GlobalProvider>(context,
                                          listen: false);
                                  globalProvider.esPublicidad = false;

                                  Navigator.pushNamed(
                                    context,
                                    '/vistaProducto',
                                    arguments: OrganizacionRestaurantes(
                                      infoTotalRestaurante[index]["id"],
                                      infoTotalRestaurante[index]["nombre"],
                                      infoTotalRestaurante[index]
                                          ["idDepartamento"],
                                      infoTotalRestaurante[index]
                                          ["idMunicipio"],
                                      infoTotalRestaurante[index]["direccion"],
                                      infoTotalRestaurante[index]["longitud"],
                                      infoTotalRestaurante[index]["latitud"],
                                      infoTotalRestaurante[index]["telefono"],
                                      infoTotalRestaurante[index]["celular"],
                                      infoTotalRestaurante[index]
                                          ["tiempoEstimadoEntregaMinimo"],
                                      infoTotalRestaurante[index]
                                          ["tiempoEstimadoEntregaMaximo"],
                                      infoTotalRestaurante[index]
                                          ["idCategoriaRestaurante"],
                                      infoTotalRestaurante[index]["categorias"],
                                      infoTotalRestaurante[index]["estado"],
                                      infoTotalRestaurante[index]
                                          ["fechaCreacion"],
                                      infoTotalRestaurante[index]
                                          ["fechaActualizacion"],
                                      infoTotalRestaurante[index]["archivos"],
                                      infoTotalRestaurante[index]
                                          ["idUsuarioModificador"],
                                      infoTotalRestaurante[index]["idImagen"],
                                      infoTotalRestaurante[index]["idSocio"],
                                      infoTotalRestaurante[index]
                                          ["calificacionPromedio"],
                                      infoTotalRestaurante[index]["abierto"],
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        'http://ec2-54-227-131-11.compute-1.amazonaws.com:8080/imagenPublicidad/traerImagen?id=${snapshot.data[index]['id']}',
                                        fit: BoxFit.fitWidth,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: cerrarCajaSorpresa(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
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
      );
    } else {
      return const Center(
        child: LoadingIndicatorW(),
      );
    }
  }
}
