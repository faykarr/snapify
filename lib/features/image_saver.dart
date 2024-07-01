import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapify/utils/constant.dart';

class ImageSaver extends StatefulWidget {
  const ImageSaver({super.key});

  @override
  State<ImageSaver> createState() => _ImageSaverState();
}

class _ImageSaverState extends State<ImageSaver> {
  TextEditingController inputController = TextEditingController();
  bool isImageLoading = false;
  double downloadProgress = 0.0;
  bool showImage = false;
  Image? downloadedImage;
  String? previewImage;

  _pickImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No URL Provided.'),
          content: const Text('Please enter a valid image URL.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      previewImage = imageUrl;
      showImage = true;
    });
  }

  Future<void> _saveImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${appDir.path}/$fileName';

    Dio dio = Dio();

    setState(() {
      isImageLoading = true;
      downloadProgress = 0.0;
    });

    try {
      await dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
            });
          }
        },
      );

      await GallerySaver.saveImage(filePath, albumName: 'Flutter Download');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo saved to gallery!')),
      );

      setState(() {
        downloadedImage = Image.file(File(filePath));
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error Save Photo.'),
          content: Text('Error saving photo: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    } finally {
      setState(() {
        isImageLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      inputController.text = '';
    });
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
                          showImage = false;
                          previewImage = null;
                          downloadedImage = null;
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
                ElevatedButton.icon(
                  onPressed: () async {
                    // Action for the preview button
                    await _pickImage(inputController.text);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Preview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                ),
                // Show Save button only when video is previewed
                if (showImage)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _saveImage(inputController.text);
                    },
                    icon: const Icon(Icons.favorite_border_outlined),
                    label: const Text('Save Image'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: backgroundColor2,
                      foregroundColor: buttonColor,
                      side: BorderSide(color: buttonColor),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            if (downloadProgress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // Rounded corners for the container
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade500,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated progress bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width *
                              0.6 *
                              downloadProgress,
                          // Adjust width based on progress
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // Percentage text
                        Text(
                          downloadProgress == 1.0
                              ? 'Download Complete'
                              : 'Downloading ${(downloadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const Divider(
              height: 35.0,
              indent: 50.0,
              endIndent: 50.0,
              thickness: 2.0,
            ),
            contentArea(),
            const SizedBox(
              height: 45.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget contentArea() {
    if (showImage) {
      if (isImageLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (downloadedImage != null) {
        //     Display downloaded image after saving to gallery.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: downloadedImage!,
          ),
        );
      } else if (previewImage != null) {
        //     Preview image from URL without saving to gallery
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Image.network(previewImage!),
          ),
        );
      }
    } else {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Please input the image URL to preview.'),
      );
    }
    return Container();
  }
}
