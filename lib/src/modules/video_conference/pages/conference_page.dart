part of 'video_conference_manager.dart';

class ConferecePage extends StatefulWidget {
  final TwilioAccessToken twilioToken;
  const ConferecePage({super.key, required this.twilioToken});

  @override
  State<ConferecePage> createState() => _ConferecePageController();
}

class _ConferecePageController extends State<ConferecePage> {
  late CameraCapturer _cameraCapturer;
  late String _trackId;
  late Room _room;
  final List<StreamSubscription> _streamSubscriptions = [];
  final List<ParticipantWidget> _participants = [];

  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _connect();
  }

  @override
  void dispose() {
    _disconnect();
    for (var stream in _streamSubscriptions) {
      stream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ConferencePageView(this);

  Future<void> _connect() async {
    try {
      await TwilioProgrammableVideo.setAudioSettings(
        speakerphoneEnabled: true,
        bluetoothPreferred: true,
      );

      final sources = await CameraSource.getSources();
      _cameraCapturer =
          CameraCapturer(sources.firstWhere((source) => source.isFrontFacing));
      _trackId = const Uuid().v1();

      var connectOptions = ConnectOptions(
        widget.twilioToken.accessToken,
        preferredAudioCodecs: [OpusCodec()],
        preferredVideoCodecs: [Vp8Codec()],
        audioTracks: [LocalAudioTrack(true, 'audio_track-$_trackId')],
        videoTracks: [LocalVideoTrack(true, _cameraCapturer)],
        dataTracks: [
          LocalDataTrack(DataTrackOptions(name: 'data_track-$_trackId')),
        ],
        enableNetworkQuality: true,
        enableDominantSpeaker: true,
        networkQualityConfiguration: NetworkQualityConfiguration(
          remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
        ),
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _streamSubscriptions.add(_room.onConnected.listen(_onConnected));
      _streamSubscriptions.add(_room.onDisconnected.listen(_onDisconnected));
      _streamSubscriptions.add(_room.onReconnecting.listen(_onReconnecting));
      _streamSubscriptions.add(_room.onReconnected.listen(_onReconnected));
      _streamSubscriptions
          .add(_room.onConnectFailure.listen(_onConnectFailure));
    } catch (err) {
      _onError(err.toString());
    } finally {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => isLoading = false);
        }
      });
    }
  }

  Future<void> _disconnect() async => await _room.disconnect();
  void _onDisconnected(RoomDisconnectedEvent event) {
    _onError(event.exception?.message ?? 'Disconnected from video conference');
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _onReconnecting(RoomReconnectingEvent event) {
    _onError(event.exception?.message ?? 'Reconnecting...');
    if (mounted) {
      setState(() => isLoading = true);
    }
  }

  void _onReconnected(Room room) {
    _onError('Reconnected!');
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void _onConnected(Room room) {
    // When connected for the first time, add remote participant listeners
    _streamSubscriptions
        .add(_room.onParticipantConnected.listen(_onParticipantConnected));
    _streamSubscriptions.add(
        _room.onParticipantDisconnected.listen(_onParticipantDisconnected));
    final localParticipant = room.localParticipant;
    if (localParticipant == null) {
      return;
    }

    // Only add ourselves when connected for the first time too.
    _participants.add(_buildParticipant(
      child: localParticipant.localVideoTracks[0].localVideoTrack.widget(),
      id: widget.twilioToken.userIdentity,
    ));

    for (final remoteParticipant in room.remoteParticipants) {
      var participant = _participants.firstWhereOrNull(
          (participant) => participant.id == remoteParticipant.sid);
      if (participant == null) {
        _addRemoteParticipantListeners(remoteParticipant);
      }
    }
    _reload();
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    _onError(event.exception?.message ?? 'Error when trying to connect you');
  }

  void _onParticipantConnected(RoomParticipantConnectedEvent event) {
    _addRemoteParticipantListeners(event.remoteParticipant);
    _reload();
  }

  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event) {
    _participants.removeWhere(
      (ParticipantWidget p) => p.id == event.remoteParticipant.sid,
    );
    _reload();
  }

  void _addRemoteParticipantListeners(RemoteParticipant remoteParticipant) {
    _streamSubscriptions.add(remoteParticipant.onVideoTrackSubscribed
        .listen(_addOrUpdateParticipant));
    _streamSubscriptions.add(remoteParticipant.onAudioTrackSubscribed
        .listen(_addOrUpdateParticipant));
  }

  void _addOrUpdateParticipant(RemoteParticipantEvent event) {
    final participant = _participants.firstWhereOrNull(
      (ParticipantWidget p) => p.id == event.remoteParticipant.sid,
    );

    if (participant != null) {
      _onError('Updating A/V enabled values');
    } else {
      if (event is RemoteVideoTrackSubscriptionEvent) {
        _onError('Participant ${event.remoteParticipant.sid} joined');
        _participants.insert(
          0,
          _buildParticipant(
            child: event.remoteVideoTrack.widget(),
            id: event.remoteParticipant.sid ?? '',
          ),
        );
        _reload();
      }
    }
  }

  ParticipantWidget _buildParticipant({
    required String id,
    required Widget child,
  }) =>
      ParticipantWidget(id: id, child: child);

  void _onError(String errorMessage) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(errorMessage),
        ),
      );
    });
  }

  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _ConferencePageView extends StatelessWidget {
  final _ConferecePageController _controller;
  const _ConferencePageView(this._controller);

  ConferecePage get widget => _controller.widget;

  Padding get _paddingVertical => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
      );

  Widget get _loading => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: CircularProgressIndicator.adaptive()),
          _paddingVertical,
          const Text(
            'Connecting to the room...',
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget get _body {
    return Stack(
      children: [_participants],
    );
  }

  Widget get _participants {
    final children = <Widget>[];
    _buildOverlayLayout(children);
    return Stack(children: children);
  }

  void _buildOverlayLayout(List<Widget> children) {
    final size = MediaQuery.of(_controller.context).size;
    final participants = _controller._participants;

    children.add(
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: participants.length <= 2 ? 1 : 2,
          mainAxisExtent: size.height / participants.length,
        ),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return Card(
            child: participants[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: _controller.isLoading ? _loading : _body,
      ),
      floatingActionButton: _controller.isLoading
          ? null
          : FloatingActionButton(
              tooltip: 'Disconnect',
              backgroundColor: Colors.white,
              onPressed: _controller._disconnect,
              child: const Icon(
                Icons.call_end,
                color: Colors.red,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
