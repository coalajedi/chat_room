part of '../video_conference_manager.dart';

class RoomPage extends StatefulWidget {
  final void Function(TwilioAccessToken accessToken) onSubmit;

  const RoomPage({super.key, required this.onSubmit});

  @override
  State<RoomPage> createState() => _RoomPageController();
}

class _RoomPageController extends State<RoomPage> {
  final _nameController = TextEditingController();
  final _backendService = TwilioFunctionsService();
  bool isLoading = false;

  submit() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final name = _nameController.text;
      final twilioRoomTokenResponse = await _backendService.createToken(name);

      widget.onSubmit(twilioRoomTokenResponse);

      if (mounted) {
        Navigator.pushNamed(context, routeVideoConferenceRoom);
      }
    } catch (e) {
      _onError('Something wrong happened when getting the access token');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _onError(String errorMessage) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(errorMessage),
        ),
      );
    }
  }

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
