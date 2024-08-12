import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';

import '../../consts/consts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserManualApp extends StatefulWidget {
  const UserManualApp({super.key});

  @override
  State<UserManualApp> createState() => _UserManualAppState();
}

class _UserManualAppState extends State<UserManualApp> {
  YoutubePlayerController _youtubePlayerController = YoutubePlayerController(initialVideoId: 'nBbjacOkwqE', flags: YoutubePlayerFlags(autoPlay: false, mute: false));
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        body: Center(
          child: YoutubePlayer(
            controller: _youtubePlayerController,

          ),
        ),
      ),
    );
  }
}
