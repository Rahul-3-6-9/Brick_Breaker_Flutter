import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends PositionComponent with CollisionCallbacks, HasGameReference<BrickBreaker> {
  late Sprite _sprite;
  bool _isSpriteLoaded = false;
  Brick({required super.position})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        ) {
    _loadImage();
  }

  Future<void> _loadImage() async {
    final image = await Flame.images.load('cat.png');
    _sprite = Sprite(image);
    _isSpriteLoaded = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isSpriteLoaded) {
      _sprite.render(canvas, position: Vector2((position.x*0.01)+30, position.y*0.01), size: Vector2(brickWidth, brickHeight), anchor: Anchor.center);
    }
  }

// @override
// void render(Canvas canvas) {
//   super.render(canvas);
//   if (_isSpriteLoaded) {
//     _sprite.srcSize = Vector2(brickWidth, brickHeight);
//     _sprite.render(
//       canvas,
//       position: Vector2(
//         position.x + (gameBoundaryOffset.x), // add x offset
//         position.y + (gameBoundaryOffset.y), // add y offset
//       ),
//       size: Vector2(brickWidth, brickHeight),
//       anchor: Anchor.center,
//     );
//   }
// }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();

    if (game.world.children.query<Brick>().isEmpty) {
      game.playState = PlayState.won;                          
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}


// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// import '../brick_breaker.dart';
// import '../config.dart';
// import 'ball.dart';
// import 'bat.dart';

// class Brick extends RectangleComponent
//     with CollisionCallbacks, HasGameReference<BrickBreaker> {
//   Brick({required super.position, required Color color})
//       : super(
//           size: Vector2(brickWidth, brickHeight),
//           anchor: Anchor.center,
//           paint: Paint()
//             ..color = color
//             ..style = PaintingStyle.fill,
//           children: [RectangleHitbox()],
//         );

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);
//     removeFromParent();

//     if (game.world.children.query<Brick>().length == 1) {
//       game.world.removeAll(game.world.children.query<Ball>());
//       game.world.removeAll(game.world.children.query<Bat>());
//     }
//   }
// }