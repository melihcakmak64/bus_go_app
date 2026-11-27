import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../models/home_models.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  IconData _iconForCategory(String iconCode) {
    switch (iconCode) {
      case 'flight':
      case 'flight_takeoff':
        return Icons.flight_rounded;
      case 'hotel':
      case 'bed':
        return Icons.hotel_rounded;
      case 'directions_car':
      case 'car':
        return Icons.directions_car_rounded;
      case 'directions_bus':
      case 'bus':
      default:
        return Icons.directions_bus_rounded;
    }
  }

  Future<void> _showCityPicker({
    required BuildContext context,
    required String title,
    required List<CityModel> cities,
    required ValueChanged<CityModel> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final city = cities[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                      title: Text(
                        city.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      onTap: () {
                        onSelected(city);
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final currentUser = ref.watch(authViewModelProvider).asData?.value;
    final firstName = (currentUser?.firstName.isNotEmpty == true)
        ? currentUser!.firstName
        : 'Burak';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: homeState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.secondaryContainer,
            ),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(homeViewModelProvider.notifier).refresh(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryContainer,
                      foregroundColor: AppColors.onSecondary,
                    ),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            ),
          ),
          data: (ui) {
            final vm = ref.read(homeViewModelProvider.notifier);
            final fromLabel = ui.fromCity?.displayName ?? 'İstanbul (Esenler)';
            final toLabel = ui.toCity?.displayName ?? 'Ankara (AŞTİ)';

            return RefreshIndicator(
              color: AppColors.secondaryContainer,
              onRefresh: vm.refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  // Top Header
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: AppColors.onSecondary,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BusGo',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Ana Sayfa',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 22,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.secondaryFixed,
                          child: Text(
                            firstName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Greeting & Loyalty Points Pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Merhaba, $firstName 👋',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Bugün nereye gitmek istersin?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.4,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ui.loyaltyPoints} Puan',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Categories (Category table from SQLite)
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ui.data.categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final cat = ui.data.categories[index];
                        final isSelected = cat.id == ui.selectedCategoryId;
                        return InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => vm.selectCategory(cat.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondaryContainer
                                  : AppColors.surfaceLowest,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _iconForCategory(cat.iconCode),
                                  size: 18,
                                  color: isSelected
                                      ? AppColors.onSecondary
                                      : AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.onSecondary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Column(
                              children: [
                                _StationField(
                                  label: 'NEREDEN',
                                  value: fromLabel,
                                  icon: Icons.trip_origin_rounded,
                                  iconColor: AppColors.secondary,
                                  onTap: () => _showCityPicker(
                                    context: context,
                                    title: 'Kalkış Noktası Seçin',
                                    cities: ui.data.cities,
                                    onSelected: vm.setFromCity,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _StationField(
                                  label: 'NEREYE',
                                  value: toLabel,
                                  icon: Icons.location_on_rounded,
                                  iconColor: AppColors.onSurface,
                                  onTap: () => _showCityPicker(
                                    context: context,
                                    title: 'Varış Noktası Seçin',
                                    cities: ui.data.cities,
                                    onSelected: vm.setToCity,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 14,
                              child: Material(
                                color: AppColors.secondaryContainer,
                                shape: const CircleBorder(),
                                elevation: 3,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: vm.swapCities,
                                  child: const SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Icon(
                                      Icons.swap_vert_rounded,
                                      size: 20,
                                      color: AppColors.onSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Date & Passenger Grid
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_rounded,
                                          size: 15,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'GİDİŞ TARİHİ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ui.departureDateLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _DateChip(
                                          label: 'Bugün',
                                          onTap: () =>
                                              vm.setDatePreset('Bugün'),
                                        ),
                                        const SizedBox(width: 6),
                                        _DateChip(
                                          label: 'Yarın',
                                          onTap: () =>
                                              vm.setDatePreset('Yarın'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: vm.cyclePassengerCount,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            size: 16,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'YOLCU SAYISI',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.4,
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${ui.passengerCount} Yolcu',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        ui.passengerTypeLabel,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Bilet Ara CTA
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$fromLabel → $toLabel (${ui.departureDateLabel}, ${ui.passengerCount} Yolcu)',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryContainer,
                              foregroundColor: AppColors.onSecondary,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Bilet Ara',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Popüler Firmalar (Statik)
                  const Text(
                    'POPÜLER FİRMALAR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ui.data.companies.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final company = ui.data.companies[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                size: 15,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                company.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Campaign Banners (Campaign table from SQLite)
                  if (ui.data.campaigns.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: ui.data.campaigns.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (_, index) {
                          final campaign = ui.data.campaigns[index];
                          return _CampaignCard(
                            campaign: campaign,
                            onTap: () {
                              vm.selectCampaign(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    campaign.subtitle ?? campaign.title,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 18),

                  // Popüler Rotalar (Statik)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popüler Rotalar',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'Tümünü Gör',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ui.data.popularRoutes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.4,
                        ),
                    itemBuilder: (_, index) {
                      final route = ui.data.popularRoutes[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${route.fromCity} → ${route.toCity}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  route.dailyTripsLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BAŞLANGIÇ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${route.startingPrice} TL',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  // %100 Güvenli Ödeme & İptal
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            size: 22,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '%100 Güvenli Ödeme & İptal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Kesintisiz iade güvencesi ve 7/24 canlı destek.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onTap;

  const _CampaignCard({required this.campaign, required this.onTap});

  Color _parseColor(String? hex, Color fallback) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    final cleaned = hex.trim().replaceFirst('#', '');
    final value = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    final parsed = int.tryParse(value, radix: 16);
    return parsed != null ? Color(parsed) : fallback;
  }

  @override
  Widget build(BuildContext context) {
    final startColor = _parseColor(
      campaign.bgColor,
      AppColors.secondaryContainer,
    );
    final hasImage =
        campaign.imageName != null && campaign.imageName!.trim().isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 320,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [startColor, AppColors.secondary]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              Image.asset(
                'assets/images/${campaign.imageName!.trim()}',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.black.withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    campaign.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSecondary,
                    ),
                  ),
                  if (campaign.subtitle != null &&
                      campaign.subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      campaign.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _StationField({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 52, 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.surfaceHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surfaceHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
