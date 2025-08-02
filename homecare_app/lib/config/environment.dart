import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiBaseUrl {
    return dotenv.env['FLUTTER_HOMECARE_APP_API_BASE_URL'] ?? 'http://localhost:8000';
  }

  static bool get isDebugMode {
    return dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  }

  static int get apiTimeoutSeconds {
    final timeout = dotenv.env['API_TIMEOUT_SECONDS'];
    return int.tryParse(timeout ?? '10') ?? 10;
  }

  static Duration get apiTimeout {
    return Duration(seconds: apiTimeoutSeconds);
  }
}