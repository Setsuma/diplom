part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class MapLoading extends HomeState {}

class MapLoaded extends HomeState {}

class MapError extends HomeState {
  final String message;

  MapError(this.message);
}
