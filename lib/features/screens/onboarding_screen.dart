import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'memo_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends StatefulWidget {
  final bool fromSettings;

  const OnboardingScreen({super.key, this.fromSettings = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    if (widget.fromSettings) {
      // 設定画面から来た場合は単に閉じる
      Navigator.of(context).pop();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MemoListScreen()),
    );
  }

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "今の気分を記録しよう",
      "description": "嬉しい、悲しい、おだやか...\nその瞬間の感情をスタンプで残せます。",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "シンプルなメモ",
      "description": "思いついたことをサッと書き留める。\n余計な機能はない、あなただけの場所。",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "この子はあなたの相棒",
      "description": "名前はメモルちゃん\n背景であなたを見守っています。",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(data["image"]!, height: 300),
                const SizedBox(height: 40),
                Text(
                  data["title"]!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  data["description"]!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      _finishOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? (widget.fromSettings ? "閉じる" : "はじめる")
                        : "つぎへ",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
