import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_widgets/objectbox.g.dart';
import 'package:test_widgets/models/models.dart';

class ObjectBox {
  late final Store store;
  late final Box<Employee> employeeBox;
  ObjectBox._create(this.store){
    employeeBox = Box<Employee>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, "employee"));
    return ObjectBox._create(store);
  }
}