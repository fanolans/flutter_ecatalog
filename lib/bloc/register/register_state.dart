part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisteLoaded extends RegisterState {
  final RegisterResponseModel model;
  RegisteLoaded({
    required this.model,
  });
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError({
    required this.message,
  });
}
