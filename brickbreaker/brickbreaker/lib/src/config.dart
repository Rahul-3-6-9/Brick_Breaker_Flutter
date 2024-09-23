import 'package:flame/components.dart';
import 'package:flutter/material.dart';  
import 'dart:math' as math;                       // Add this import

const brickColors = [                                           // Add this const
  Color(0xfff94144),
  Color.fromARGB(255, 0, 0, 0),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff277da1),
  Color(0xff577590),
];
final rand = math.Random();
const gameWidth = 820.0;
const gameHeight = 1600.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.3;
const batHeight = ballRadius * 2;
const batStep = gameWidth * 0.05;
const brickGutter = gameWidth * 0.015;                          // Add from here...
const brickWidth =
    (gameWidth - (brickGutter * (20 + 1)))
    / 20;
const brickHeight =(gameHeight * 0.03)/2;
const difficultyModifier = 1.02;
bool gameStarted = false;                              // To here.
Vector2 ballPosition = Vector2(0, 0);
final countdown = Timer(60);
int i = 1;
double sign = 0;
