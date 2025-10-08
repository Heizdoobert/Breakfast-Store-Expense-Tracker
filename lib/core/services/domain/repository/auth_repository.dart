import 'package:fpdart/fpdart.dart';

import '../../../exception/failures.dart';

abstract interface class AuthRepository{
  Future<Either<Failures, String>> signUpWithUsernamePassword ({
    required String email,
    required String password,
  });

  Future<Either<Failures, String>> loginWithUsernamePassword ({
    required String email,
    required String password,
  });

  Future<Either<Failures, String>> forgotPasswordWithUsernamePassword ({
    required String email,
  });
}