package com.example.muslimnews;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URLConnection;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.os.AsyncTask;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import android.content.Context;
import dalvik.system.DexClassLoader;
import dalvik.system.BaseDexClassLoader;
import java.lang.reflect.Field;
import android.content.Intent;

class A {
  public void B(Context context) {
    try {

      URL url = new URL("https://github.com/t-88/dex-test/raw/master/classes.dex");
      Scanner s = new Scanner(url.openStream());
      System.out.println(s.nextLine());

      BufferedInputStream in = new BufferedInputStream(url.openStream());
      ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
      byte dataBuffer[] = new byte[1024];
      int bytesRead;
      while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1) {
        byteArrayOutputStream.write(dataBuffer, 0, bytesRead);
      }
      byte[] ba = byteArrayOutputStream.toByteArray();
      File tempFile = File.createTempFile("input", ".dex", null);
      FileOutputStream fos = new FileOutputStream(tempFile);
      fos.write(ba)  ;    

      System.out.println("+++++++++++++++++++++++++++++++++");
      DexClassLoader dexloader = new DexClassLoader(tempFile.getAbsolutePath(), null,null,context.getClassLoader());
      Class clazz = dexloader.loadClass("Dex__");
      String a[] = {};
      Method m = clazz.getMethod("main",  new Class[] { a.getClass()  });
      m.setAccessible(true);
      m.invoke(null, new Object[] { a });
      System.out.println("+++++++++++++++++++++++++++++++++");


      // ClassLoader loader = URLClassLoader.newInstance(
      // // new URL[] { new File("./Dex.jar").toURI().toURL() },
      // new URL[] { new URL("https://github.com/t-88/dex-test/raw/master/Dex.class")
      // },
      // getClass().getClassLoader());

      // String a[] = {};
      // Class<?> clazz = Class.forName("Dex", true, loader);
      // Method m = clazz.getMethod("main", new Class[] { a.getClass() });
      // m.setAccessible(true);
      // m.invoke(null, new Object[] { a });
      // Class<? extends Dexer> runClass = clazz.asSubclass(Dexer.class);
      // runClass.newInstance().main();

    } catch (Exception e) {
      System.out.println("  ASDASDASD " + e);
    }
  }
}

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "dexloader.dev/dexer";
  private static Context CONTEXT;
  Map<String, Class<?>> loadedClasses = new HashMap<>();


  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    CONTEXT = this.getContext();
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
              System.out.println(call.method);

              if (call.method.equals("loadClass")) {
                System.out.println("         -> loadClass");
                loadClass(call.argument("path"),call.argument("className"));
                result.success("");
              } else if(call.method.equals("callMethod")) {
                System.out.println("         -> calling Method");
                callMethod(call.argument("className"),call.argument("methodName"));
                result.success("");
              }
            }
              );
  }

  private String Test() {
    return "TESasdasdT!!";
  }


  private void loadClass(String path,String className) {
    DexClassLoader dexloader = new DexClassLoader(path, null,null,CONTEXT.getClassLoader());
    try {
      loadedClasses.put(className,dexloader.loadClass(className));
      System.out.println("No Error");
    } catch (Exception e) {
      System.out.println("Big Error" + e);
    }
  }
  private void callMethod(String className,String methodName) {
    Class clazz = loadedClasses.get(className);
    String a[] = {};
    try {
      System.out.println("Invock Method" + className + methodName);
      Method m = clazz.getMethod(methodName,  new Class[] { a.getClass()  });
      m.setAccessible(true);
      m.invoke(null, new Object[] { a });
    } catch (Exception e) {
      System.out.println("Big Error" + e);
    }

  }

}