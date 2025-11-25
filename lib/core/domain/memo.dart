import 'package:freezed_annotation/freezed_annotation.dart';
import 'mood.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

@freezed
class Memo with _$Memo {
  const Memo._();

  // ローカル保存用なので、DateTimeのままでOK（勝手に文字列になる）
  //データを保管するために使う（過去の時間をそのまま持つ）
  const factory Memo({
    required String id,
    @Default('') String body,
    @Default(Mood.calm) Mood mood,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Memo;
  // データを生み出すために使う（今の時間をセットする）
  factory Memo.create({
    required String id,
    String body = '',
    Mood mood = Mood.calm,
  }) {
    final now = DateTime.now();
    return Memo(id: id, body: body, mood: mood, createdAt: now, updatedAt: now);
  }
  // JSON手書き回避のためのコード
  factory Memo.fromJson(Map<String, dynamic> json) => _$MemoFromJson(json);
}
