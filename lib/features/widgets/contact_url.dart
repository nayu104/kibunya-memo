import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUrl extends StatelessWidget {
  const ContactUrl({super.key});

  // 開きたいURLをUri型で定義
  static final Uri _docsUrl = Uri.parse(
    'https://docs.google.com/forms/d/e/1FAIpQLSeSaK47aha1UtVZdAKEACvY45e4Wi1ERmFrGpArUZSqt9-P8A/viewform?usp=dialog',
  );

  // URLを開く関数
  Future<void> _launchDocs() async {
    // 外部ブラウザで開く例
    final canLaunch = await launchUrl(
      _docsUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!canLaunch) {
      // 失敗時のハンドリング（ログやSnackBarなど）
      debugPrint('URLを開けませんでした: $_docsUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: _launchDocs, // タップしたらURLを開く
        child: const Text(
          'お問い合わせ\nご要望はこちら',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
