import 'package:flutter/foundation.dart';
import '../../features/memo/domain/models/memo.dart';
import '../../features/memo/domain/models/mood.dart';
import '../storage/memo_repository.dart';

class MemoNotifier extends ChangeNotifier {
  final MemoRepository _repo;
  List<Memo> items = [];
  bool loading = true;

  MemoNotifier(this._repo);

  Future<void> init() async {
    loading = true;
    notifyListeners();
    items = await _repo.loadAll();
    loading = false;
    notifyListeners();
  }

  Future<void> add(String title, String body, Mood mood) async {
    final memo = await _repo.create(title: title, body: body, mood: mood);
    items.insert(0, memo);
    notifyListeners();
  }

  Future<void> update(Memo updated) async {
    final memo = await _repo.update(updated);
    final idx = items.indexWhere((m) => m.id == memo.id);
    if (idx == -1) {
      items.insert(0, memo);
    } else {
      items[idx] = memo;
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    items.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
