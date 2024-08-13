import 'dart:async';

import 'package:flame/collisions.dart';                         // Add this import
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
    late Sprite _sprite;
  bool _isSpriteLoaded = false;
  PlayArea()
      : super(
          children: [RectangleHitbox()],                        // Add this parameter
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
    _loadImage();
  }

  Future<void> _loadImage() async {
    if(gameStarted == true){
    final image = await Flame.images.load('bg1.jpg');
    _sprite = Sprite(image);
    _isSpriteLoaded = true;
    }

    else{
      final image = await Flame.images.load('BackGround.png');
    _sprite = Sprite(image);
    _isSpriteLoaded = true;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isSpriteLoaded) {
      _sprite.render(
        canvas,
        size: Vector2(game.width, game.height),
        position: Vector2(game.width/2, game.height/2),
        anchor: Anchor.center,
      );
    }
  }
  
}