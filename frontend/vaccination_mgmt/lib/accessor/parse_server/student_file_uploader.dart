import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:file_picker/file_picker.dart';

class StudentFileUploader {
  Future<void> uploadStudentDetails(PlatformFile platfile , bool isWeb) async {
    ParseFileBase? parseFile;
    if (isWeb) {
      //Flutter Web
      parseFile = ParseWebFile(
          await platfile!.bytes,
          name: platfile!.name); //Name for file is required
    } else {
      //Flutter Mobile/Desktop
      parseFile = ParseFile(File(platfile!.path!));
    }
    await parseFile.save();
  }
}