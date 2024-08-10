import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActionButton(
          onTap: context.read<AppService>().requestPermissions,
          title: 'Request permissions',
        ),
      ],
    );
  }
}
