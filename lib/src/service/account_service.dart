import '../util/api_adapter.dart';
import '../model/account_model.dart';
import 'base_service.dart';

class AccountService extends BaseService<Map<String, dynamic>, AccountModel> {
  AccountService(APIAdapter apiAdapter)
      : super(
          apiAdapter,
          "/accounts",
          (data, adapter) => AccountModel(data, adapter),
        );
}
