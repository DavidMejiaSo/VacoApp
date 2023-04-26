import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.format_align_center),
              title: const Text('login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('registro'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('welcome'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 20.0),
      ),
    );
  }
}
