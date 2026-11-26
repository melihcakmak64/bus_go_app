import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_models.dart';
import '../repositories/home_repository.dart';

class HomeUiState {
  final HomeDataModel data;
  final int selectedCategoryId;
  final int selectedCampaignIndex;
  final CityModel? fromCity;
  final CityModel? toCity;
  final String departureDateLabel;
  final int passengerCount;
  final String passengerTypeLabel;
  final int loyaltyPoints;

  const HomeUiState({
    required this.data,
    required this.selectedCategoryId,
    required this.selectedCampaignIndex,
    this.fromCity,
    this.toCity,
    required this.departureDateLabel,
    required this.passengerCount,
    required this.passengerTypeLabel,
    required this.loyaltyPoints,
  });

  HomeUiState copyWith({
    HomeDataModel? data,
    int? selectedCategoryId,
    int? selectedCampaignIndex,
    CityModel? fromCity,
    CityModel? toCity,
    String? departureDateLabel,
    int? passengerCount,
    String? passengerTypeLabel,
    int? loyaltyPoints,
  }) {
    return HomeUiState(
      data: data ?? this.data,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCampaignIndex:
          selectedCampaignIndex ?? this.selectedCampaignIndex,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      departureDateLabel: departureDateLabel ?? this.departureDateLabel,
      passengerCount: passengerCount ?? this.passengerCount,
      passengerTypeLabel: passengerTypeLabel ?? this.passengerTypeLabel,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }
}

final homeViewModelProvider =
    AsyncNotifierProvider.autoDispose<HomeViewModel, HomeUiState>(
  HomeViewModel.new,
);

class HomeViewModel extends AsyncNotifier<HomeUiState> {
  @override
  FutureOr<HomeUiState> build() async {
    final data = await ref.read(homeRepositoryProvider).getHomeData();
    final defaultCategoryId =
        data.categories.isNotEmpty ? data.categories.first.id : 1;
    final defaultFrom = data.cities.isNotEmpty ? data.cities.first : null;
    final defaultTo = data.cities.length > 1 ? data.cities[1] : defaultFrom;

    return HomeUiState(
      data: data,
      selectedCategoryId: defaultCategoryId,
      selectedCampaignIndex: 0,
      fromCity: defaultFrom,
      toCity: defaultTo,
      departureDateLabel: '18 Ekim Cuma',
      passengerCount: 1,
      passengerTypeLabel: 'Standart / Tam',
      loyaltyPoints: 120,
    );
  }

  void selectCategory(int categoryId) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedCategoryId: categoryId));
  }

  void selectCampaign(int index) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedCampaignIndex: index));
  }

  void setFromCity(CityModel city) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(fromCity: city));
  }

  void setToCity(CityModel city) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(toCity: city));
  }

  void swapCities() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        fromCity: current.toCity,
        toCity: current.fromCity,
      ),
    );
  }

  void setDatePreset(String label) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(departureDateLabel: label));
  }

  void cyclePassengerCount() {
    final current = state.asData?.value;
    if (current == null) return;
    final nextCount = current.passengerCount >= 4 ? 1 : current.passengerCount + 1;
    state = AsyncData(current.copyWith(passengerCount: nextCount));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.read(homeRepositoryProvider).getHomeData();
      final prev = state.asData?.value;
      return HomeUiState(
        data: data,
        selectedCategoryId: prev?.selectedCategoryId ??
            (data.categories.isNotEmpty ? data.categories.first.id : 1),
        selectedCampaignIndex: prev?.selectedCampaignIndex ?? 0,
        fromCity: prev?.fromCity ?? (data.cities.isNotEmpty ? data.cities.first : null),
        toCity: prev?.toCity ??
            (data.cities.length > 1
                ? data.cities[1]
                : (data.cities.isNotEmpty ? data.cities.first : null)),
        departureDateLabel: prev?.departureDateLabel ?? '18 Ekim Cuma',
        passengerCount: prev?.passengerCount ?? 1,
        passengerTypeLabel: prev?.passengerTypeLabel ?? 'Standart / Tam',
        loyaltyPoints: prev?.loyaltyPoints ?? 120,
      );
    });
  }
}