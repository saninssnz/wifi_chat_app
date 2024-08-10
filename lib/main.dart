import 'package:flutter/material.dart';
import 'package:wifi_chat_app/presentation/app.dart';

import 'domain/app_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = AppService();
  await service.getPlatformInfo();

  runApp(
    App(service: service),
  );
}
