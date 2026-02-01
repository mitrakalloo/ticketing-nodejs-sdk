import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/api_adapter.dart';
import '../util/collection.dart';
import '../errors/errors.dart';
import '../model/base_model.dart';

typedef ModelConstructor<T> = T Function(Map<String, dynamic>, APIAdapter);

class BaseService<RequestType, ResponseType extends BaseModel> {
  final APIAdapter _adapter;
  final String _baseUrl;
  final ModelConstructor<ResponseType> _modelConstructor;

  final List<String> _listFilters;
  final List<String> _listSortFields;
  Map<String, dynamic> _listCriteria = {};
  Map<String, dynamic> _listResult = {
    'entries': <ResponseType>[],
    'page': 0,
    'records': 0,
    'total': 0,
  };

  late Collection<ResponseType> _listCollection;

  BaseService(
    this._adapter,
    this._baseUrl,
    this._modelConstructor, {
    List<String> supportedFilters = const [],
    List<String> supportedSortFields = const [],
  })  : _listFilters = ['page', 'records', 'sort', 'order', ...supportedFilters],
        _listSortFields = supportedSortFields {
    _listCollection = Collection<ResponseType>(() => Future.value([]));
  }

  Future<ResponseType> create(Map<String, dynamic> data) async {
    try {
      final response = await _adapter.post(_baseUrl, data);
      
      // Increment resource list total
      _listResult['total'] = (_listResult['total'] as int) + 1;

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return _instantiateModel(responseData);
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

  Future<List<ResponseType>> batchCreate(List<Map<String, dynamic>> data) async {
    try {
      final response = await _adapter.post(_baseUrl, {'batch': data});
      final responseData = jsonDecode(response.body) as List;
      
      final results = <ResponseType>[];
      for (final entry in responseData) {
        results.add(_instantiateModel(entry as Map<String, dynamic>));
      }
      
      return results;
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

  Collection<ResponseType> list({int pageLength = 25}) {
    _listCriteria['records'] = pageLength;
    _listCollection = Collection<ResponseType>(_listQuery);

    _listCollection.onCurrent(() => _listResult['page'] as int);
    _listCollection.onPages(() {
      final total = _listResult['total'] as int;
      final records = _listResult['records'] as int;
      return (total / records).ceil();
    });

    _listCollection.onFilter((criteria) {
      for (final entry in criteria.entries) {
        if (!_listCriteria.containsKey(entry.key)) {
          _listCriteria[entry.key] = entry.value;
        }
      }
    });

    _listCollection.onSort((field, order) {
      _listCriteria['sort'] = field;
      _listCriteria['order'] = order;
    });

    _listCollection.onPageChange((page) {
      if (!_listCriteria.containsKey('page')) {
        _listCriteria['page'] = page;
      }
    });

    _listCollection.onReset(() {
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};
    });

    return _listCollection;
  }

  Future<ResponseType> find(dynamic id) async {
    try {
      final response = await _adapter.get('$_baseUrl/$id');
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return _instantiateModel(responseData);
    } catch (e) {
      if (e is TickeTingError && e.code == 404) {
        throw ResourceNotFoundError(e.code, e.message);
      }
      rethrow;
    }
  }

  ResponseType _instantiateModel(Map<String, dynamic> data) {
    return _modelConstructor(data, _adapter);
  }

  Future<List<ResponseType>> _listQuery() async {
    // Validate list criteria before sending query
    if (_listCriteria.containsKey('page') && (_listCriteria['page'] as int) < 1) {
      // Reset list criteria
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};
      
      throw PageAccessError(404, "Please specify a positive integer page number");
    }

    final unsupportedFilters = <String>[];
    for (final field in _listCriteria.keys) {
      if (!_listFilters.contains(field)) {
        unsupportedFilters.add(field);
      }
    }

    if (unsupportedFilters.isNotEmpty) {
      // Reset list criteria
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};
      
      throw UnsupportedCriteriaError(
        400,
        'The collection does not support the following filters: ${unsupportedFilters.join(", ")}.',
      );
    }

    if (_listCriteria.containsKey('sort') &&
        !_listSortFields.contains(_listCriteria['sort'])) {
      // Reset list criteria
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};
      
      throw UnsupportedSortError(
        400,
        'The collection cannot be sorted by ${_listCriteria['sort']}.',
      );
    }

    try {
      final response = await _adapter.get(_baseUrl, _listCriteria);
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Clear List Criteria
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};

      _listResult['page'] = responseData['page'] as int;
      _listResult['records'] = responseData['records'] as int;
      _listResult['total'] = responseData['total'] as int;

      final entries = <ResponseType>[];
      for (final entry in responseData['entries'] as List) {
        entries.add(_instantiateModel(entry as Map<String, dynamic>));
      }

      _listResult['entries'] = entries;
      return entries;
    } catch (e) {
      // Clear List Criteria
      final records = _listCriteria['records'];
      _listCriteria = {'records': records};

      if (e is TickeTingError && e.code == 404) {
        throw PageAccessError(e.code, e.message);
      }
      rethrow;
    }
  }
}
