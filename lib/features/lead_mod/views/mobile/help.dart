import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

import '../../../../core/core.dart';

class HelpMobileView extends StatefulWidget {
  const HelpMobileView({Key? key}) : super(key: key);

  @override
  State<HelpMobileView> createState() => _HelpMobileViewState();
}

class _HelpMobileViewState extends State<HelpMobileView> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/x0OIFVdSMSM'),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: false,
        // videoQualityPriority: [360, 720],
      ),
    )..initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Tutorial'),
        actions: actionsMenu(context),
      ),
      body: Center(
        child: PodVideoPlayer(
            controller: controller,
            frameAspectRatio: 9 / 16,
            videoAspectRatio: 9 / 16),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
