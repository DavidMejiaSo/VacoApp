import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/responsive/Adapt.dart';

// ignore: must_be_immutable
class AppBarW extends StatefulWidget {
  AppBarW(
      {Key? key,
      required this.textoLabel,
      required this.bottonBackAction,
      required this.bottonBack,
      required this.anotherButton})
      : super(key: key);

  @override
  State<AppBarW> createState() => _AppBarWState();
  String textoLabel;
  Widget anotherButton;
  dynamic bottonBack;
  VoidCallback bottonBackAction;
}

class _AppBarWState extends State<AppBarW> {
  @override
  Widget build(BuildContext context) {
    Image imageRegreso = Image.asset(
      'assets/botones/BotonRegresar.png',
      fit: BoxFit.none,
    );
    return AppBar(
      centerTitle: true,
      toolbarHeight: Adapt.hp(9),
      title: Container(
        width: Adapt.wp(100),
        height: Adapt.hp(100),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.textoLabel.toUpperCase(),
            style: TextStyle(
              shadows: const [
                Shadow(
                  offset: Offset(0.1, 0.1),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 192, 192, 192),
                ),
              ],
              fontSize: Adapt.px(25),
              fontFamily: 'Montserrat-ExtraBold',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: widget.bottonBack == "false" ? 0 : Adapt.wp(12),
      leading: widget.bottonBack == "false"
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Container(
                width: Adapt.wp(3),
                height: Adapt.hp(5),
                child: GestureDetector(
                  onTap: widget.bottonBackAction,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: imageRegreso.image),
                ),
              ),
            ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [widget.anotherButton],
    );
  }
}
