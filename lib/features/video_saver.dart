import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoSaver extends StatefulWidget {
  const VideoSaver({super.key});

  @override
  State<VideoSaver> createState() => _VideoSaverState();
}

class _VideoSaverState extends State<VideoSaver> {
  TextEditingController inputController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  late FlickManager _flickManager;
  bool isVideoLoading = false;
  double downloadProgress = 0.0;
  bool showVideoPlayer = false;

  _pickVideo(String videoUrl) async {
    setState(() {
      isVideoLoading = true;
      showVideoPlayer = true;
    });
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            setState(() {
              isVideoLoading = false;
            });
          });
    _flickManager = FlickManager(videoPlayerController: _videoPlayerController);
  }

  Future<void> _saveVideo(String videoUrl) async {
    final appDir = await getApplicationDocumentsDirectory();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final filePath = '${appDir.path}/$fileName';

    Dio dio = Dio();

    setState(() {
      downloadProgress = 0.0;
    });

    await dio.download(
      videoUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            downloadProgress = received / total;
          });
        }
      },
    );

    await GallerySaver.saveVideo(filePath, albumName: 'Flutter Download');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video saved to gallery!')),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      inputController.text = '';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            //   Input URL Text Field
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: TextFormField(
                controller: inputController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          inputController.text = '';
                          downloadProgress = 0;
                          showVideoPlayer = false;
                        },
                      );
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                  labelText: 'URL',
                  hintText: 'Input URL',
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            //   Button Group
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // Distribute buttons evenly
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Action for the preview button
                    await _pickVideo(inputController.text);
                  },
                  child: const Text('Preview'),
                ),
                // Show Save button only when video is previewed
                if (showVideoPlayer)
                  ElevatedButton(
                    onPressed: () {
                      _saveVideo(inputController.text);
                    },
                    child: const Text('Save Video'),
                  ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            if (downloadProgress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: downloadProgress,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    Text('Downloading ${(downloadProgress * 100).toInt()}%')
                  ],
                ),
              ),
            const Divider(
              height: 35.0,
              indent: 50.0,
              endIndent: 50.0,
              thickness: 2.0,
            ),
            if (showVideoPlayer)
              if (isVideoLoading)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: FlickVideoPlayer(
                        flickManager: _flickManager,
                      ),
                    ),
                  ),
                )
            else
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Please input the video URL to preview.'),
              ),
          ],
        ),
      ),
    );
  }
}
