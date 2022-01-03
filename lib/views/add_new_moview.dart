// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_hive/blocs/movie_bloc/movie_bloc.dart';
import 'package:movie_hive/blocs/movie_bloc/movie_event.dart';
import 'package:movie_hive/models/movie.dart';
import 'package:path_provider/path_provider.dart';

class AddNewMovieView extends StatefulWidget {
  const AddNewMovieView({Key? key}) : super(key: key);

  @override
  _AddNewMovieViewState createState() => _AddNewMovieViewState();
}

class _AddNewMovieViewState extends State<AddNewMovieView> {
  final _movieBloc = new MovieBloc();
  TextEditingController movieNameTextEditingController =
      new TextEditingController();
  TextEditingController movieDirTextEditingController =
      new TextEditingController();

  String? _moviePoster;
  var rng;
  @override
  void initState() {
    rng = new Random().nextInt(100);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // Hero inside Form is a workaround for: https://github.com/flutter/flutter/issues/49952
                child: Hero(
                  tag: "add-new-movie",
                  child: Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () {
                              _getImage();
                            },
                            child: Container(
                              width: 160.0,
                              height: 230.0,
                              child: _moviePoster == null
                                  ? Image.asset(
                                      'assets/images/movie.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      new File(_moviePoster!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          TextFormField(
                            maxLength: 100,
                            style: TextStyle(fontSize: 22.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Movie Name',
                            ),
                            controller: movieNameTextEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            maxLength: 80,
                            style: TextStyle(fontSize: 22.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Movie Director',
                            ),
                            controller: movieDirTextEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              _handleOnSubmit();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green.shade700,
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    Directory _movieImageDir = Directory(_directory.path + "/.images");

    if (!(await _movieImageDir.exists())) {
      await _movieImageDir.create();
    }

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File oldFile = File(result.files.single.path!);
      String fileName = result.files.single.name; // With Extension

      // Move file from cache to Application Directory.
      final newFile = await oldFile.copy(_movieImageDir.path + "/" + fileName);
      setState(() {
        _moviePoster = newFile.path;
      });
    }
  }

  void _handleOnSubmit() {
    Movie movie = new Movie(
      id: rng.toString(),
      movieName: movieNameTextEditingController.text.toString(),
      movieDirector: movieDirTextEditingController.text.toString(),
      moviePoster: _moviePoster,
    );

    _movieBloc.movieEventSink.add(AddNewMovie(movie: movie));

    final snackBar =
        SnackBar(content: Text('New movie added successfully!  $movie'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }
}
