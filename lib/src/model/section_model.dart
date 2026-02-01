import '../util/api_adapter.dart';
import 'base_model.dart';

class SectionModel extends BaseModel {
  String name;
  String description;
  Map<String, dynamic> price;
  String salesStart;
  String salesEnd;
  bool active;
  int capacity;
  int sold;
  int remaining;
  int reserved;

  SectionModel(Map<String, dynamic> data, APIAdapter adapter)
      : name = data['name'] as String? ?? '',
        description = data['description'] as String? ?? '',
        price = data['price'] as Map<String, dynamic>? ?? {},
        salesStart = data['salesStart'] as String? ?? '',
        salesEnd = data['salesEnd'] as String? ?? '',
        active = data['active'] as bool? ?? false,
        capacity = data['capacity'] as int? ?? 0,
        sold = data['sold'] as int? ?? 0,
        remaining = data['remaining'] as int? ?? 0,
        reserved = data['reserved'] as int? ?? 0,
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'salesStart': salesStart,
      'salesEnd': salesEnd,
      'active': active,
      'capacity': capacity,
      'sold': sold,
      'remaining': remaining,
      'reserved': reserved,
    };
  }
}
