import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/home/views/home_view.dart';

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

      if (!isLoggedIn && currentPath == '/home') {
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
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );

  // Auth state her değiştiğinde GoRouter redirect'i tetikler; router yeniden kurulmaz
  ref.listen(authViewModelProvider, (_, __) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
});