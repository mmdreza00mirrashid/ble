// base exception
import 'package:ble/Exceptions/CustomException.dart';

class AuthException extends CustomException {
  AuthException({required super.message, String? super.statusCode});

  @override
  String toString() {
    return 'AuthException: $message';
  }
}

class EmptyFieldsException extends AuthException {
  EmptyFieldsException({required super.message});
}

// login exceptions
class UserNotFoundAuthException extends AuthException {
  UserNotFoundAuthException({required super.message});
}

class WrongPasswordAuthException extends AuthException {
  WrongPasswordAuthException({required super.message});
}

// register exceptions

class WeakPasswordAuthException extends AuthException {
  WeakPasswordAuthException({required super.message});
}

class IdAlreadyInUseAuthException extends AuthException {
  IdAlreadyInUseAuthException({required super.message});
}

class InvalidIdAuthException extends AuthException {
  InvalidIdAuthException({required super.message});
}
