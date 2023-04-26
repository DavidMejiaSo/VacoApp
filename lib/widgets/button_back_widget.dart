import 'package:flutter/material.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image imageCerrar = Image.asset(
      'assets/botones/BotonCerrar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: CircleAvatar(
            backgroundColor: Colors.white, backgroundImage: imageCerrar.image),
      ),
    );
  }
}
