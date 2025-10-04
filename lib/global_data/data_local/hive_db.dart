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

  void initHive() async {
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
}
