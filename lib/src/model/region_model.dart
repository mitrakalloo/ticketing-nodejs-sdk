import '../util/api_adapter.dart';
import 'base_model.dart';

class RegionModel extends BaseModel {
  String name;
  String country;

  RegionModel(Map<String, dynamic> data, APIAdapter adapter)
      : name = data['name'] as String? ?? '',
        country = data['country'] as String? ?? '',
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'name': name,
      'country': country,
    };
  }
}
