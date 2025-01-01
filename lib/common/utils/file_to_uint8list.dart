import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> fileToUint8List(File file) async {
  Uint8List bytes = await file.readAsBytes();
  return bytes;
}
