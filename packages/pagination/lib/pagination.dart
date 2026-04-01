/// App Library Pagination — Cursor-based pagination models and interfaces.
///
/// Re-exports [PaginatedResult] and [PaginationParams] from core,
/// plus [PaginationState] and [PaginatedRepository].
library;

// Re-export core pagination models for convenience
export 'package:app_lib_core/core.dart'
    show PaginatedResult, PaginationParams;

// Domain
export 'src/domain/paginated_repository.dart';
export 'src/domain/pagination_state.dart';

// Providers
export 'src/providers/pagination_providers.dart';
