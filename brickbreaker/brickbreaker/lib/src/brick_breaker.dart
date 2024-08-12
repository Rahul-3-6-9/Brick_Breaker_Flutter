import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  late Timer countdown;
  bool timeStarted = false;

  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
PlayState get playState => _playState;
set playState(PlayState value) {
  _playState = value;
  switch (value) {
    case PlayState.welcome:
    case PlayState.gameOver:
    case PlayState.won:
      overlays.add(value.name);
    case PlayState.playing:
      overlays.remove(PlayState.welcome.name);
      overlays.remove(PlayState.gameOver.name);
      overlays.remove(PlayState.won.name);
  }
}

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

      await FlameAudio.audioCache.loadAll(['bgm.mp3']);
      FlameAudio.bgm.play('bgm.mp3');

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) {
      FlameAudio.bgm.stop();
      return;
    }

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;

    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4)));

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95)));

    final brickImages = [];

    for (int i = 0; i < 50; i++){
      brickImages.add('piece_$i.jpg');
    }


    for (var i = 0; i < brickColors.length; i++){
        for (var j = 1; j <= 5; j++){
          final brick = Brick(
        position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
        imagePath: brickImages[((j-1)*10)+i],
      );
      world.add(brick);
        }
    }
  }

  @override
  void onTap() {
    super.onTap();
    onPause();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);

  void onPause() {
    FlameAudio.bgm.stop();
  }
}