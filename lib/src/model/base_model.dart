import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/api_adapter.dart';
import '../errors/errors.dart';

abstract class Base {
  String get id;
  String get uri;
  Future<bool> save();
  Future<bool> delete();
  Map<String, dynamic> serialise();
}

class BaseModel implements Base {
  final String _self;
  final APIAdapter _apiAdapter;

  BaseModel(this._self, this._apiAdapter);

  // Protected getter for subclasses to access the API adapter
  APIAdapter get apiAdapter => _apiAdapter;

  @override
  String get id {
    final match = RegExp(r'([A-Za-z0-9\-]+)$').firstMatch(_self);
    return match?.group(1) ?? '';
  }

  @override
  String get uri => _self;

  @override
  Future<bool> save() async {
    try {
      await _apiAdapter.put(_self, serialise());
      return true;
    } catch (e) {
      if (e is TickeTingError) {
        if (e.code == 400) {
          throw BadDataError(e.code, e.message);
        } else if (e.code == 409) {
          throw ResourceExistsError(e.code, e.message);
        }
      }
      rethrow;
    }
  }

  @override
  Future<bool> delete() async {
    try {
      await _apiAdapter.delete(_self);
      return true;
    } catch (e) {
      if (e is TickeTingError && e.code == 409) {
        throw ResourceIndelibleError(e.code, e.message);
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> serialise() {
    return {};
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
