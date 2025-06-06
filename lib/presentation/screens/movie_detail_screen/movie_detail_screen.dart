import 'package:flutter/material.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final int movieId = widget.movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail - $movieId'),
      ),
      body: Center(
        child: Text(
          'Details for movie ID: $movieId',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
