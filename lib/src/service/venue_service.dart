import '../util/api_adapter.dart';
import '../model/venue_model.dart';
import 'base_service.dart';

class VenueService extends BaseService<Map<String, dynamic>, VenueModel> {
  VenueService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/venues",
          (data, adapter) => VenueModel(data, adapter),
        );
}
