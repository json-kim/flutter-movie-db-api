import 'package:flutter/material.dart';
import 'package:movie_search/config/theme.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/credit/credit.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/presentation/movie_detail/component/sliver_fixed_header.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:provider/provider.dart';

class CreditSliverList extends StatelessWidget {
  const CreditSliverList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Credit, Movie>>();
    final state = viewModel.state;

    return SliverPersistentHeader(
        floating: true,
        delegate: SliverFixedHeader(
          maxHeight: 250,
          minHeight: 250,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: kWhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '배우 / 제작진',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.data.length,
                    itemBuilder: (context, idx) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: state.data[idx].profilePath == null
                                  ? const Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : Image.network(
                                      kProfileUrl +
                                          state.data[idx].profilePath!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            FittedBox(
                              child: Text(
                                state.data[idx].name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                state.data[idx].character,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}