import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/presentation/movie_detail/component/sliver_fixed_header.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoSliverList extends StatelessWidget {
  const VideoSliverList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Video, Param>>();
    final state = viewModel.state;

    return SliverPersistentHeader(
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
                '관련 동영상',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.data.isEmpty
                      ? const Center(
                          child: Text('관련 영상이 없습니다.',
                              style: TextStyle(color: Colors.black)))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, idx) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: AspectRatio(
                              aspectRatio: 1.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: YoutubeCard(video: state.data[idx]),
                                  ),
                                  Text(
                                    state.data[idx].name,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: state.data.length,
                        ),
            ),
          ],
        ),
      ),
    ));
  }
}

class YoutubeCard extends StatefulWidget {
  final Video video;

  const YoutubeCard({Key? key, required this.video}) : super(key: key);

  @override
  _YoutubeCardState createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
  bool isExpand = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.key,
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        showControls: true,
        showFullscreenButton: true,
        autoPlay: false,
        showVideoAnnotations: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    // youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: YoutubePlayerIFrame(
        controller: _controller,
        gestureRecognizers: {},
        aspectRatio: 16 / 9,
      ),
    );
  }
}
