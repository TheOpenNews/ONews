package com.example.anynews


import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import anynews.extension.shared.ExtensionAbstract
import anynews.extension.shared.NewsCard
import anynews.extension.shared.NewsType
import dalvik.system.PathClassLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors


class MainActivity : FlutterActivity() {
    private val CHANNEL = "anynews/native.interface"
    private  val ExtensionMap  : HashMap<String,ExtensionAbstract> = HashMap<String,ExtensionAbstract>();
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            println(call.method);
            if(call.method == "loadLocalExtensions") {
                loadLocalExtensions(result);
            } else if(call.method == "loadNewsHeadlines") {
                loadNewsHeadlines(call,result);
            }

        };
    }
    fun loadLocalExtensions(result : MethodChannel.Result) {
        val context: Context = this.applicationContext
        val pkgManager = context.packageManager
        val pkgs = pkgManager.getInstalledPackages(PackageManager.GET_META_DATA)
        val anyNewsPkgs: ArrayList<PackageInfo> = ArrayList<PackageInfo>();

        var output : HashMap<String,HashMap<String,String>> = HashMap();
        pkgs.asSequence().forEach {
            if (it.applicationInfo.metaData != null) {
                if (it.applicationInfo.metaData.containsKey("isAnyNewsExtension")) {
                    anyNewsPkgs.add(it);
                    var info : HashMap<String,String> = HashMap();

                    val className : String =  it.applicationInfo.metaData.getString("className")!!
                    val name : String = it.applicationInfo.metaData.getString("name")!!
                    val logoURL : String = it.applicationInfo.metaData.getString("logoURL")!!
                    val siteURL : String = it.applicationInfo.metaData.getString("siteURL")!!

                    info.put("name",name);
                    info.put("logoURL",logoURL);
                    info.put("siteURL",siteURL);
                    output.put(className,info);


                    val classLoader = PathClassLoader(it.applicationInfo.sourceDir,null,context.classLoader)
                    val clazz  = Class.forName("anynews.extension.s2jnews.S2JNews",false,classLoader)
                    val extension : ExtensionAbstract =  clazz.getDeclaredConstructor().newInstance() as ExtensionAbstract
                    ExtensionMap.put(className,extension)
                }
            }
        }
        result.success(output);
    }
    fun loadNewsHeadlines(call : MethodCall,result : MethodChannel.Result) {
        val extensionName : String =  call.argument<String>("extensionName")!!;
        val type : String =  call.argument<String>("type")!!;
        val count : Int =  call.argument<Int>("count")!!;
        val page : Int =  call.argument<Int>("page")!!;
        val executor = Executors.newSingleThreadExecutor()
        executor.execute {
            val list : ArrayList<NewsCard> = ExtensionMap.get(extensionName)!!.loadNewsHeadlines(NewsType.valueOf(type),count,page);
            var data : ArrayList<Map<String,String>> = ArrayList();
            for(card in list) {
                var cardData : HashMap<String,String> = HashMap();
                cardData.put("title",card.title);
                cardData.put("date",card.date);
                cardData.put("imgURL",card.imgURL);
                cardData.put("link",card.link);
                data.add(cardData);
            }
            result.success(data);
        }
    }

}






