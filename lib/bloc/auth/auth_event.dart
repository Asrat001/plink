part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class ChangeLogginStatus extends AuthEvent {
  final bool isLoggedIn;

  ChangeLogginStatus({required this.isLoggedIn});
}

final class AuthInit extends AuthEvent {}
