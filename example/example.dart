import 'package:ticketing_sdk/ticketing_sdk.dart';

Future<void> main() async {
  // Initialize the TickeTing SDK with your API key
  final ticketing = TickeTing(
    apiKey: 'YOUR_API_KEY',
    sandbox: false, // Set to true for testing in sandbox mode
  );

  print('TickeTing Dart SDK Example');
  print('Base URL: ${ticketing.baseURL}');
  print('');

  try {
    // Example 1: List published events
    print('Fetching published events...');
    final eventsCollection = ticketing.events.published.list(pageLength: 10);
    final events = await eventsCollection();

    print('Found ${events.length} published events:');
    for (final event in events) {
      print('- ${event.title}');
      print('  Status: ${event.status}');
      print('  Start: ${event.start}');
      print('  Venue: ${event.venue.name}');
      print('');
    }

    // Example 2: Filter events by region
    print('\nFiltering events by region...');
    final filteredCollection = ticketing.events.published
        .list(pageLength: 5)
        .filter({'region': 'some-region-id'});
    final filteredEvents = await filteredCollection();
    print('Found ${filteredEvents.length} events in the specified region.');

    // Example 3: Sort events
    print('\nSorting events by start date...');
    final sortedCollection = ticketing.events.published
        .list(pageLength: 5)
        .sort('start', ascending: true);
    final sortedEvents = await sortedCollection();
    print('Retrieved ${sortedEvents.length} sorted events.');

    // Example 4: Get event details by ID
    // print('\nFetching specific event...');
    // final event = await ticketing.events.find('event-id');
    // print('Event: ${event.title}');
    // print('Description: ${event.description}');

    // Example 5: List categories
    print('\nFetching categories...');
    final categoriesCollection = ticketing.categories.list();
    final categories = await categoriesCollection();
    print('Available categories:');
    for (final category in categories) {
      print('- ${category.name}');
    }

    // Example 6: Working with sessions
    print('\nSession Management Example:');
    print('Session active: ${ticketing.session.active}');

    // To start a session (uncomment and provide credentials):
    // final sessionKey = await ticketing.session.start({
    //   'username': 'your-username',
    //   'password': 'your-password',
    // });
    // print('Session started with key: $sessionKey');

    // To resume a session:
    // await ticketing.session.resume('session-key');

    // To end a session:
    // await ticketing.session.end();

  } catch (e) {
    if (e is TickeTingError) {
      print('TickeTing API Error: ${e.toString()}');
    } else {
      print('Error: $e');
    }
  }
}
