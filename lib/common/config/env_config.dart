enum Environment {
  dev,
  stg,
  prod;

  static Environment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dev':
        return Environment.dev;
      case 'stg':
        return Environment.stg;
      case 'prod':
        return Environment.prod;
      default:
        throw Exception('Unknown environment: $value');
    }
  }
}

class EnvironmentConfig {
  final String appTitle;
  final String baseUrl;
  final String apiKey;
  final Environment environment;

  EnvironmentConfig({
    required this.appTitle,
    required this.baseUrl,
    required this.apiKey,
    required this.environment,
  });

  static EnvironmentConfig? _instance;

  static EnvironmentConfig get instance {
    _instance ??= _initConfig();
    return _instance!;
  }

  static EnvironmentConfig _initConfig() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final environment = Environment.fromString(flavor);

    switch (environment) {
      case Environment.prod:
        return EnvironmentConfig(
          appTitle: 'SwiftSwap',
          environment: Environment.prod,
          baseUrl: 'https://mdihobackend.onrender.com/v1/',
          apiKey: 'prod-api-key',
        );
      case Environment.stg:
        return EnvironmentConfig(
          appTitle: 'SwiftSwap Staging',
          environment: Environment.stg,
          baseUrl: 'https://mdihobackend.onrender.com/v1/',
          apiKey: 'stg-api-key',
        );
      default: // dev

        return EnvironmentConfig(
          appTitle: 'SwiftSwap Dev',
          environment: Environment.dev,
          baseUrl: 'https://mdihobackend.onrender.com/v1/',
          apiKey: 'dev-api-key',
        );
    }
  }

  bool get isDevelopment => environment == Environment.dev;
  bool get isStaging => environment == Environment.stg;
  bool get isProduction => environment == Environment.prod;
}
