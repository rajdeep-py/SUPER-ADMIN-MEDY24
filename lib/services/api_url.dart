class ApiUrls {
  static const String baseUrl = 'http://127.0.0.1:8000/'; // Standardized with trailing slash

  // Patho Lab Auth Endpoints
  static const String pathoLabSignup = 'auth/patho-lab/signup';
  static const String pathoLabLogin = 'auth/patho-lab/login';
  static const String pathoLabGetAll = 'auth/patho-lab/get-all';
  static const String pathoLabGetById = 'auth/patho-lab/get-by';
  static const String pathoLabUpdateById = 'auth/patho-lab/update-by';

  // Core Lab Test Endpoints
  static const String coreTestCreate = 'core-tests/create';
  static const String coreTestGetAll = 'core-tests/get-all';
  static const String coreTestGetById = 'core-tests/get-by';
  static const String coreTestUpdateById = 'core-tests/update-by';
  static const String coreTestDeleteByIds = 'core-tests/delete-by-ids';

  // About Us Endpoints
  static const String aboutUsCreate = 'about-us/create';
  static const String aboutUsGetAll = 'about-us/get-all';
  static const String aboutUsGetById = 'about-us/get-by';
  static const String aboutUsUpdateById = 'about-us/update-by';
  static const String aboutUsDeleteById = 'about-us/delete-by';
}
