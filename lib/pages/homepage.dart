import 'package:flutter/material.dart';
import 'package:localize/pages/about.dart';
import 'package:location/location.dart';

class StateNotifier {
  ValueNotifier state = ValueNotifier("initial");

  void changeState(String newState) {
    state.value = newState;
  }
}

StateNotifier stateNotifier = StateNotifier();

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationData _locationData;
    String errorData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Localize"),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("About app"),
                value: "about",
              )
            ],
            onSelected: (value) {
              if (value == "about") {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          stateNotifier.changeState("loading");

          Location location = Location();

          bool _serviceEnabled;
          PermissionStatus _permissionGranted;

          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              errorData = "Location Not Enabled";
              stateNotifier.changeState("error");
              return;
            }
          }

          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              errorData = "Permission denied";
              stateNotifier.changeState("error");
              return;
            }
          }

          _locationData = await location.getLocation();
          stateNotifier.changeState("done");
        },
        label: Text("Localize"),
      ),
      body: ValueListenableBuilder(
        valueListenable: stateNotifier.state,
        builder: (context, value, child) {
          if (value == "initial") return Container();
          if (value == "loading") return CircularProgressIndicator();
          if (value == "error")
            return Center(
              child: Text("$errorData"),
            );
          return Column();
        },
        child: Column(
          children: <Widget>[
            Container(
              child: Text("Latitude: ${_locationData.latitude}"),
            ),
            Container(
              child: Text("Longitude: ${_locationData.longitude}"),
            ),
            Container(
              child: Text("Altitude: ${_locationData.altitude}"),
            ),
            Container(
              child: Text(
                  "Time: ${DateTime.fromMillisecondsSinceEpoch(_locationData.time.toInt())}"),
            ),
          ],
        ),
      ),
    );
  }
}
