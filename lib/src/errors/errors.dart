class TickeTingError implements Exception {
  final int code;
  final String message;

  TickeTingError(this.code, this.message);

  @override
  String toString() => 'TickeTingError($code): $message';
}

class BadDataError extends TickeTingError {
  BadDataError(super.code, super.message);

  @override
  String toString() => 'BadDataError($code): $message';
}

class InvalidStateError extends TickeTingError {
  InvalidStateError(super.code, super.message);

  @override
  String toString() => 'InvalidStateError($code): $message';
}

class PageAccessError extends TickeTingError {
  PageAccessError(super.code, super.message);

  @override
  String toString() => 'PageAccessError($code): $message';
}

class PermissionError extends TickeTingError {
  PermissionError(super.code, super.message);

  @override
  String toString() => 'PermissionError($code): $message';
}

class ResourceExistsError extends TickeTingError {
  ResourceExistsError(super.code, super.message);

  @override
  String toString() => 'ResourceExistsError($code): $message';
}

class ResourceImmutableError extends TickeTingError {
  ResourceImmutableError(super.code, super.message);

  @override
  String toString() => 'ResourceImmutableError($code): $message';
}

class ResourceIndelibleError extends TickeTingError {
  ResourceIndelibleError(super.code, super.message);

  @override
  String toString() => 'ResourceIndelibleError($code): $message';
}

class ResourceNotFoundError extends TickeTingError {
  ResourceNotFoundError(super.code, super.message);

  @override
  String toString() => 'ResourceNotFoundError($code): $message';
}

class UnauthorisedError extends TickeTingError {
  UnauthorisedError(super.code, super.message);

  @override
  String toString() => 'UnauthorisedError($code): $message';
}

class UnsupportedCriteriaError extends TickeTingError {
  UnsupportedCriteriaError(super.code, super.message);

  @override
  String toString() => 'UnsupportedCriteriaError($code): $message';
}

class UnsupportedOperationError extends TickeTingError {
  UnsupportedOperationError(super.code, super.message);

  @override
  String toString() => 'UnsupportedOperationError($code): $message';
}

class UnsupportedSortError extends TickeTingError {
  UnsupportedSortError(super.code, super.message);

  @override
  String toString() => 'UnsupportedSortError($code): $message';
}
