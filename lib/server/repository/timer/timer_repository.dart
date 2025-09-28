import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/server/model/timer/add_time_proposal_dto.dart';
import 'package:meet_now_app/server/model/timer/add_time_response_dto.dart';
import 'package:meet_now_app/server/model/timer/timer_update_dto.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'timer_repository_interface.dart';

class TimerRepository implements TimerRepositoryInterface {
  late StompClient _stompClient;
  final StreamController<TimerUpdateDto> _timerController =
      StreamController.broadcast();
  final StreamController<AddTimeProposalDto> _proposalController =
      StreamController.broadcast();
  final StreamController<AddTimeResponseDto> _responseController =
      StreamController.broadcast();

  String? _tempChatId;
  String? _userId;
  bool _isConnected = false;

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
    _userId = userId;

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: socketAddress,
        onConnect: _onConnect,
        onDisconnect: (frame) {
          debugPrint('[TimerRepository] Disconnected: ${frame.body}');
          _isConnected = false;
        },
        onWebSocketError:
            (error) => debugPrint('[TimerRepository] WebSocket Error: $error'),
        onStompError:
            (frame) =>
                debugPrint('[TimerRepository] STOMP Error: ${frame.body}'),
        onWebSocketDone: () {
          debugPrint('[TimerRepository] WebSocket connection closed.');
          _isConnected = false;
        },
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('[TimerRepository] Connected to timer WebSocket');
    _isConnected = true;

    _stompClient.subscribe(
      destination: '/topic/chat/$_tempChatId/timer',
      callback: (frame) {
        try {
          final data = json.decode(frame.body!);
          final update = TimerUpdateDto.fromJson(data);
          _timerController.add(update);
        } catch (e) {
          debugPrint('[TimerRepository] Error parsing timer update: $e');
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
        } catch (e) {
          debugPrint('[TimerRepository] Error parsing time proposal: $e');
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
        } catch (e) {
          debugPrint('[TimerRepository] Error parsing time response: $e');
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
        } catch (e) {
          debugPrint('[TimerRepository] Error parsing time rejection: $e');
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

    debugPrint(
      '[TimerRepository] Sent add time proposal: $additionalMinutes minutes',
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

    debugPrint(
      '[TimerRepository] Sent add time response: ${accepted ? 'accepted' : 'rejected'}',
    );
  }

  @override
  void disconnect() {
    _stompClient.deactivate();
    _isConnected = false;
    _timerController.close();
    _proposalController.close();
    _responseController.close();
    debugPrint('[TimerRepository] Disconnected');
  }
}
