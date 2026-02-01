import '../util/api_adapter.dart';
import '../model/category_model.dart';
import 'base_service.dart';

class CategoryService extends BaseService<Map<String, dynamic>, CategoryModel> {
  CategoryService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/categories",
          (data, adapter) => CategoryModel(data, adapter),
        );
}
