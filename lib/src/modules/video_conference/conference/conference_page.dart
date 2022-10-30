part of '../video_conference_manager.dart';

class ConferecePage extends StatefulWidget {
  const ConferecePage({super.key});

  @override
  State<ConferecePage> createState() => _ConferecePageController();
}

class _ConferecePageController extends State<ConferecePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ConferencePageView extends StatelessWidget {
  final _ConferecePageController _controller;
  const _ConferencePageView(
    this._controller, {
    super.key,
  });

  ConferecePage get widget => _controller.widget;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
