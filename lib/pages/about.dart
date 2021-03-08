import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Localize"),
            Text("Generate realtime location data"),
            Text("SimpleTools ©2021"),
          ],
        ),
      ),
    );
  }
}
