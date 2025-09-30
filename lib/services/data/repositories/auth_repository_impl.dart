import 'package:extractorapplication/exception/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../../../exception/login_exception.dart';
import '../../domain/repository/auth_repository.dart';
import '../server/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository  {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failures, String>> forgotPasswordWithUsernamePassword({required String email}) {
    // TODO: implement forgotPasswordWithUsernamePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, String>> loginWithUsernamePassword({required String email, required String password}) {
    // TODO: implement loginWithUsernamePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, String>> signUpWithUsernamePassword({required String email, required String password}) async{
    // TODO: implement signUpWithUsernamePassword
    try{
      final userId = await authRemoteDataSource.registerWithUsernamePassword(email: email, password: password);

      return right(userId);
    } on ServerException catch(e){
      return left(Failures(e.message));
    }
  }

}