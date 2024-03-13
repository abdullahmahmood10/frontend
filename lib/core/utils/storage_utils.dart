import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

Future<void> saveToken(String key, String value) async {
  await _storage.write(key: key, value: value);
}

Future<String?> getToken(String key) async {
  return await _storage.read(key: key);
}

Future<void> deleteToken(String key) async {
  await _storage.delete(key: key);
}

Future<void> printStoredValues() async {
  Map<String, String> allValues = await _storage.readAll();
  print('Stored values: $allValues');
}

Future<void> deleteAllValues() async {
  await _storage.deleteAll();
}
