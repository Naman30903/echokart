import 'package:echokart/bloc/cart_bloc.dart';
import 'package:echokart/ui/screens/audio_player.dart';
import 'package:echokart/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:echokart/ui/screens/home.dart';

void main() {
  runApp(const EchoKartApp());
}

class EchoKartApp extends StatelessWidget {
  const EchoKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartBloc()),
        // Add other BLoCs here
      ],
      child: MaterialApp(
        title: 'EchoKart',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
          ),
          scaffoldBackgroundColor: Colors.grey.shade50,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/audio_player': (context) => const AudioPlayerScreen(),
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}
