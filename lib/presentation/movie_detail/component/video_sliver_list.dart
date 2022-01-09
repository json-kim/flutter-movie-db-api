import 'package:flutter/material.dart';
import 'package:movie_search/config/theme.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/entity/video/video.dart';
import 'package:movie_search/presentation/movie_detail/component/sliver_fixed_header.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSliverList extends StatelessWidget {
  const VideoSliverList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Video, Movie>>();
    final state = viewModel.state;

    return SliverPersistentHeader(
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
                '관련 동영상',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: YoutubeCard(
                            video: state.data[idx],
                          ),
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
  late final YoutubePlayerController youtubePlayerController;
  bool isExpand = false;
  @override
  void initState() {
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: widget.video.key,
        flags: const YoutubePlayerFlags(
            enableCaption: true,
            captionLanguage: 'ko',
            autoPlay: false,
            loop: false,
            disableDragSeek: true));
    super.initState();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: YoutubePlayerBuilder(
          onEnterFullScreen: () {},
          onExitFullScreen: () {
            // Navigator.of(context).pop();
          },
          player: YoutubePlayer(
            controller: youtubePlayerController,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
              ),
              RemainingDuration(),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => FullScreen(
              //               video: widget.video,
              //             )));
              //   },
              //   child: const Icon(Icons.fullscreen),
              // )
            ],
          ),
          builder: (context, player) {
            return player;
          }),
    );
  }
}

class FullScreen extends StatefulWidget {
  final Video video;
  const FullScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  late final YoutubePlayerController controller;
  @override
  void initState() {
    controller = YoutubePlayerController(initialVideoId: widget.video.key);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: YoutubePlayer(
        controller: controller,
      ),
    );
  }
}