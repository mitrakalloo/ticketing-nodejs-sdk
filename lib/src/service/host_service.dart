import '../util/api_adapter.dart';
import '../model/host_model.dart';
import 'base_service.dart';

class HostService extends BaseService<Map<String, dynamic>, HostModel> {
  HostService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/hosts",
          (data, adapter) => HostModel(data, adapter),
          supportedFilters: ["account"],
        );
}
