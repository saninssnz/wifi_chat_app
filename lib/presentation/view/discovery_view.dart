import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActionButton(
          onTap: context.read<AppService>().startListeningPeers,
          title: 'Tap to get peers!',
        ),
        const SizedBox(height: 10),
        ActionButton(
          type: ActionType.warning,
          onTap: context.read<AppService>().stopDiscovery,
          title: 'Stop discovery',
        ),
      ],
    );
  }
}
