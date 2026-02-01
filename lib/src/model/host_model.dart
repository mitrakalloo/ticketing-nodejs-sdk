import '../util/api_adapter.dart';
import 'base_model.dart';

class HostModel extends BaseModel {
  String name;
  String description;
  String? logo;
  String? logoUrl;

  HostModel(Map<String, dynamic> data, APIAdapter adapter)
      : name = data['name'] as String? ?? '',
        description = data['description'] as String? ?? '',
        logo = data['logo'] as String?,
        logoUrl = data['logoUrl'] as String?,
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'name': name,
      'description': description,
      if (logo != null) 'logo': logo,
    };
  }
}
