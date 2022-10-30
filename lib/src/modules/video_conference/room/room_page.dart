part of '../video_conference_manager.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageController();
}

class _RoomPageController extends State<RoomPage> {
  @override
  Widget build(BuildContext context) => _RoomPageView(this);
}

class _RoomPageView extends StatelessWidget {
  final _RoomPageController _controller;
  const _RoomPageView(this._controller, {super.key});

  RoomPage get widget => _controller.widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
