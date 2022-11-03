part of '../video_conference_manager.dart';

class RoomPage extends StatefulWidget {
  final void Function(TwilioAccessToken accessToken) onSubmit;

  const RoomPage({super.key, required this.onSubmit});

  @override
  State<RoomPage> createState() => _RoomPageController();
}

class _RoomPageController extends State<RoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _backendService = TwilioFunctionsService();
  bool isLoading = false;
  bool isFormValid = false;

  _submit() async {
    if (mounted) {
      setState(() => isLoading = true);
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
      setState(() => isLoading = false);
    }
  }

  void _onError(String errorMessage) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(errorMessage),
        ),
      );
    }
  }

  String? _validateNameTextField(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Required field';
    }

    return null;
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {
        isFormValid = _formKey.currentState?.validate() ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => _RoomPageView(this);
}

class _RoomPageView extends StatelessWidget {
  final _RoomPageController _controller;
  const _RoomPageView(this._controller);

  RoomPage get widget => _controller.widget;

  final appBarTitle = 'Join Room';

  Form get _form => Form(
        key: _controller._formKey,
        onChanged: _controller._onFormChanged,
        child: TextFormField(
          controller: _controller._nameController,
          validator: _controller._validateNameTextField,
        ),
      );

  Widget get _formButton => _controller.isLoading
      ? const Center(child: CircularProgressIndicator.adaptive())
      : ElevatedButton(
          onPressed: _controller.isFormValid ? _controller._submit : null,
          child: const Text('Join Room'),
        );

  Padding get _paddingTop => const Padding(padding: EdgeInsets.only(top: 16.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _form,
            _paddingTop,
            _formButton,
          ],
        ),
      ),
    );
  }
}
