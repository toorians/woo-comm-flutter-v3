import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../models/blocks_model.dart';
import '../banners/banner_title.dart';

class VideoList extends StatefulWidget {
  final Block block;
  const VideoList({Key? key, required this.block}) : super(key: key);
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {


    bool isDark = Theme.of(context).brightness == Brightness.dark;
    int count = widget.block.children.length;

    if(widget.block.children.length > 0 && widget.block.headerAlign != 'none') {
      count = widget.block.children.length + 1;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(

              (BuildContext context, int index) {

              double paddingTop = index == 0 ? widget.block.blockPadding.top : 0;
              double paddingBottom = (index + 1) == widget.block.children.length ? widget.block.blockPadding.bottom : 0;

              double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
              double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;

              if(widget.block.headerAlign != 'none') {
                marginLast = index == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                marginFirst = index == 1 ? widget.block.mainAxisSpacing / 2 : widget.block.mainAxisSpacing / 2;
                paddingTop = index == 1 ? widget.block.blockPadding.top : 0;
                paddingBottom = index == widget.block.children.length ? widget.block.blockPadding.bottom : 0;
              }

              if(index == 0 && widget.block.headerAlign != 'none') {
                double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;
                return Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    color: isDark ? Colors.transparent : widget.block.backgroundColor,
                    child: BannerTitle(block: widget.block)
                );
              }

              if(index != 0 && widget.block.headerAlign != 'none') {
                index = index - 1;
              }


              return GestureDetector(
                onTap: () async {
                  onItemClick(widget.block.children[index], context);
                },
                child: Container(
                  color: isDark ? Colors.transparent : widget.block.backgroundColor,
                  child: Container(
                    color: Colors.black,
                    height: widget.block.childHeight,
                    margin: EdgeInsets.fromLTRB(widget.block.blockPadding.left, paddingTop, widget.block.blockPadding.right, widget.block.mainAxisSpacing),
                    child: widget.block.blockType == BlockType.youTubeVideo ? YouTubePlayerWidget(child: widget.block.children[index]) : widget.block.blockType == BlockType.videoList ? VideoPLayerWidget(child: widget.block.children[index]) : VideoPLayerWithController(child: widget.block.children[index]),
                  ),
                ),
              );
            },
           childCount: count,
          ),
        ),
    );
  }
}

class VideoPLayerWidget extends StatefulWidget {
  const VideoPLayerWidget({Key? key, required this.child}) : super(key: key);
  final Child child;

  @override
  State<VideoPLayerWidget> createState() => _VideoPLayerWidgetState();
}

class _VideoPLayerWidgetState extends State<VideoPLayerWidget> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.child.image,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }
}

class VideoPLayerWithController extends StatefulWidget {
  const VideoPLayerWithController({Key? key, required this.child}) : super(key: key);
  final Child child;

  @override
  State<VideoPLayerWithController> createState() => _VideoPLayerWithControllerState();
}

class _VideoPLayerWithControllerState extends State<VideoPLayerWithController> {

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
      widget.child.image,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    if(chewieController != null)
      chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return chewieController != null ? Chewie(
      controller: chewieController!,
    ) : Container();//VideoPlayer(videoPlayerController);
  }

  Future<void> initialize() async {
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    setState(() {});
  }
}

class YouTubePlayerWidget extends StatefulWidget {
  final Child child;
  const YouTubePlayerWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.child.image,//ml5uefGgkaA
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
        controller: _controller,
        liveUIColor: Colors.amber,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          //TotalDuration(),
        ]
    );
  }
}

