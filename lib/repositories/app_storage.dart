import '/repositories/local_storage.dart';
import '/repositories/remote_storage.dart';

class AppStorage with LocalStorage, RemoteStorage {
  const AppStorage._();
}

const appStorage = AppStorage._();