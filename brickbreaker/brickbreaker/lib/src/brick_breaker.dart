// import 'dart:async';
// import 'dart:math' as math;

// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'components/components.dart';
// import 'config.dart';
// import 'package:flame/effects.dart';

// enum PlayState { welcome, playing, gameOver, won }

// class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
//   bool timeStarted = false;
//   final rand = math.Random();
  
//   double get width => size.x;
//   double get height => size.y;

//   late PlayState _playState;
//   PlayState get playState => _playState;
//   set playState(PlayState value) {
//     _playState = value;
//     switch (value) {
//       case PlayState.welcome:
//       case PlayState.gameOver:
//       case PlayState.won:
//         overlays.add(value.name);
//       case PlayState.playing:
//         overlays.remove(PlayState.welcome.name);
//         overlays.remove(PlayState.gameOver.name);
//         overlays.remove(PlayState.won.name);
//     }
//   }

//   @override
//   FutureOr<void> onLoad() async {
//     super.onLoad();

//     camera.viewfinder.anchor = Anchor.topLeft;

//     world.add(PlayArea());

//     await FlameAudio.audioCache.loadAll(['bgm.mp3']);
//     FlameAudio.bgm.play('bgm.mp3');

//     playState = PlayState.welcome;
//   }

//   void startGame() async {
//     if (playState == PlayState.playing) {
//       FlameAudio.bgm.stop();
//       return;
//     }

//     timeStarted = true;
//     world.removeAll(world.children.query<Ball>());
//     world.removeAll(world.children.query<Bat>());
//     world.removeAll(world.children.query<Brick>());
//     world.removeAll(world.children.query<PlayArea>());

//     playState = PlayState.playing;
//     world.add(PlayArea());
//     world.add(Ball(
//       difficultyModifier: difficultyModifier,
//       radius: ballRadius,
//       position: size / 2,
//       velocity: ((Vector2((rand.nextDouble() - 0.5), (1))) * 2.0)
//         ..scale(height / 4),
//     ));

//     world.add(Bat(
//       size: Vector2(batWidth, batHeight),
//       cornerRadius: const Radius.circular(ballRadius / 2),
//       position: Vector2(width / 2, height * 0.9),
//     ));

//     await world.addAll([
//       for (var i = 0; i < 20; i++)
//         for (var j = 1; j <= 15; j++)
//           Brick(
//             position: Vector2(
//               (i + 0.5) * brickWidth + (i + 1) * brickGutter,
//               (j + 4.0) * brickHeight + j * brickGutter,
//             ),
//             color: const Color.fromARGB(255, 255, 255, 255),
//           ),
//     ]);
//   }

//   final TextPaint textPaint = TextPaint(
//     style: const TextStyle(color: Colors.white, fontSize: 40),
//   );

//   @override
//   // void render(Canvas canvas) {
//   //   super.render(canvas);
//   //   if (playState == PlayState.playing) {
//   //     textPaint.render(
//   //       canvas,
//   //       "Time Remaining: ${(60 - countdown.current.toInt()).toString()}",
//   //       Vector2(10, 50),
//   //     );
//   //   }
//   // }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     if (!timeStarted) {
//       countdown.start();
//     }
//     countdown.update(dt);

//     // if (countdown.finished) {
//     //   add(RemoveEffect(
//     //     delay: 0.35,
//     //     onComplete: () {
//     //       playState = PlayState.gameOver;
//     //       timeStarted = false;
//     //       world.removeAll(world.children.query<Ball>());
//     //     },
//     //   ));
//     // }
//   }

//   @override
//   void onTapDown(TapDownInfo info) {
//     super.onTapDown(info);

//     if (playState == PlayState.welcome || playState == PlayState.gameOver || playState == PlayState.won) {
//       startGame();
//       return;
//     }

//     // Control the bat using the entire screen touch
//     final tapPosition = info.eventPosition.global;
//     final bat = world.children.query<Bat>().first;
//     final batCenterX = bat.position.x + (batWidth / 2);

//     // Move the bat towards the tap position
//     if (tapPosition.x < batCenterX) {
//       bat.moveBy(-batStep); // Move left
//     } else {
//       bat.moveBy(batStep);  // Move right
//     }
//   }

//   @override
//   KeyEventResult onKeyEvent(
//       KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     super.onKeyEvent(event, keysPressed);
//     switch (event.logicalKey) {
//       case LogicalKeyboardKey.arrowLeft:
//         world.children.query<Bat>().first.moveBy(-batStep);
//       case LogicalKeyboardKey.arrowRight:
//         world.children.query<Bat>().first.moveBy(batStep);
//       case LogicalKeyboardKey.space:
//       case LogicalKeyboardKey.enter:
//         startGame();
//     }
//     return KeyEventResult.handled;
//   }

//   @override
//   Color backgroundColor() => const Color(0xfff2e8cf);

//   void onPause() {
//     FlameAudio.bgm.stop();
//   }
// }

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
import 'package:flame/effects.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector, DragCallbacks {
  bool timeStarted = false;
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

    // await FlameAudio.audioCache.loadAll(['bgm.mp3']);
    // FlameAudio.bgm.play('bgm.mp3');

    playState = PlayState.welcome;
  }

  void startGame() async {
    if (playState == PlayState.playing) {
      FlameAudio.bgm.stop();
      return;
    }

    timeStarted = true;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<PlayArea>());

    if((rand.nextDouble() - 0.5)<=0){
      sign =-1;
    } else {
      sign = 1;
    }

    playState = PlayState.playing;
    world.add(PlayArea());
    world.add(Ball(
      difficultyModifier: difficultyModifier,
      radius: ballRadius,
      position: Vector2(width / 2, (height * 0.9)-200) ,
      velocity: ((Vector2((sign), (1.75))) * -1)
        ..scale(height / 4),
    ));

    world.add(Bat(
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 2),
      position: Vector2(width / 2, height * 0.9),
    ));

    await world.addAll([
      for (var i = 0; i < 20; i++)
        for (var j = 1; j <= 15; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 4.0) * brickHeight + j * brickGutter,
            ),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
    ]);
  }

  final TextPaint textPaint = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 40),
  );

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   if (playState == PlayState.playing) {
  //     textPaint.render(
  //       canvas,
  //       "Time Remaining: ${i.toInt()}}",
  //       Vector2(10, 50),
  //     );
  //   }
  // }

  @override
  void update(double dt) {
    super.update(dt);
    if (!timeStarted) {
      countdown.start();
    }
    countdown.update(dt);
    
    // if (countdown.finished) {
    //   add(RemoveEffect(
    //     delay: 0.35,
    //     onComplete: () {
    //       playState = PlayState.gameOver;
    //       timeStarted = false;
    //       world.removeAll(world.children.query<Ball>());
    //     },
    //   ));
    // }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (playState == PlayState.welcome || playState == PlayState.gameOver || playState == PlayState.won) {
      startGame();
      return;
    }

    // Control the bat using the entire screen touch
    final tapPosition = info.eventPosition.global;
    final bat = world.children.query<Bat>().first;
    final batCenterX = bat.position.x + (batWidth / 2);

  //   // Move the bat towards the tap position
  //   if (tapPosition.x < batCenterX) {
  //     bat.moveBy(-batStep); // Move left
  //   } else {
  //     bat.moveBy(batStep);  // Move right
  //   }
  // }

  

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

  // void onPause() {
  //   FlameAudio.bgm.stop();
  // }
}
}
