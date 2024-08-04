package com.example.muslimnews

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


import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import dalvik.system.PathClassLoader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "dexloader.dev/dexer"
    // private var context : Context
  
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      super.configureFlutterEngine(flutterEngine)
    //   context = this.getContext();
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call, result ->
        println("AAAAAAAAAAAAAAAAA");


        val context: Context  = this.applicationContext
        val pkgManager = context.packageManager
        val pkgs = pkgManager.getInstalledPackages(PackageManager.GET_META_DATA)
        println("AAAAAAAAAAAAAAAAA");
        var pkg  : PackageInfo = PackageInfo()
        pkgs
            .asSequence()
            .forEach {
                if(it.packageName == "extension.extension") {
                    pkg = it;
                }
            };   
        println(pkg);
            

println(pkg.packageName.toString());
//        println();
val classLoader = PathClassLoader(pkg.applicationInfo.sourceDir,null,context.classLoader)
println(classLoader.toString())

//        println(pkg.applicationInfo.metaData.toString())

val clazz  = Class.forName(pkg.applicationInfo.packageName + ".Extension",false,classLoader);
val instance = clazz.getDeclaredConstructor().newInstance()
val method =  clazz.getMethod("A");
val a = method.invoke(instance);
println(clazz.declaredMethods[0].name);
println(a.toString());

            
        result.success("");


    }
    }
  }






