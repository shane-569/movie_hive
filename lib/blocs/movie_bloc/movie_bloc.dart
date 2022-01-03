import 'dart:async';

import 'package:hive/hive.dart';
import 'package:movie_hive/blocs/movie_bloc/movie_event.dart';
import 'package:movie_hive/models/movie.dart';

class MovieBloc {
  final _movieEventController = StreamController<MovieEvent>();
  Sink<MovieEvent> get movieEventSink => _movieEventController.sink;

  MovieBloc() {
    _movieEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MovieEvent event) {
    if (event is AddNewMovie) {
      _handleAddNewMovie(event.props);
    } else if (event is EditMovie) {
      _handleEditMovie(event.props);
    } else if (event is DeleteMovie) {
      _handleDeleteMovie(event.props);
    }
  }

  Future<void> _handleAddNewMovie(Movie movie) async {
    final box = Hive.box<Movie>("movies-${movie.id}");
    if (!box.containsKey(movie.movieName.toLowerCase())) {
      await box.put(movie.movieName.toLowerCase(), movie);
    }
  }

  Future<void> _handleEditMovie(Map<String, dynamic> props) async {
    Movie movie = props['movie'];
    int index = props['index'];

    final box = Hive.box<Movie>("movies-${movie.id}");
    await box.putAt(index, movie);
  }

  Future<void> _handleDeleteMovie(Map<String, dynamic> props) async {
    Movie movie = props['movie'];
    int index = props['index'];

    final box = Hive.box<Movie>("movies-${movie.id}");
    await box.deleteAt(index);
  }

  void dispose() {
    _movieEventController.close();
  }
}
