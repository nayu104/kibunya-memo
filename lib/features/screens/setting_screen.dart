import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 設定画面
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '設定',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // ── データ ────────────────────────────────
          _buildSectionTitle('データ'),
          _buildSettingTile(
            icon: Icons.backup,
            title: 'バックアップ / 復元',
            subtitle: 'メモをエクスポート・インポートする',
            onTap: () {
              // TODO: バックアップ画面へ遷移/広告をつける
            },
          ),
          _buildSettingTile(
            icon: Icons.delete_forever,
            title: 'すべてのメモを削除',
            titleColor: Colors.red,
            onTap: () {
              // TODO: 確認ダイアログを出して全削除
            },
          ),
          const Divider(),

          // ── サポート ─────────────────────────────
          _buildSectionTitle('サポート'),
          _buildSettingTile(
            icon: Icons.mail_outline,
            title: 'お問い合わせ・ご要望',
            onTap: () {
              // TODO: mailto: か お問い合わせ画面へ
            },
          ),
          _buildSettingTile(
            icon: Icons.star_rate,
            title: 'レビューを書く',
            onTap: () {
              // TODO: ストアのレビュー画面へ遷移
            },
          ),
          const Divider(),

          // ── アプリ情報 ────────────────────────────
          _buildSectionTitle('アプリ情報'),
          _buildSettingTile(
            icon: Icons.description,
            title: '利用規約',
            onTap: () {
              // TODO: WebView or ブラウザで表示
            },
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: 'プライバシーポリシー',
            onTap: () {
              // TODO: WebView or ブラウザで表示
            },
          ),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'バージョン',
            subtitle: '1.0.0', // TODO: package_info_plus で動的取得
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// セクションタイトル
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  /// 通常の設定タイル
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Colors.black),
      title: Text(
        title,
        style: GoogleFonts.notoSans(
          fontSize: 16,
          color: titleColor ?? Colors.black,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
