import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';
import 'package:wifi_chat_app/uikit/app_snack_bar.dart';

class CheckServiceView extends StatefulWidget {
  const CheckServiceView({super.key});

  @override
  State<CheckServiceView> createState() => _CheckServiceViewState();
}

class _CheckServiceViewState extends State<CheckServiceView> {
  bool showEnableButton = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActionButton(
          onTap: () {
            context.read<AppService>().checkWifiService().then((value) {
              if (!value) {
                setState(() {
                  showEnableButton = true;
                });
                AppShackBar.show(
                  context,
                  'Please enable Wi-fi',
                  actionType: ActionType.warning,
                );
              }
            });
          },
          title: 'Check Wi-fi service',
        ),
        if (showEnableButton)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ActionButton(
              onTap: context.read<AppService>().openServicesSettings,
              title: 'Open settings',
            ),
          ),
      ],
    );
  }
}
