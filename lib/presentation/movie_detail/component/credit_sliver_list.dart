import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/cast/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/component/sliver_fixed_header.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:movie_search/presentation/person_detail/person_detail_screen.dart';
import 'package:movie_search/presentation/person_detail/person_detail_view_model.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

class CreditSliverList extends StatelessWidget {
  const CreditSliverList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Credit, Param>>();
    final state = viewModel.state;

    return SliverPersistentHeader(
        floating: true,
        delegate: SliverFixedHeader(
          maxHeight: 250,
          minHeight: 250,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: whiteColor,
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
                    itemBuilder: (context, idx) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => PersonDetailViewModel(
                                state.data[idx].id,
                                context.read<GetPersonDetailUseCase>(),
                                context.read<GetCastWithPersonUseCase>(),
                                context.read<FindBookmarkDataUseCase<Person>>(),
                                context.read<SaveBookmarkDataUseCase<Person>>(),
                                context
                                    .read<DeleteBookmarkDataUseCase<Person>>(),
                              ),
                              child: const PersonDetailScreen(),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: state.data[idx].profilePath == null
                                    ? Image.asset(
                                        'asset/image/avatar_placeholder.png',
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: kProfileUrl +
                                            state.data[idx].profilePath!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
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
                ),
              ],
            ),
          ),
        ));
  }
}
