// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_hive/models/movie.dart';
import 'package:movie_hive/views/add_new_moview.dart';

class MovieHomePageView extends StatefulWidget {
  const MovieHomePageView({Key? key}) : super(key: key);

  @override
  _MovieHomePageViewState createState() => _MovieHomePageViewState();
}

class _MovieHomePageViewState extends State<MovieHomePageView> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: Hive.openBox<Movie>("movies"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return ValueListenableBuilder(
                valueListenable: Hive.box<Movie>("movies").listenable(),
                builder: (context, Box<Movie> box, _) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 120.0,
                        toolbarHeight: 100.0,
                        floating: true,
                        shadowColor: Colors.transparent,
                        title: Text("Movies List"),
                        textTheme: TextTheme(
                          headline6: TextStyle(
                            color: Color(0xFF4E5B60),
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      box.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "No Movies found!",
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Add a new movie by clicking on the '+' icon ",
                                        textScaleFactor: 1.2,
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverFixedExtentList(
                              itemExtent: 200.0,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  Movie movie = box.getAt(index) as Movie;
                                  return _buildListItem(movie, index);
                                },
                                childCount: box.values.length,
                              ),
                            ),
                    ],
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          heroTag: "add-new-movie",
          backgroundColor: Colors.red.shade400,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return AddNewMovieView();
                },
              ),
            );
          },
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Movie movie, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 120,
                  height: MediaQuery.of(context).size.height,
                  child: movie.moviePoster == null
                      ? Image.asset(
                          'assets/no-image.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          new File(movie.moviePoster!),
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 25.0, 8.0, 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.movieName,
                          textScaleFactor: 2.2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          movie.movieDirector,
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey.shade700),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
