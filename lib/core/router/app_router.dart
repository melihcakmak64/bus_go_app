import 'package:bus_go/features/favorites/views/favorites_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/main_shell_view.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/tickets/views/tickets_view.dart';

const _protectedPaths = {'/home', '/tickets', '/favorites', '/profile'};

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      if (authState.isLoading) return null;

      final isLoggedIn = authState.asData?.value != null;
      final currentPath = state.matchedLocation;
      final isAuthRoute = currentPath == '/login' || currentPath == '/register';

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      if (!isLoggedIn && _protectedPaths.contains(currentPath)) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tickets',
                name: 'tickets',
                builder: (context, state) => const TicketsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.listen(authViewModelProvider, (_, _) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
});