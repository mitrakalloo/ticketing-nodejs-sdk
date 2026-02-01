import '../util/api_adapter.dart';
import 'base_model.dart';

class CategoryModel extends BaseModel {
  String name;
  List<String> subcategories;

  CategoryModel(Map<String, dynamic> data, APIAdapter adapter)
      : name = data['name'] as String? ?? '',
        subcategories = (data['subcategories'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        super(data['self'] as String, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'name': name,
      'subcategories': subcategories,
    };
  }
}
