import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/post_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepository(db);
});

class HomeRepository {
  final AppDatabase _appDatabase;

  const HomeRepository(this._appDatabase);

  Future<List<PostModel>> getPosts() async {
    final db = await _appDatabase.database;
    final rows = await db.query('posts', orderBy: 'id DESC');
    return rows.map((row) => PostModel.fromMap(row)).toList();
  }
}