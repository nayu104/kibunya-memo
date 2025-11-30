import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:memomemo/core/constants/app_urls.dart';
//import 'package:memomemo/core/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memomemo/core/provider/memo_state.dart';
import 'package:memomemo/crashlytics.dart';
import 'onboarding_screen.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

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
            onTap: () async {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('クラウドに保存しています...')));
              try {
                await ref.read(memoNotifierProvider.notifier).backupToCloud();
                if (context.mounted) {
                  // 前のスナックバーを消してから新しいのを出す
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('保存しました！')));
                }
              } catch (e) {
                // 4. 失敗フィードバック
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('保存に失敗しました'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.delete_forever,
            title: 'すべてのメモを削除',
            titleColor: Theme.of(context).colorScheme.error,
            onTap: () async {
              // 1. ダイアログを表示し、ユーザーの決断を待つ (await)
              // 削除なら true, キャンセルなら false (または null) が返ってくる
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('すべてのメモを削除'),
                  content: const Text('本当にすべてのメモを削除しますか？\nこの操作は元に戻せません。'),
                  actions: [
                    TextButton(
                      // キャンセルなら false を返して閉じる
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      // 削除なら true を返して閉じる
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(
                        '削除',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              // 2. ダイアログが閉じた後の処理
              // ユーザーが「削除」を選んだ場合のみ実行
              if (shouldDelete == true) {
                await ref.read(memoNotifierProvider.notifier).deleteAll();

                // 3. フィードバックを表示 (SnackBar)
                // 非同期処理の後なので、設定画面であるか確認(mounted)してから表示
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('すべてのメモを削除しました'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
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
            icon: Icons.help_outline,
            title: '使い方を見る',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OnboardingScreen(fromSettings: true),
                ),
              );
            },
          ),
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
          const Divider(),
          _buildSettingTile(
            context: context,
            icon: Icons.bug_report,
            title: 'クラッシュテスト',
            titleColor: Theme.of(context).colorScheme.error,
            onTap: () {
              Crashlytics.log('ログ');
              Crashlytics.crash('アプリクラッシュテスト');
            },
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
