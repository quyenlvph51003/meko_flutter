import 'package:hive/hive.dart';
import 'package:meko_project/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class HiveData {
  HiveData._();

  static HiveData? _instance;

  static HiveData get instance {
    _instance ??= HiveData._();
    return _instance!;
  }

  /// key hive
  String keyCart = 'tableDataCart';
  String keyAddress = 'key_address';

  Future<void> initHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    // Hive.registerAdapter();
  }

  Future<void> addItem<T>(T item, String key) async {
    try {
      var box = await Hive.openBox(keyCart);
      List<dynamic>? list = [];
      list = await box.get(keyCart);
      List<T>? listA = List<T>.from(list ?? []);
      listA.add(item);
      box.put(keyCart, listA);
    } catch (e) {
      MyLogger.e(e);
    }
  }

  Future<List<T>?> getListItem<T>() async {
    try {
      final box = await Hive.openBox(keyCart);
      List<dynamic>? list = [];
      list = await box.get(keyCart);
      List<T>? listA = List<T>.from(list ?? []);
      return listA;
    } catch (e) {
      MyLogger.e(e);
      return [];
    }
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.put(key, value);
    } catch (e) {
      MyLogger.e(e);
    }
  }

  /// Đọc dữ liệu
  Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await Hive.openBox(boxName);
      return box.get(key);
    } catch (e) {
      MyLogger.e(e);
      return null;
    }
  }

  /// Xóa 1 key
  Future<void> remove(String boxName, String key) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.delete(key);
    } catch (e) {
      MyLogger.e(e);
    }
  }

  /// Xóa toàn bộ box
  Future<void> clearBox(String boxName) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.clear();
    } catch (e) {
      MyLogger.e(e);
    }
  }
}
