import 'package:flutter/material.dart';

class AppColors {
  // ベース：温かみのあるクリームイエロー
  static const seed = Color(0xFFFFF9C4);

  // 背景：真っ白ではなく、目に優しい生成り色
  static const scaffold = Color(0xFFFDFBF7);

  // FAB：焼いたオレンジ（アクセント）
  static const fab = Color(0xFFFF8F00);

  // 気分メモ：少し彩度を落としたパステル
  static const moodHappy = Color(0xFFFFE082); // 優しい黄色
  static const moodCalm = Color(0xFF81D4FA); // 空色
  static const moodTired = Color(0xFFB0BEC5); // グレーがかった青（落ち着く）
  static const moodFired = Color(0xFFFFAB91); // サーモンピンク

  // 文字色：真っ黒ではなく、濃い焦げ茶（カフェ風）
  static const textMain = Color(0xFF4E342E);
  static const textSub = Color(0xFF8D6E63);

  static const delete = Color(0xFFFF8F00);
  static const onDelete = Colors.white; // その上のアイコン色
}
