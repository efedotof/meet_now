import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/timer/add_time_proposal_dto.dart';
import 'package:meet_now_app/server/model/timer/add_time_response_dto.dart';
import 'package:meet_now_app/server/model/timer/timer_update_dto.dart';
import 'package:meet_now_app/server/repository/user_model_app/user_model_app_interface.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'timer_repository_interface.dart';

class TimerRepository implements TimerRepositoryInterface {
  final UserModelAppInterface _userModelAppInterface;
  late StompClient _stompClient;
  final StreamController<TimerUpdateDto> _timerController =
      StreamController.broadcast();
  final StreamController<AddTimeProposalDto> _proposalController =
      StreamController.broadcast();
  final StreamController<AddTimeResponseDto> _responseController =
      StreamController.broadcast();

  String? _tempChatId;
  bool _isConnected = false;

  TimerRepository({required UserModelAppInterface userModelAppInterface})
    : _userModelAppInterface = userModelAppInterface;

  @override
  Stream<TimerUpdateDto> get timerUpdates => _timerController.stream;

  @override
  Stream<AddTimeProposalDto> get addTimeProposals => _proposalController.stream;

  @override
  Stream<AddTimeResponseDto> get addTimeResponses => _responseController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  void connect(String tempChatId, String userId) {
    _tempChatId = tempChatId;
    final token = _userModelAppInterface.user?.token;
    log(
      'Connecting to Timer WebSocket for chat $_tempChatId',
      name: 'TimerRepository',
    );

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: socketAddress,
        onConnect: _onConnect,
        onDisconnect: (frame) {
          _isConnected = false;
          log('Disconnected: ${frame.body}', name: 'TimerRepository');
        },
        onWebSocketError:
            (error) => log('WebSocket Error: $error', name: 'TimerRepository'),
        onStompError:
            (frame) =>
                log('STOMP Error: ${frame.body}', name: 'TimerRepository'),
        onWebSocketDone: () {
          _isConnected = false;
          log('WebSocket connection closed', name: 'TimerRepository');
        },
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    log('Connected to timer WebSocket', name: 'TimerRepository');

    _stompClient.subscribe(
      destination: '/topic/chat/$_tempChatId/timer',
      callback: (frame) {
        try {
          final data = json.decode(frame.body!);
          final update = TimerUpdateDto.fromJson(data);
          _timerController.add(update);
          log('Received timer update: $data', name: 'TimerRepository');
        } catch (e) {
          log('Error parsing timer update: $e', name: 'TimerRepository');
        }
      },
    );

    _stompClient.subscribe(
      destination: '/topic/chat/$_tempChatId/add-time-proposal',
      callback: (frame) {
        try {
          final data = json.decode(frame.body!);
          final proposal = AddTimeProposalDto.fromJson(data);
          _proposalController.add(proposal);
          log('Received add time proposal: $data', name: 'TimerRepository');
        } catch (e) {
          log('Error parsing time proposal: $e', name: 'TimerRepository');
        }
      },
    );

    _stompClient.subscribe(
      destination: '/topic/chat/$_tempChatId/time-added',
      callback: (frame) {
        try {
          final data = json.decode(frame.body!);
          final response = AddTimeResponseDto.fromJson(data);
          _responseController.add(response);
          log('Received add time response: $data', name: 'TimerRepository');
        } catch (e) {
          log('Error parsing time response: $e', name: 'TimerRepository');
        }
      },
    );

    _stompClient.subscribe(
      destination: '/topic/chat/$_tempChatId/time-rejected',
      callback: (frame) {
        try {
          final data = json.decode(frame.body!);
          final response = AddTimeResponseDto.fromJson(data);
          _responseController.add(response);
          log('Received time rejection: $data', name: 'TimerRepository');
        } catch (e) {
          log('Error parsing time rejection: $e', name: 'TimerRepository');
        }
      },
    );
  }

  @override
  void proposeAddTime(
    String tempChatId,
    String fromUserId,
    int additionalMinutes,
  ) {
    if (!_isConnected) return;

    final proposal = {
      'tempChatId': tempChatId,
      'fromUserId': fromUserId,
      'additionalMinutes': additionalMinutes,
    };

    _stompClient.send(
      destination: '/app/chat/$tempChatId/propose-add-time',
      body: json.encode(proposal),
    );

    log(
      'Sent add time proposal: $additionalMinutes minutes',
      name: 'TimerRepository',
    );
  }

  @override
  void respondToAddTime(
    String tempChatId,
    String userId,
    bool accepted,
    int additionalMinutes,
  ) {
    if (!_isConnected) return;

    final response = {
      'tempChatId': tempChatId,
      'userId': userId,
      'accepted': accepted,
      'additionalMinutes': additionalMinutes,
    };

    _stompClient.send(
      destination: '/app/chat/$tempChatId/respond-add-time',
      body: json.encode(response),
    );

    log(
      'Sent add time response: ${accepted ? 'accepted' : 'rejected'}',
      name: 'TimerRepository',
    );
  }

  @override
  void disconnect() {
    _stompClient.deactivate();
    _isConnected = false;
    _timerController.close();
    _proposalController.close();
    _responseController.close();
    log('Disconnected from timer WebSocket', name: 'TimerRepository');
  }
}
