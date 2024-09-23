import 'package:brickbreaker/src/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

import '../brick_breaker.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';


class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color.fromARGB(255, 255, 255, 255)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  final Vector2 velocity;
  final double difficultyModifier;

  final double _fixedTimestep = 1 / 144;


@override
void update(double dt) {
  if (dt >= _fixedTimestep) {
    super.update(dt);
    position += velocity * dt;
    ballPosition = position;// Update game logic here
    dt = 0;
    if (ballPosition.y <= (1 + 4.0) * brickHeight - 1 * brickGutter-15) {
        velocity.y = -velocity.y;
        ballPosition.y = (1 + 4.0) * brickHeight - 1 * brickGutter+15;
      } else if (ballPosition.x <= 0) {
        velocity.x = -velocity.x;
        ballPosition.x = 17;

      } else if (ballPosition.x >= game.width) {
        velocity.x = -velocity.x;
        ballPosition.x = game.width-17;
      } else if (ballPosition.y >= game.height) {
        add(RemoveEffect(
            delay: 0.35,
            onComplete: () {    
              countdown.reset();   
              i=0;                             // Modify from here
              game.playState = PlayState.gameOver;
              
              
            }));                                                // To here.
      }
      


  }
}

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= (1 + 4.0) * brickHeight -1 * brickGutter-15) {
        velocity.y = -velocity.y;
        ballPosition.y = (1 + 4.0) * brickHeight  -1 * brickGutter+15;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
        ballPosition.x = 17;

      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
        ballPosition.x = game.width-17;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
            delay: 0.35,
            onComplete: () {    
              countdown.reset();       
              i=0;                         // Modify from here
              game.playState = PlayState.gameOver;
              
            }));                                                // To here.
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
      bat_collision();
    } else if (other is Brick) {
      brick_collision();
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      } else{}


      if (i<25){
        velocity.setFrom(velocity*difficultyModifier);
        i=i+1;
      }
    }
  }

  void bat_collision() async{
  await FlameAudio.audioCache.load('paddle1.mp3');
  FlameAudio.play('paddle1.mp3');
  }

  void brick_collision() async{
  await FlameAudio.audioCache.load('Brick1.wav');
  FlameAudio.play('Brick1.wav');
  }
  
}