import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 255, 255, 255),
          displayColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: FittedBox(
                  child: SizedBox(
                    width: gameWidth,
                    height: gameHeight,
                    child: GameWidget.controlled(
                      gameFactory: BrickBreaker.new,
                      overlayBuilderMap: {
                        PlayState.welcome.name: (context, game) => Center(
                              child: Text(
                                'TAP TO PLAY',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                        PlayState.gameOver.name: (context, game) => Center(
                              child: Text(
                                'G A M E   O V E R',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                        PlayState.won.name: (context, game) => Center(
                              child: Text(
                                'Y O U   W O N ! ! !',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}