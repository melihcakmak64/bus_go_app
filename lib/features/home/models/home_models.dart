class CategoryModel {
  final int id;
  final String name;
  final String iconCode;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['Id'] as int,
      name: map['Name'] as String,
      iconCode: map['IconCode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'IconCode': iconCode,
    };
  }
}

class CityModel {
  final int id;
  final String name;
  final String? terminal;

  const CityModel({
    required this.id,
    required this.name,
    this.terminal,
  });

  String get displayName =>
      (terminal != null && terminal!.trim().isNotEmpty) ? '$name ($terminal)' : name;

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] as int,
      name: map['name'] as String,
      terminal: map['terminal'] as String?,
    );
  }
}

class CampaignModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? iconCode;
  final String? bgColor;
  final String? imageName;

  const CampaignModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.iconCode,
    this.bgColor,
    this.imageName,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      id: map['Id'] as int,
      title: map['Title'] as String,
      subtitle: map['Subtitle'] as String?,
      iconCode: map['IconCode'] as String?,
      bgColor: map['BgColor'] as String?,
      imageName: map['ImageName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Title': title,
      'Subtitle': subtitle,
      'IconCode': iconCode,
      'BgColor': bgColor,
      'ImageName': imageName,
    };
  }
}

class PopularCompanyModel {
  final String name;
  const PopularCompanyModel({required this.name});
}

class RecentSearchModel {
  final String fromCity;
  final String toCity;
  final String dateLabel;
  final int passengerCount;

  const RecentSearchModel({
    required this.fromCity,
    required this.toCity,
    required this.dateLabel,
    required this.passengerCount,
  });
}

class PopularRouteModel {
  final String fromCity;
  final String toCity;
  final String dailyTripsLabel;
  final int startingPrice;

  const PopularRouteModel({
    required this.fromCity,
    required this.toCity,
    required this.dailyTripsLabel,
    required this.startingPrice,
  });
}

class HomeDataModel {
  final List<CategoryModel> categories;
  final List<CityModel> cities;
  final List<CampaignModel> campaigns;
  final List<PopularCompanyModel> companies;
  final List<PopularRouteModel> popularRoutes;

  const HomeDataModel({
    required this.categories,
    required this.cities,
    required this.campaigns,
    required this.companies,
    required this.popularRoutes,
  });
}