import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class MainShellView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellView({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          backgroundColor: AppColors.surfaceLowest,
          indicatorColor: AppColors.secondaryFixed,
          height: 68,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.onSurfaceVariant),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.secondary),
              label: 'Ana Sayfa',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.confirmation_number_outlined,
                color: AppColors.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.confirmation_number_rounded,
                color: AppColors.secondary,
              ),
              label: 'Biletlerim',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_border_rounded,
                color: AppColors.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: AppColors.secondary,
              ),
              label: 'Favoriler',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: AppColors.onSurfaceVariant),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: AppColors.secondary,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}