import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/lab_test/lab_test_list_screen.dart';
import '../screens/patho_lab/patho_lab_list_screen.dart';
import '../screens/patho_lab/patho_lab_details_screen.dart';
import '../screens/patho_lab/create_patho_lab_screen.dart';
import '../screens/lab_test/lab_test_details_screen.dart';
import '../screens/lab_test/create_lab_test_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/medicine/medicine_management_screen.dart';
import '../screens/terms_conditions/terms_conditions_screen.dart';
import '../screens/privacy_policy/privacy_policy_screen.dart';
import '../models/patho_lab.dart';
import '../models/lab_test.dart';
import '../models/pharma_shop.dart';
import '../screens/pharma_shop/pharma_shop_list_screen.dart';
import '../screens/pharma_shop/pharma_shop_details_screen.dart';
import '../screens/customer/customer_list_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String pathoLabList = '/patho-labs';
  static const String pathoLabDetails = '/patho-lab-details';
  static const String createPathoLab = '/create-patho-lab';
  static const String labTestList = '/lab-tests';
  static const String labTestDetails = '/lab-test-details';
  static const String createLabTest = '/create-lab-test';
  static const String aboutUs = '/about-us';
  static const String medicineManagement = '/medicines';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String pharmaShopList = '/pharma-shops';
  static const String pharmaShopDetails = '/pharma-shop-details';
  static const String customerList = '/customers';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
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
      GoRoute(
        path: labTestList,
        builder: (context, state) => const LabTestListScreen(),
      ),
      GoRoute(
        path: labTestDetails,
        builder: (context, state) {
          final test = state.extra as LabTest;
          return LabTestDetailsScreen(test: test);
        },
      ),
      GoRoute(
        path: createLabTest,
        builder: (context, state) => const CreateLabTestScreen(),
      ),
      GoRoute(
        path: aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: medicineManagement,
        builder: (context, state) => const MedicineManagementScreen(),
      ),
      GoRoute(
        path: termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: pharmaShopList,
        builder: (context, state) => const PharmaShopListScreen(),
      ),
      GoRoute(
        path: pharmaShopDetails,
        builder: (context, state) {
          final shop = state.extra as PharmaShop;
          return PharmaShopDetailsScreen(shop: shop);
        },
      ),
      GoRoute(
        path: customerList,
        builder: (context, state) => const CustomerListScreen(),
      ),
    ],
  );
}
