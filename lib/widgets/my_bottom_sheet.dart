import 'package:flutter/material.dart';
import 'package:youtube_downloader/widgets/theme.dart';

class MyBottomSheet extends StatelessWidget {
  MyBottomSheet(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.author,
      required this.mp3Method,
      required this.mp4Method,
      required this.isDownloading,
      required this.mp3Size,
      required this.mp4Size,
      required this.duration})
      : super(key: key);

  String imageUrl;
  String title;
  String author;
  String duration;
  String mp3Size;
  String mp4Size;
  bool? isDownloading;
  void Function()? mp3Method;
  void Function()? mp4Method;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 0.8,
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: size.height * 0.2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) =>
                    const Placeholder(),
              ),
            ),
            Text(
              title,
              style: Themes.subHeadingStyle,
            ),
            Text(
              author,
              style: Themes.titleStyle.copyWith(color: Colors.blue),
            ),
            Text(
              duration,
              style: Themes.bodyStyle,
            ),
            const SizedBox(height: 10),
            MaterialButton(
                onPressed: mp3Method,
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Download MP3 ($mp3Size MB)')),
            MaterialButton(
                onPressed: mp4Method,
                color: Colors.purple,
                textColor: Colors.white,
                child: Text('Download MP4 ($mp4Size MB)')),
          ],
        ),
      ),
    );
  }
}
