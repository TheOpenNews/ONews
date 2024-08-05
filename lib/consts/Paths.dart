import 'package:path_provider/path_provider.dart';

class Paths {
  static String ApplicationDownloadDir = ""; 

  static void init() async {
    ApplicationDownloadDir = (await getDownloadsDirectory())?.path as String;
  }

}
