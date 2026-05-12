import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/patho_lab/patho_lab_list_screen.dart';
import '../screens/patho_lab/patho_lab_details_screen.dart';
import '../screens/patho_lab/create_patho_lab_screen.dart';
import '../models/patho_lab.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String pathoLabList = '/patho-labs';
  static const String pathoLabDetails = '/patho-lab-details';
  static const String createPathoLab = '/create-patho-lab';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: pathoLabList,
        builder: (context, state) => const PathoLabListScreen(),
      ),
      GoRoute(
        path: pathoLabDetails,
        builder: (context, state) {
          final lab = state.extra as PathoLab;
          return PathoLabDetailsScreen(lab: lab);
        },
      ),
      GoRoute(
        path: createPathoLab,
        builder: (context, state) => const CreatePathoLabScreen(),
      ),
    ],
  );
}
