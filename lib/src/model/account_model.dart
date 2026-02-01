import 'dart:convert';
import '../util/api_adapter.dart';
import 'base_model.dart';

class AccountPreferencesModel extends BaseModel {
  bool notifyByEmail;
  bool notifySms;

  AccountPreferencesModel(
    String self,
    Map<String, dynamic> data,
    APIAdapter adapter,
  )   : notifyByEmail = data['notifyByEmail'] as bool? ?? false,
        notifySms = data['notifySms'] as bool? ?? false,
        super(self, adapter);

  @override
  Map<String, dynamic> serialise() {
    return {
      'notifyByEmail': notifyByEmail,
      'notifySms': notifySms,
    };
  }
}

class AccountModel extends BaseModel {
  String number;
  String username;
  String email;
  String role;
  bool verified;
  bool activated;
  String firstName;
  String lastName;
  String title;
  String dateOfBirth;
  String phone;
  String country;
  String firstAddressLine;
  String secondAddressLine;
  String city;
  String state;

  final String _preferencesUri;

  AccountModel(Map<String, dynamic> data, APIAdapter adapter)
      : number = data['number'] as String? ?? '',
        username = data['username'] as String? ?? '',
        email = data['email'] as String? ?? '',
        role = data['role'] as String? ?? '',
        verified = data['verified'] as bool? ?? false,
        activated = data['activated'] as bool? ?? false,
        firstName = data['firstName'] as String? ?? '',
        lastName = data['lastName'] as String? ?? '',
        title = data['title'] as String? ?? '',
        dateOfBirth = data['dateOfBirth'] as String? ?? '',
        phone = data['phone'] as String? ?? '',
        country = data['country'] as String? ?? '',
        firstAddressLine = data['firstAddressLine'] as String? ?? '',
        secondAddressLine = data['secondAddressLine'] as String? ?? '',
        city = data['city'] as String? ?? '',
        state = data['state'] as String? ?? '',
        _preferencesUri = data['preferences'] as String? ?? '',
        super(data['self'] as String, adapter);

  Future<AccountPreferencesModel> get preferences async {
    final response = await _apiAdapter.get(_preferencesUri);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AccountPreferencesModel(_preferencesUri, data, _apiAdapter);
  }

  @override
  Map<String, dynamic> serialise() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'country': country,
      'firstAddressLine': firstAddressLine,
      'secondAddressLine': secondAddressLine,
      'city': city,
      'state': state,
    };
  }
}
