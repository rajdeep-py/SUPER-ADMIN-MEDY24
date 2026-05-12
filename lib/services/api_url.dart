class ApiUrls {
  static const String baseUrl = 'http://127.0.0.1:8000/'; // Standardized with trailing slash

  // Patho Lab Auth Endpoints
  static const String pathoLabSignup = 'auth/patho-lab/signup';
  static const String pathoLabLogin = 'auth/patho-lab/login';
  static const String pathoLabGetAll = 'auth/patho-lab/get-all';
  static const String pathoLabGetById = 'auth/patho-lab/get-by';
  static const String pathoLabUpdateById = 'auth/patho-lab/update-by';
}
