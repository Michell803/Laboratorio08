import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'amplifyconfiguration.dart'; // Este archivo es generado por Amplify CLI
import 'iluminacion_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(MyApp());
}

Future<void> configureAmplify() async {
  try {
    await Amplify.addPlugins([AmplifyDataStore(modelProvider: ModelProvider.instance)]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Datos Históricos'),
        ),
        body: FutureBuilder(
          future: getIluminacion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Iluminacion> datosIluminacion = snapshot.data as List<Iluminacion>;
              return ListView.builder(
                itemCount: datosIluminacion.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(datosIluminacion[index].intensidad),
                    subtitle: Text(datosIluminacion[index].fecha),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }


  //npm install -g @aws-amplify/cli
  // flutter pub run amplify:codegen
  // flutter pub run amplify:configure
  Future<List<Iluminacion>> getIluminacion() async {
    try {
      final iluminacion = await Amplify.DataStore.query(Iluminacion.classType);
      return List<Iluminacion>.from(iluminacion);
    } catch (e) {
      print('Error getting iluminacion: $e');
      return [];
    }
  }

}




