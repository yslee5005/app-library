/// App Library Core — Pure Dart foundation with zero dependencies.
///
/// Provides error hierarchy, Result type, pagination models, and constants.
library;

// Errors
export 'src/errors/app_exception.dart';

// Models
export 'src/models/paginated_result.dart';

// Utils
export 'src/utils/result.dart';

// Constants
export 'src/constants/app_constants.dart';

// Environment
export 'src/environment/app_environment.dart';
export 'src/environment/env_validator.dart';
export 'src/environment/screen_size.dart';

// Feature Flags
export 'src/feature_flags/feature_flag.dart';

// Network
export 'src/network/network_checker.dart';
