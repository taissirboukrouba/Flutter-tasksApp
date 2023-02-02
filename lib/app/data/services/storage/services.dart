import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/keys.dart';

class StorageService extends GetxService {
  late GetStorage _box;
  Future<StorageService> init() async {
    _box = GetStorage();
    await _box.write(taskKey, []);
    // await _box.writeIfNull(taskKey, []);
    return this; //returns the GetStorage
  }

  T read<T>(String key) {
    // T is a generic type (returns the type it reads)
    return _box.read(key);
  }

  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}
