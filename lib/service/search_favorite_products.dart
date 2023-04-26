import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../model/controller_arg_product.dart';
import '../preferences/preferences_user.dart';
import 'favorite_products_service.dart';

class SearchFavorteProductsService {
  static Future<List<ProductModel>> getFavoritesProducts(String query) async {
    final getUser = FavoriteProductsService();
    final prefs = PreferenciasUsuario();
    String url = '${Env.currentEnv['serverUrl']}/productoRestaurante/listar';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    if (response.statusCode == 200) {
      List listIdFavoriteProducstUser =
          await getUser.traerIdProductosFavoritos();
      dynamic respuesta = jsonDecode(utf8.decode(response.bodyBytes));
      List users = [];
      for (var j = 0; j < respuesta.length; j++) {
        for (var i = 0; i < listIdFavoriteProducstUser.length; i++) {
          if (listIdFavoriteProducstUser[i].toString() ==
              respuesta[j]['id'].toString()) {
            users.add(respuesta[j]);
          }
        }
      }

      return users.map((json) => ProductModel.fromJson(json)).where((user) {
        final nameLower = user.nombre.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
