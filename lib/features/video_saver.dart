import 'package:flutter/material.dart';

class VideoSaver extends StatefulWidget {
  const VideoSaver({super.key});

  @override
  State<VideoSaver> createState() => _VideoSaverState();
}

class _VideoSaverState extends State<VideoSaver> {
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
              height: 10.0,
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
                      setState(() {
                        inputController.text = '';
                      });
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                  labelText: 'URL',
                  hintText: 'Input URL'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
