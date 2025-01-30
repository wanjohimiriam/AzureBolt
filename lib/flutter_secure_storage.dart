import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

void storePAT(String pat) async {
  await storage.write(key: "azure_pat", value: pat);
}

Future<String?> getPAT() async {
  return await storage.read(key: "azure_pat");
}
