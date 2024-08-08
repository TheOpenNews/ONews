package com.example.onews


import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Base64
import android.os.Build
import androidx.annotation.NonNull
import anynews.extension.shared.ExtensionAbstract
import anynews.extension.shared.NewsCard
import anynews.extension.shared.NewsPage
import dalvik.system.PathClassLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors


class MainActivity : FlutterActivity() {
    private val CHANNEL = "onews/native.interface"
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
            } else if(call.method == "scrapeUrl") {
                scrapeUrl(call,result);
            }

        };
    }

    fun iconToBase64(icon : Drawable) : String {
        val bitmap = Bitmap.createBitmap(
            icon.getIntrinsicWidth(),
            icon.getIntrinsicHeight(), Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)
        icon.setBounds(0, 0, canvas.width, canvas.height)
        icon.draw(canvas)

        val byteStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteStream)
        val byteArray = byteStream.toByteArray()
        return Base64.encodeToString(byteArray, Base64.DEFAULT).replace("\n","");
    }
    fun loadLocalExtensions(result : MethodChannel.Result) {
        val context: Context = this.applicationContext
        var pkgManager : PackageManager
        var pkgs : List<PackageInfo> 
        var S : String = "";
        try {
            pkgManager = context.packageManager
            if(pkgManager == null) {
                result.success(null);
                return;
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pkgs = pkgManager.getInstalledPackages(PackageManager.PackageInfoFlags.of(PackageManager.GET_META_DATA.toLong()))
            } else {
                pkgs = packageManager.getInstalledPackages(PackageManager.GET_META_DATA);
            }            
        }catch(e : Exception) {
            result.success(null);
            return;
        }
        val anynewsPkgs: ArrayList<PackageInfo> = ArrayList<PackageInfo>();

        var output : HashMap<String,HashMap<String,Any>> = HashMap();
        pkgs.asSequence().forEach {
            if (it.applicationInfo.metaData != null) {
                if (it.applicationInfo.metaData.containsKey("isAnyNewsExtension")) {
                    anynewsPkgs.add(it);
                    var info : HashMap<String,Any> = HashMap();

                    val className : String =  it.applicationInfo.metaData.getString("className")!!
                    val name : String = it.applicationInfo.metaData.getString("name")!!
                    val logoURL : String = it.applicationInfo.metaData.getString("logoURL")!!
                    val siteURL : String = it.applicationInfo.metaData.getString("siteURL")!!
                    val base64Icon : String = iconToBase64(it.applicationInfo.loadIcon(pkgManager))

                    info.put("name",name);
                    info.put("logoURL",logoURL);
                    info.put("siteURL",siteURL);
                   info.put("base64Icon",base64Icon);


                    val classLoader = PathClassLoader(it.applicationInfo.sourceDir,null,context.classLoader)
                    val clazz  = Class.forName("anynews.extension.s2jnews.S2JNews",false,classLoader)
                   val extension : ExtensionAbstract =  clazz.getDeclaredConstructor().newInstance() as ExtensionAbstract

                   info.put("categories",extension.categories);
                   output.put(className,info);


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
            var list : ArrayList<NewsCard>?
            try {
                list = ExtensionMap.get(extensionName)!!.loadNewsHeadlines(type,count,page);
                if(list == null) {
                    result.success(null);
                    return@execute
                }
            } catch (e : Exception) {
                result.success(null);
                return@execute
            }

            var data : ArrayList<Map<String,Any>> = ArrayList();
            for(card in list) {
                data.add(card.toJson());
            }
            result.success(data);
        }
    }
    fun scrapeUrl(call : MethodCall,result : MethodChannel.Result) {
        val extensionName : String =  call.argument<String>("extensionName")!!;
        val url : String =  call.argument<String>("url")!!;
        val executor = Executors.newSingleThreadExecutor()
        executor.execute {
            var newsPage : NewsPage?

            try {
                newsPage  = ExtensionMap.get(extensionName)!!.scrapeUrl(url);
                if(newsPage == null) {
                    result.success(null);
                    return@execute
                }
            } catch (e : Exception) {
                result.success(null);
                return@execute
            }
            result.success(newsPage.toJson());
        }
    }


}






