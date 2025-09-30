import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:extractorapplication/exception/login_exception.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> loginWithUsernamePassword({
    required String email,
    required String password,
  });
  Future<String> registerWithUsernamePassword({
    required String email,
    required String password,
  });
  Future<String> forgotPasswordWithUsernamePassword({
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> forgotPasswordWithUsernamePassword({required String email}) async {
    // TODO: implement forgotPasswordWithUsernamePassword
    throw UnimplementedError();
    //  try{
    //    supabaseClient.auth.resetPasswordForEmail(email);
    //  } catch(e){
    //
    //  }
  }

  @override
  Future<String> loginWithUsernamePassword({required String email, required String password}) {
    // TODO: implement loginWithUsernamePassword
    throw UnimplementedError();
  }

  @override
  Future<String> registerWithUsernamePassword({required String email, required String password}) async {
    // TODO: implement registerWithUsernamePassword
    try{
      final response = await supabaseClient.auth.signUp(
          email: email,
          password: password,
          data: {'email': email, 'password': password}
      );
      if (response.user  == null) {
        throw const ServerException('Người dùng không tồn tại');
      }

      return response.user!.id;
    }catch (e) {
      throw ServerException(e.toString());
    }
  }
  
}
