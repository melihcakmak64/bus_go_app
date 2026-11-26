import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../repositories/home_repository.dart';

final homeViewModelProvider =
    AsyncNotifierProvider.autoDispose<HomeViewModel, List<PostModel>>(
  HomeViewModel.new,
);

class HomeViewModel extends AsyncNotifier<List<PostModel>> {
  @override
  FutureOr<List<PostModel>> build() {
    return ref.read(homeRepositoryProvider).getPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).getPosts(),
    );
  }
}