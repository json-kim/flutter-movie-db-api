import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:movie_search/presentation/review_edit/review_edit_event.dart';
import 'package:provider/provider.dart';

import 'review_edit_view_model.dart';

class ReviewEditScreen extends StatefulWidget {
  const ReviewEditScreen({Key? key}) : super(key: key);

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  final _textEditingController = TextEditingController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<ReviewEditViewModel>();
      final state = viewModel.state;
      _textEditingController.text = state.content;

      _subscription = viewModel.uiEventStream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReviewEditViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.movieTitle),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.clear)),
        actions: [
          if (!state.isEditMode)
            IconButton(
              onPressed: () {
                viewModel.onEvent(ReviewEditEvent.shareReview());
              },
              icon: Icon(Icons.share),
            ),
          state.isEditMode
              ? IconButton(
                  onPressed: () {
                    final String content = _textEditingController.text;
                    viewModel.onEvent(ReviewEditEvent.saveReview(content));
                  },
                  icon: const Icon(Icons.save))
              : IconButton(
                  onPressed: () {
                    viewModel.onEvent(const ReviewEditEvent.changeMode(true));
                  },
                  icon: const Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ?????? ??????
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('?????? ??????'),
                TextButton(
                    onPressed: state.isEditMode
                        ? () async {
                            final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2022, 12, 31));

                            if (pickedDate != null) {
                              viewModel
                                  .onEvent(ReviewEditEvent.setDate(pickedDate));
                            }
                          }
                        : null,
                    child: Text(
                      DateFormat('yyyy-MM-dd E', 'ko_KR').format(state.date),
                      style: const TextStyle(color: Colors.white),
                    )),
              ],
            ),
            const Divider(),

            // ?????? ??????
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('?????? ??????'),
                RatingStars(
                  value: state.rating,
                  maxValue: 5,
                  onValueChanged: state.isEditMode
                      ? (value) {
                          viewModel.onEvent(ReviewEditEvent.setRating(value));
                        }
                      : null,
                ),
              ],
            ),
            const Divider(),

            // ????????? ??????
            Expanded(
                child: state.isEditMode
                    ? TextFormField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            hintText:
                                '????????? ?????? ??? ???????????? ??????????????????.\n\n???????????? ????????? ??? ??? ????????????.',
                            border: InputBorder.none),
                        maxLines: null,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(state.content),
                      )),
          ],
        ),
      ),
    );
  }
}
