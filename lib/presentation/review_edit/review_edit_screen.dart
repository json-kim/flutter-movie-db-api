import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
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
          final snackBar = SnackBar(content: Text(message));

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
          state.isEditMode
              ? IconButton(
                  onPressed: () {
                    final String content = _textEditingController.text;
                    viewModel.onEvent(ReviewEditEvent.saveReview(content));
                  },
                  icon: const Text('저장'))
              : IconButton(
                  onPressed: () {
                    viewModel.onEvent(const ReviewEditEvent.changeMode(true));
                  },
                  icon: const Text('수정')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 위젯
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('감상 날짜'),
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

            // 별점 위젯
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('별점 평가'),
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

            // 감상평 위젯
            Expanded(
                child: state.isEditMode
                    ? TextFormField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            hintText:
                                '영화를 보고 난 감상평을 기록해주세요.\n\n감상평은 자신만 볼 수 있습니다.',
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
