import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadMap>(_onLoadMap);
  }

  void _onLoadMap(LoadMap event, Emitter<HomeState> emit) async {
    emit(MapLoading());
    try {
      // Имитация загрузки карты
      await Future.delayed(const Duration(seconds: 2));
      emit(MapLoaded());
    } catch (e) {
      emit(MapError('Не удалось загрузить карту'));
    }
  }
}
