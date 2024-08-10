import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/domain/app_state.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';

class ReadyView extends StatelessWidget {
  const ReadyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActionButton(
          onTap: context.read<AppService>().discover,
          title: 'Start discover peers',
        ),
        const SizedBox(height: 10),
        if (Platform.isIOS)
          ActionButton(
            onTap: () {
              context.read<AppService>().updateState(AppState.selectClientType);
            },
            title: 'Reselect client type',
            type: ActionType.warning,
          ),
      ],
    );
  }
}
