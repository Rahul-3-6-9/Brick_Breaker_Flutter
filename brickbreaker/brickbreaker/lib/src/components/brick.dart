import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';  // For handling effects and animations
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Play a scale-down animation before removing the brick
    add(
      ScaleEffect.to(
        Vector2.zero(),  // Target scale (shrinking to 0)
        EffectController(duration: 0.15, curve: Curves.easeIn),  // Duration and curve for the effect
        onComplete: () {
          removeFromParent();  // Remove the brick after the animation is complete

          // Check if all bricks are destroyed
          if (game.world.children.query<Brick>().length == 1) {
            game.world.removeAll(game.world.children.query<Ball>());
            game.world.removeAll(game.world.children.query<Bat>());
          }
        },
      ),
    );
  }
}