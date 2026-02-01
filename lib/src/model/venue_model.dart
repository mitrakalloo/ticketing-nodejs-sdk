import '../util/api_adapter.dart';
import 'base_model.dart';
import 'region_model.dart';

class VenueModel extends BaseModel {
  String name;
  RegionModel region;
  double longitude;
  double latitude;
  String address;
  String map;

  VenueModel(Map<String, dynamic> data, APIAdapter adapter)
      : name = data['name'] as String? ?? '',
        region = RegionModel(data['region'] as Map<String, dynamic>, adapter),
        longitude = (data['longitude'] as num?)?.toDouble() ?? 0.0,
        latitude = (data['latitude'] as num?)?.toDouble() ?? 0.0,
        address = data['address'] as String? ?? '',
        map = data['map'] as String? ?? '',
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'name': name,
      'region': region.id,
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
    };
  }
}
