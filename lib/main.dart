import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/infrastructure/models/character_model.dart';
import 'package:rick_and_morty_app/presentation/providers/api_provider.dart';
import 'package:rick_and_morty_app/presentation/screens/character_screen.dart';
import 'package:rick_and_morty_app/presentation/screens/home_screen.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen(), routes: [
    GoRoute(
      path: 'character',
      builder: (context, state) =>
          CharacterScreen(character: state.extra as Character),
    )
  ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        routerConfig: _router,
      ),
    );
  }
}