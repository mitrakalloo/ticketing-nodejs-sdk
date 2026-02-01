# Changelog

## [3.1.2] - Dart Package Conversion

### Added
- Complete Dart package implementation of the TickeTing SDK
- Flutter compatibility for mobile app development
- Comprehensive README for Dart/Flutter usage (README_DART.md)
- Example Dart application demonstrating SDK usage
- Full API support including:
  - Event management (list, filter, sort, find)
  - Category management
  - Venue management
  - Host management
  - Region management
  - Account management
  - Session management (authentication)
  - Preset services (countries, etc.)
- Collection-based pagination with async support
- Complete error handling with custom exception types
- Type-safe models for all API resources
- Dart-idiomatic async/await patterns

### Changed
- Converted from TypeScript/Node.js to Dart
- Replaced Axios with native Dart `http` package
- Adapted Promise-based patterns to Dart Futures
- Updated all models to use Dart classes with null safety
- Modified Collection class to work with Dart's type system

### Technical Details
- Uses Dart 3.0+ with null safety
- Compatible with Flutter SDK
- HTTP client with configurable timeouts
- Sandbox mode support for testing
- API version: v3

### Migration from Node.js
If you're migrating from the Node.js SDK:
- Replace `npm install` with `dart pub get` or `flutter pub get`
- Change `import` statements to Dart package imports
- Replace `.then()` promises with `await` syntax
- Update error handling to use Dart exceptions
- See README_DART.md for complete usage examples
