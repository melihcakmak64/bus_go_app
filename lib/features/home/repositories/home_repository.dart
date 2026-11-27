import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/home_models.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepository(db);
});

class HomeRepository {
  final AppDatabase _appDatabase;

  const HomeRepository(this._appDatabase);

  static const List<PopularCompanyModel> _staticCompanies = [
    PopularCompanyModel(name: 'Kamil Koç'),
    PopularCompanyModel(name: 'Pamukkale'),
    PopularCompanyModel(name: 'Metro Turizm'),
    PopularCompanyModel(name: 'Varan'),
  ];


  static const List<PopularRouteModel> _staticPopularRoutes = [
    PopularRouteModel(
      fromCity: 'İstanbul',
      toCity: 'Ankara',
      dailyTripsLabel: 'Günlük 48 sefer',
      startingPrice: 450,
    ),
    PopularRouteModel(
      fromCity: 'İzmir',
      toCity: 'İstanbul',
      dailyTripsLabel: 'Günlük 36 sefer',
      startingPrice: 550,
    ),
    PopularRouteModel(
      fromCity: 'Bursa',
      toCity: 'Antalya',
      dailyTripsLabel: 'Günlük 22 sefer',
      startingPrice: 620,
    ),
    PopularRouteModel(
      fromCity: 'Ankara',
      toCity: 'Eskişehir',
      dailyTripsLabel: 'Günlük 54 sefer',
      startingPrice: 180,
    ),
  ];

  Future<HomeDataModel> getHomeData() async {
    final db = await _appDatabase.database;

    final categoryRows = await db.query(
      'Category',
      orderBy: 'Id ASC',
    );
    final cityRows = await db.query(
      'cities',
      orderBy: 'id ASC',
    );
    final campaignRows = await db.query(
      'Campaign',
      orderBy: 'Id ASC',
    );

    return HomeDataModel(
      categories: categoryRows.map(CategoryModel.fromMap).toList(),
      cities: cityRows.map(CityModel.fromMap).toList(),
      campaigns: campaignRows.map(CampaignModel.fromMap).toList(),
      companies: _staticCompanies,
      popularRoutes: _staticPopularRoutes,
    );
  }
}