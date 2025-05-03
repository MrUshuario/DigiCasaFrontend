import 'dart:io';
import 'package:digicasa/splash.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

GetIt getIt = GetIt.instance;

void main() async {

  HttpOverrides.global = MyHttpOverrides();
  //getIt.registerSingletonAsync<Client>(() async => await Future(() => Client()));
  //getIt.registerSingletonAsync<LocationRepository>(() async => await Future(() => LocationRepositoryImpl()));
  //getIt.registerSingletonAsync<DevicesInfoPlusRepository>(() async => await Future(() => DevicesInfoPlusRepositoryImpl()));
  //getIt.registerSingletonAsync<apiprovider_menuOpciones>(() async => await Future(() => apiprovider_menuOpciones()));
  //getIt.registerSingletonAsync<AppDatabase>(() async => await $FloorAppDatabase.databaseBuilder('siContigo.db').build());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

///////ME LO PASO MIGUEL: CREA UN CERTIFICADO DE CONFIANZA POR DEFAULT A LA LIBRERIA HTTP
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
