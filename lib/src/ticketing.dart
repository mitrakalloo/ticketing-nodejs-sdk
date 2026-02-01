import 'util/api_adapter.dart';
import 'util/session_manager.dart';
import 'service/account_service.dart';
import 'service/category_service.dart';
import 'service/event_service.dart';
import 'service/host_service.dart';
import 'service/preset_service.dart';
import 'service/region_service.dart';
import 'service/venue_service.dart';

/// Main TickeTing SDK class for interacting with the TickeTing API.
///
/// Example:
/// ```dart
/// final ticketing = TickeTing(
///   apiKey: 'YOUR_API_KEY',
///   sandbox: false,
/// );
///
/// // Retrieve a collection of published events
/// final events = await ticketing.events.published.list().call();
/// ```
class TickeTing {
  final APIAdapter _apiAdapter;

  /// Service for managing user accounts
  late final AccountService accounts;

  /// Service for managing event categories
  late final CategoryService categories;

  /// Service for managing events
  late final EventService events;

  /// Service for managing event hosts
  late final HostService hosts;

  /// Service for accessing preset data like countries
  late final PresetService presets;

  /// Service for managing geographical regions
  late final RegionService regions;

  /// Manager for user sessions
  late final SessionManager session;

  /// Service for managing venues
  late final VenueService venues;

  /// Creates a new TickeTing SDK instance.
  ///
  /// [apiKey] - Your TickeTing API key
  /// [sandbox] - Set to true to use the sandbox/QA environment (default: false)
  TickeTing({
    required String apiKey,
    bool sandbox = false,
  }) : _apiAdapter = APIAdapter(apiKey, sandbox: sandbox) {
    session = SessionManager(_apiAdapter);
    accounts = AccountService(_apiAdapter);
    categories = CategoryService(_apiAdapter);
    events = EventService(_apiAdapter);
    hosts = HostService(_apiAdapter);
    presets = PresetService(_apiAdapter);
    regions = RegionService(_apiAdapter);
    venues = VenueService(_apiAdapter);
  }

  /// Get the current API key
  String get apiKey => _apiAdapter.key;

  /// Get the base URL for API requests
  String get baseURL => _apiAdapter.base;

  /// Get the media URL for accessing media assets
  String get mediaURL => _apiAdapter.media;
}
