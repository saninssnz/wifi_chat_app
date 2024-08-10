import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';
import 'package:wifi_chat_app/uikit/action_dialog.dart';
import 'package:wifi_chat_app/uikit/app_snack_bar.dart';

class MessagesListener {
  MessagesListener._();

  static void call(
    BuildContext context, {
    required AppService service,
    required ReceivedNearbyMessage message,
  }) {
    final senderSubtitle = 'From ${message.sender.displayName} ';
    final service = Provider.of<AppService>(context, listen: false);

    message.content.byType(
      onTextRequest: (textRequest) {
        service.setMessageList(textRequest.value);
        AppShackBar.show(
          context,
          textRequest.value,
          subtitle: senderSubtitle,
        )?.closed.whenComplete(() {
          // mark as read
          service.sendTextResponse(textRequest.id);
        });
      },
      onTextResponse: (textResponse) {
        // AppShackBar.show(
        //   context,
        //   'Your message with ID=${textResponse.id} was delivered to ${message.sender.displayName}',
        // );
      },
      // onFilesRequest: (filesRequest) {
      //   ActionDialog.show(
      //     context,
      //     title: 'Request to send ${filesRequest.files.length} files',
      //     subtitle: senderSubtitle,
      //   ).then(
      //     // accept or dismiss the files request
      //     (isAccepted) => service.sendFilesResponse(
      //       filesRequest,
      //       isAccepted: isAccepted ?? false,
      //     ),
      //   );
      // },
      onFilesResponse: (filesResponse) {
        AppShackBar.show(
          context,
          filesResponse.isAccepted
              ? 'Request is accepted!'
              : 'Request was denied :(',
          subtitle: senderSubtitle,
          actionType:
              filesResponse.isAccepted ? ActionType.idle : ActionType.warning,
        );
      },
    );
  }
}
