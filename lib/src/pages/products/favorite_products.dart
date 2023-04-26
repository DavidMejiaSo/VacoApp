import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/favorite_products_service.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/backgroundShop.dart';
import '../../../model/controller_arg_product.dart';
import '../../../responsive/Color.dart';
import '../../../service/restaurant_service.dart';
import '../../../service/search_favorite_products.dart';
import '../../widgets/alert_dialog_restaurante_cerrado.dart';
import '../../widgets/allergy_alert_image.dart';
import '../../widgets/appBar.dart';
import '../../widgets/favorite_product_icon.dart';
import '../../widgets/loading_indicator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'grocery_product_detail.dart';

class FavoriteProducts extends StatefulWidget {
  const FavoriteProducts({Key? key}) : super(key: key);

  @override
  State<FavoriteProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  final productService = ProductsService();
  final prefs = PreferenciasUsuario();
  final getUser = FavoriteProductsService();
  int listaProductosFavoritosNumero = 0;
  bool estadoBotonLike = true, _isVisibleIndicator = true;
  String nombreProducto = "",
      imagenProducto = "",
      numberid = "",
      alergiaProductoFavorito = "";
  dynamic listProductsReversed;
  List favoriteProductsId = [],
      listaProductosCompleta = [],
      listaProductosFavoritos = [],
      ingredientes = [];

  @override
  void initState() {
    traerProducFavorito();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "false",
            textoLabel: AppLocalizations.of(context)!.favoritos,
            anotherButton: Container(),
            bottonBackAction: () {},
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const BackgroundShop(),
            _body(),
            Visibility(
              visible: _isVisibleIndicator,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LoadingIndicatorW(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: Adapt.wp(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Adapt.hp(9)),
              _barSearchFavoriteProducts(),
              SizedBox(height: Adapt.hp(3)),
              _viewProductsFav()
            ],
          ),
        ),
      ),
    );
  }

  Widget _barSearchFavoriteProducts() {
    const borderr = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 148, 148, 148),
      ),
    );
    return Container(
      height: Adapt.hp(5),
      width: Adapt.wp(95),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TypeAheadField<ProductModel?>(
          minCharsForSuggestions: 2,
          animationStart: 0.1,
          loadingBuilder: (BuildContext context) {
            return Center(
                child: Container(
                    height: Adapt.hp(10), child: LoadingIndicatorW()));
          },
          hideSuggestionsOnKeyboardHide: true,
          textFieldConfiguration: TextFieldConfiguration(
            textAlignVertical: TextAlignVertical.bottom,
            style: const TextStyle(color: Colors.black),
            maxLength: 50,
            decoration: InputDecoration(
              counterText: "",
              hintText: AppLocalizations.of(context)!.buscar,
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 31, 31, 31),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: ColorSelect.primaryColorVaco,
              ),
              enabledBorder: borderr,
              disabledBorder: borderr,
              focusedBorder: borderr,
            ),
          ),
          suggestionsCallback:
              SearchFavorteProductsService.getFavoritesProducts,
          itemBuilder: (context, ProductModel? suggestion) {
            final product = suggestion!;
            return Container(
              color: Colors.white,
              child: ListTile(
                  selectedTileColor: Colors.white,
                  textColor: Colors.black,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      '${Env.currentEnv['serverUrl']}//imagenProducto/traerImagen?id='
                      '${product.idImagen}',
                    ),
                  ),
                  title: Text(
                    product.nombre,
                  )),
            );
          },
          noItemsFoundBuilder: (context) => Container(
            color: Colors.white,
            height: 40,
            child: const Center(
              child: Text(
                'No se encontraron restaurantes',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
          onSuggestionSelected: (ProductModel? suggestion) async {
            dynamic productoCompleto =
                await productService.obtenerProducto(suggestion?.id);

            dynamic restaurante = await restaurantService
                .obtenerRestaurante(productoCompleto['idRestauranteCreador']);

            await Future.delayed(const Duration(seconds: 1));
            if (restaurante['abierto']) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, __) {
                    return FadeTransition(
                      opacity: animation,
                      child: GroceryProductDetails(
                        product: productoCompleto,
                      ),
                    );
                  },
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertaRestauranteCerrado();
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _viewProductsFav() {
    return Container(
        width: Adapt.wp(90),
        child: ListView.custom(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: Adapt.px(10),
              right: Adapt.px(10),
            ),
            dragStartBehavior: DragStartBehavior.start,
            childrenDelegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return InkWell(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: Adapt.hp(13),
                      child: Row(
                        children: [
                          Container(
                            width: Adapt.wp(28),
                            height: Adapt.hp(15),
                            child: Stack(
                              children: [
                                Container(
                                  width: Adapt.wp(28),
                                  height: Adapt.hp(15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                                      '${listaProductosFavoritosCompletos[index].idImagen}',
                                      height: Adapt.hp(60),
                                      width: Adapt.wp(35),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                            height: Adapt.hp(9),
                                            width: Adapt.wp(20),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: AllergyAlertImage(
                                    idAlergia:
                                        listaProductosFavoritosCompletos[index]
                                            .alergias,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: Adapt.px(10)),
                              child: Container(
                                width: Adapt.wp(60),
                                height: Adapt.hp(15),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: listaProductosFavoritosCompletos[
                                                      index]
                                                  .nombre
                                                  .length >
                                              27
                                          ? Adapt.hp(2.5)
                                          : Adapt.hp(5.5),
                                      width: Adapt.wp(70),
                                      child: Text(
                                        '${listaProductosFavoritosCompletos[index].nombre}'
                                            .toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: Adapt.px(25),
                                          fontFamily: 'Montserrat-ExtraBold',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: Adapt.hp(6.3),
                                      width: Adapt.wp(70),
                                      child: Text(
                                        listaProductosFavoritosCompletos[index]
                                                    .ingredientes
                                                    .toString()
                                                    .split('[')[1]
                                                    .split(']')[0] !=
                                                ''
                                            ? '${listaProductosFavoritosCompletos[index].ingredientes.toString().split('[')[1].split(']')[0]}'
                                            : 'no ingrendientes',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: Adapt.px(20),
                                          color: Color.fromARGB(
                                              255, 134, 134, 134),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          FavoriteProductButton(
                            numberid:
                                '${listaProductosFavoritosCompletos[index].id}',
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Adapt.hp(2),
                    )
                  ],
                ),
                onTap: () async {
                  dynamic productoCompleto =
                      await productService.obtenerProducto(
                          listaProductosFavoritosCompletos[index].id);
                  // await Future.delayed(const Duration(seconds: 1));
                  dynamic restaurante =
                      await restaurantService.obtenerRestaurante(
                          productoCompleto['idRestauranteCreador']);

                  await Future.delayed(const Duration(seconds: 1));
                  if (restaurante['abierto']) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, __) {
                          return FadeTransition(
                            opacity: animation,
                            child: GroceryProductDetails(
                              product: productoCompleto,
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertaRestauranteCerrado();
                      },
                    );
                  }
                },
              );
            }, childCount: listaProductosFavoritosCompletos.length)));
  }

  List<ProductModel> listaProductosFavoritosCompletos = [];
  final restaurantService = RestaurantService();
  void traerProducFavorito() async {
    listaProductosFavoritosCompletos = [];

    List listIdFavoriteProducstUser =
        await traerProductosFavoritos.traerIdProductosFavoritos();
    List listIdFavoriteProducstUserReversed =
        listIdFavoriteProducstUser.reversed.toList();

    for (var i = 0;
        i < listIdFavoriteProducstUserReversed.toList().length;
        i++) {
      dynamic listaProductosCompleta = await productService
          .obtenerProducto(listIdFavoriteProducstUserReversed[i]);
      if (listaProductosCompleta != null) {
        ProductModel _producto = ProductModel.fromJson(listaProductosCompleta);

        listaProductosFavoritosCompletos.add(_producto);
      }
    }

    _isVisibleIndicator = false;

    setState(() {});
  }

  final traerProductosFavoritos = FavoriteProductsService();
  void getIngredient(int index) {
    ingredientes = [];
    for (var i = 0;
        i < listaProductosFavoritos[index]['ingredientes'].length;
        i++) {
      ingredientes.add(listaProductosFavoritos[index]['ingredientes'][i]);
    }
  }
}
