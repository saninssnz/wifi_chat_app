import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';

class SelectClientTypeView extends StatelessWidget {
  const SelectClientTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton(
          title: 'Yes',
          onTap: () {
            context.read<AppService>().setIsBrowser(value: true);
          },
        ),
        const SizedBox(width: 10),
        ActionButton(
          title: 'No',
          onTap: () {
            context.read<AppService>().setIsBrowser(value: false);
          },
        ),
      ],
    );
  }
}
