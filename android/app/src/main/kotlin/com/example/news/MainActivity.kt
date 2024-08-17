package com.example.onews

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import android.util.Base64
import androidx.annotation.NonNull
import anynews.extension.shared.ExtensionAbstract
import anynews.extension.shared.NewsCard
import anynews.extension.shared.NewsData
import dalvik.system.PathClassLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val CHANNEL = "onews/native.interface"
    private val ExtensionMap: HashMap<String, ExtensionAbstract> =
            HashMap<String, ExtensionAbstract>()
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            println(call.method)
            if (call.method == "loadLocalExtensions") {
                loadLocalExtensions(result)
            } else if (call.method == "loadNewsHeadlines") {
                loadNewsHeadlines(call, result)
            } else if (call.method == "scrapeUrl") {
                scrapeUrl(call, result)
            } else if (call.method == "scrapeHomePage") {
                scrapeHomePage(call, result)
            }
        }
    }

    fun iconToBase64(icon: Drawable): String {
        val bitmap =
                Bitmap.createBitmap(
                        icon.getIntrinsicWidth(),
                        icon.getIntrinsicHeight(),
                        Bitmap.Config.ARGB_8888
                )
        val canvas = Canvas(bitmap)
        icon.setBounds(0, 0, canvas.width, canvas.height)
        icon.draw(canvas)

        val byteStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteStream)
        val byteArray = byteStream.toByteArray()
        return Base64.encodeToString(byteArray, Base64.DEFAULT).replace("\n", "")
    }
    fun loadLocalExtensions(result: MethodChannel.Result) {
        val context: Context = this.applicationContext
        var pkgManager: PackageManager
        var pkgs: List<PackageInfo>
        var S: String = ""
        try {
            pkgManager = context.packageManager
            if (pkgManager == null) {
                result.success(null)
                return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pkgs =
                        pkgManager.getInstalledPackages(
                                PackageManager.PackageInfoFlags.of(
                                        PackageManager.GET_META_DATA.toLong()
                                )
                        )
            } else {
                pkgs = packageManager.getInstalledPackages(PackageManager.GET_META_DATA)
            }
        } catch (e: Exception) {
            result.success(null)
            return
        }
        val anynewsPkgs: ArrayList<PackageInfo> = ArrayList<PackageInfo>()

        var output: HashMap<String, HashMap<String, Any>> = HashMap()
        pkgs.asSequence().forEach {
            if (it.applicationInfo.metaData != null) {
                if (it.applicationInfo.metaData.containsKey("onews-extension")) {
                    anynewsPkgs.add(it)
                    var info: HashMap<String, Any> = HashMap()

                    val className: String = it.applicationInfo.metaData.getString("class-name")!!
                    info.put("className", className)

                    val classLoader =
                            PathClassLoader(it.applicationInfo.sourceDir, null, context.classLoader)
                    val clazz =
                            Class.forName(
                                    "anynews.extension.${className.lowercase()}.$className",
                                    false,
                                    classLoader
                            )
                    val extension: ExtensionAbstract =
                            clazz.getDeclaredConstructor().newInstance() as ExtensionAbstract
                    info.put("logoURL", extension.iconLink)
                    info.put("version", extension.version)
                    info.put("categories", extension.categories)
                    output.put(className, info)

                    ExtensionMap.put(className, extension)
                }
            }
        }
        result.success(output)
    }
    fun loadNewsHeadlines(call: MethodCall, result: MethodChannel.Result) {
        val extensionName: String = call.argument<String>("extensionName")!!
        val type: String = call.argument<String>("type")!!
        val count: Int = call.argument<Int>("count")!!
        val page: Int = call.argument<Int>("page")!!
        val executor = Executors.newSingleThreadExecutor()
        var out: HashMap<String, Any> = HashMap()

        executor.execute {
            var list: ArrayList<NewsCard>?
            try {
                list = ExtensionMap.get(extensionName)!!.loadNewsHeadlines(type, count, page)
                if (list == null) {
                    out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                    result.success(out)
                    return@execute
                }
            } catch (e: Exception) {
                out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                result.success(out)
                return@execute
            }

            var data: ArrayList<Map<String, Any>> = ArrayList()
            for (card in list) {
                data.add(card.toJson())
            }
            out.put("data", data)
            result.success(out)
        }
    }
    fun scrapeUrl(call: MethodCall, result: MethodChannel.Result) {
        val extensionName: String = call.argument<String>("extensionName")!!
        val url: String = call.argument<String>("url")!!
        val executor = Executors.newSingleThreadExecutor()
        var out: HashMap<String, Any> = HashMap()
        executor.execute {
            var newsPage: NewsData?

            try {
                newsPage = ExtensionMap.get(extensionName)!!.scrapeUrl(url)
                if (newsPage == null) {
                    out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                    result.success(out)
                    return@execute
                }
            } catch (e: Exception) {
                out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                result.success(out)
                return@execute
            }
            result.success(newsPage.toJson())
        }
    }
    fun scrapeHomePage(call: MethodCall, result: MethodChannel.Result) {
        val extensionName: String = call.argument<String>("extensionName")!!
        val executor = Executors.newSingleThreadExecutor()
        var out: HashMap<String, Any> = HashMap()

        executor.execute {
            var headlines: ArrayList<NewsCard>?

            try {
                headlines = ExtensionMap.get(extensionName)!!.scrapeHomePage()
                if (headlines == null) {
                    out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                    result.success(out)
                    return@execute
                }
            } catch (e: Exception) {
                out.put("error", ExtensionMap.get(extensionName)!!.errorHanlder.toJson())
                result.success(out)
                return@execute
            }

            var data: ArrayList<Map<String, Any>> = ArrayList()
            for (card in headlines) {
                data.add(card.toJson())
            }
            out.put("data", data)
            result.success(out)
        }
    }
}
