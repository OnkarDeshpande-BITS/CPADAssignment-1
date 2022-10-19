import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:async';

import 'package:vaccination_mgmt/constants/parse_constants.dart';
import 'package:vaccination_mgmt/ui/manage_drive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MaterialApp(
    home: DriveMainWidget(),
  ));

}