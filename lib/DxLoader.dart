import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DxLoader {
  static HttpClient _httpClient = new HttpClient();
  static MethodChannel? _platform =  null;


  static void _init() {
    if(_platform != null) return;
    _platform = MethodChannel("dexloader.dev/dexer");
  }
  static Future<Uint8List> _downloadBytes(String url) async  {
    var req = await _httpClient.getUrl(Uri.parse(url));
    var res = await req.close();
    return await consolidateHttpClientResponseBytes(res);
  }
  static Future<File> loadFileFromUrl(String url,String fileName) async {
    Uint8List bytes = await _downloadBytes(url);
    String tempDir = (await getTemporaryDirectory()).path;
    File file = new File('$tempDir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

   static Future<void> loadClass(File dxFile,String className ) async {
    _init();
    await _platform!.invokeMethod<String>("loadClass",{"path" : dxFile.path, "className" : className});
  }

  static Future<void> callMethod(String className,String methodName) async { 
    _init();
    await _platform!.invokeMethod<String>("callMethod",{"className" : className, "methodName": methodName});
  }



}
