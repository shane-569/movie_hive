// ignore_for_file: unnecessary_this

import 'package:movie_hive/models/movie.dart';

abstract class MovieEvent {}

class AddNewMovie extends MovieEvent {
  final Movie movie;
  AddNewMovie({required this.movie});
  Movie get props => this.movie;
}

class EditMovie extends MovieEvent {
  final Movie movie;
  final int index;
  EditMovie({required this.movie, required this.index});
  Map<String, dynamic> get props => {"movie": this.movie, "index": this.index};
}

class DeleteMovie extends MovieEvent {
  final Movie movie;
  final int index;
  DeleteMovie({required this.movie, required this.index});
  Map<String, dynamic> get props => {"movie": this.movie, "index": this.index};
}
