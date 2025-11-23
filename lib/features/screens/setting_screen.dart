import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:memomemo/core/constants/app_urls.dart';
import 'package:memomemo/core/app_colors.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // テーマから色とテキストスタイルをもらう
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // ── データ設定 ─────────────────────────────
          _buildSectionTitle(context, 'データ'),
          _buildSettingTile(
            context: context,
            icon: Icons.backup,
            title: 'バックアップ / 復元',
            onTap: () {
              // TODO: 実装
            },
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.delete_forever,
            title: 'すべてのメモを削除',
            // 赤色 (Error Color) を使う
            titleColor: AppColors.delete,
            onTap: () {
              // TODO: 実装
            },
          ),
          const Divider(),

          // ── サポート ──────────────────────────────
          _buildSectionTitle(context, 'サポート'),
          _buildSettingTile(
            context: context,
            icon: Icons.mail_outline,
            title: 'お問い合わせ・ご要望',

            onTap: () async {
              final url = Uri.parse(AppUrls.contactForm);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                debugPrint('Could not launch $url');
              }
            },
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.star_rate,
            title: 'レビューを書く',
            onTap: () {
              // TODO: 実装
            },
          ),
          const Divider(),

          // ── アプリ情報 ─────────────────────────────
          _buildSectionTitle(context, 'アプリ情報'),
          _buildSettingTile(
            context: context,
            icon: Icons.description,
            title: '利用規約',
            onTap: () {},
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.privacy_tip,
            title: 'プライバシーポリシー',
            onTap: () {},
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.info_outline,
            title: 'バージョン',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// セクションタイトル
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        // テーマの「小さめの文字スタイル」を適用
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant, // 少し薄い色
        ),
      ),
    );
  }

  /// 設定項目タイル
  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        // 指定がなければテーマの基本色を使う
        color: colorScheme.onSurface,
      ),
      title: Text(
        title,
        // // テーマの「本文スタイル」を使う, 色だけ変更（これでフォントも適用される）
        style: theme.textTheme.bodyLarge?.copyWith(
          color: titleColor ?? colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: titleColor ?? colorScheme.onSurface,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant, // 薄いグレー
      ),
      onTap: onTap,
    );
  }
}
