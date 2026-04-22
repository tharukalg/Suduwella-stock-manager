enum AppFlavor { dev, qa, production }

class AppConfig {
  final AppFlavor flavor;
  final String    baseUrl;
  final String    appName;
  final bool      showDebugBanner;
  final bool      enableLogging;

  const AppConfig._({
    required this.flavor,
    required this.baseUrl,
    required this.appName,
    required this.showDebugBanner,
    required this.enableLogging,
  });

  factory AppConfig.dev() => const AppConfig._(
    flavor:          AppFlavor.dev,
    baseUrl:         'https://dev-api.example.com',
    appName:         'MyApp · DEV',
    showDebugBanner: true,
    enableLogging:   true,
  );

  factory AppConfig.qa() => const AppConfig._(
    flavor:          AppFlavor.qa,
    baseUrl:         'https://qa-api.example.com',
    appName:         'MyApp · QA',
    showDebugBanner: true,
    enableLogging:   true,
  );

  factory AppConfig.production() => const AppConfig._(
    flavor:          AppFlavor.production,
    baseUrl:         'https://api.example.com',
    appName:         'MyApp',
    showDebugBanner: false,
    enableLogging:   false,
  );

  static AppConfig? _instance;

  static AppConfig get instance {
    assert(_instance != null, 'Call AppConfig.init() before use.');
    return _instance!;
  }

  static void init(AppConfig config) => _instance = config;

  bool get isDev        => flavor == AppFlavor.dev;
  bool get isQa         => flavor == AppFlavor.qa;
  bool get isProduction => flavor == AppFlavor.production;

  @override
  String toString() => 'AppConfig(${flavor.name}, $baseUrl)';
}
