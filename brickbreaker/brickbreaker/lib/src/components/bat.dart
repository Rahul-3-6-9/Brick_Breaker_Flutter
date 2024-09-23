// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
// import 'package:flame/events.dart';
// import 'package:flutter/material.dart';

// import '../brick_breaker.dart';

// class Bat extends PositionComponent
//     with DragCallbacks, HasGameReference<BrickBreaker> {
//   Bat({
//     required this.cornerRadius,
//     required super.position,
//     required super.size,
//   }) : super(
//           anchor: Anchor.center,
//           children: [RectangleHitbox()],
//         ) {
//     // Start size reduction on creation
//     startSizeReduction();
//   }

//   final Radius cornerRadius;

//   final _paint = Paint()
//     ..color = const Color.fromARGB(255, 255, 255, 255)
//     ..style = PaintingStyle.fill;

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Offset.zero & size.toSize(),
//           cornerRadius,
//         ),
//         _paint);
//   }

//   @override
//  void onDragUpdate(DragUpdateEvent event) {
//     super.onDragUpdate(event);
//     position.x = (position.x + event.localDelta.x).clamp(0, game.width);
//   }





//   void moveBy(double dx) {
//     add(MoveToEffect(
//       Vector2((position.x + dx).clamp(0, game.width), position.y),
//       EffectController(duration: 0.1),
//     ));
//   }

//   void startSizeReduction() {
//     // Calculate the target size (2/3 of the initial size)
//     final targetSize = Vector2(ballRadius*2, size.y);
//     // Create a size effect that reduces the size gradually over 60 seconds
//     add(
//       SizeEffect.to(
//         targetSize,
//         EffectController(duration: 45, curve: Curves.linear),
//       ),
//     );
//   }
// }


import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';

class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        ) {
    // Start size reduction on creation
    startSizeReduction();
  }

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color.fromARGB(255, 255, 255, 255)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size.toSize(),
          cornerRadius,
        ),
        _paint);
  }

@override
void onDragUpdate(DragUpdateEvent event) {
  super.onDragUpdate(event);
  position.x = (position.x + event.localDelta.x).clamp(0, game.width);
}


  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2((position.x + dx).clamp(0, game.width), position.y),
      EffectController(duration: 0.1),
    ));
  }

  void startSizeReduction() {
    // Calculate the target size
    final targetSize = Vector2(ballRadius*2, size.y);
    // Create a size effect that reduces the size gradually over 60 seconds
    add(
      SizeEffect.to(
        targetSize,
        EffectController(duration: 45, curve: Curves.linear),
      ),
    );
  }
}