import 'package:catchmflixx/api/auth/auth_manager.dart';
import 'package:catchmflixx/models/user/register/register.response.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
abstract class RegisterResponseState {}

class InitRegister extends RegisterResponseState {}

class LoadingRegister extends RegisterResponseState {}

class LoadedRegister extends RegisterResponseState {
  final RegisterResponse registerResponse;

  LoadedRegister({required this.registerResponse});
}

class ErrorRegister extends RegisterResponseState {
  final String message;
  ErrorRegister({required this.message});
}

class RegisterResponseNotifier extends StateNotifier<RegisterResponseState> {
  RegisterResponseNotifier() : super(InitRegister());

  final APIManager _authHandler = APIManager();

  Future<int> makeRegister(
    String email,
    String? phone_number,
    String name,
    // int? pincode,
    // String? city,
    String password,
    String password2,
    // String? dob
  ) async {
    // String? dobData;
    // if (dob != null && dob.isNotEmpty) {
    //   var dobString = dob.split("/");
    //   if (dobString.length == 3) {
    //     dobData = "${dobString[2]}-${dobString[1]}-${dobString[0]}";
    //   }
    // }

    try {
      state = LoadingRegister();

      RegisterResponse user =
          await _authHandler.useRegister(email, name, password, password2);
      state = LoadedRegister(registerResponse: user);

      if (user.success == true) {
        return 200;
      } else {
        return 400;
      }
    } catch (e) {
      state = ErrorRegister(message: e.toString());
      return 400;
    }
  }
}
