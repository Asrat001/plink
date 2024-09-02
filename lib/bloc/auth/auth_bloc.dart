import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/core/utils/settings.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(AuthState(
          isLoggedIn: false,
        )) {
    on<ChangeLogginStatus>(_onChangeLogginStatus);
    on<AuthInit>(_onAuthInit);
  }

  _onAuthInit(AuthInit event, Emitter emit) async {
    final loggedIn = await isLoggedIn();
    emit(
      state.copyWith(
        isLoggedIn: loggedIn,
      ),
    );
  }

  _onChangeLogginStatus(ChangeLogginStatus event, Emitter emit) async {
    emit(
      state.copyWith(
        isLoggedIn: event.isLoggedIn,
      ),
    );
    setLogginStatus(event.isLoggedIn);
  }
}
