import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/model/grocery_store_bloc.dart';

class GroceryProvider extends InheritedWidget {
  final GroceryStoreBloc bloc;
  @override
  final Widget child;

  const GroceryProvider({Key? key, 
    required this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static GroceryProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<GroceryProvider>();
  @override
  bool updateShouldNotify(GroceryProvider oldWidget) => true;
}
