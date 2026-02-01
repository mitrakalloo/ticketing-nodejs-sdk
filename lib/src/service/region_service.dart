import '../util/api_adapter.dart';
import '../model/region_model.dart';
import 'base_service.dart';

class RegionService extends BaseService<Map<String, dynamic>, RegionModel> {
  RegionService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/regions",
          (data, adapter) => RegionModel(data, adapter),
          supportedFilters: ["active"],
        );
}
