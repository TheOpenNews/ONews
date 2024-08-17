package anynews.extension.shared
import java.util.ArrayList; 
import java.util.HashMap; 




val HEADER_TITLE : String = "title"
val HEADER_AUTHOR : String = "author"
val HEADER_AUTHOR_LINK : String = "author-link"
val HEADER_DATE : String = "date"

val CONTENT_PARAGRAPH : String =  "p"
val CONTENT_IMAGE : String =  "img"

class NewsCard(
    var title: String,
    var date : String,
    var imgURL: String,
    var link: String,
    ) {
    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("title",title)
        out.put("date",date)
        out.put("imgURL",imgURL)
        out.put("link",link)
        return  out
    }
    override fun toString(): String {
        return "NewsCard(title: $title, date: $date, link: ${link}...)"
    }
}


enum class NewsDataContentType(val type : String) {
    Paragraph("Paragraph"),
    Header("Header"),
    Img("Img"),
    VidLink("VidLink"),
}
class NewsDataHeader {
    var title : String = ""
    var img : String = ""
    var author : String = ""
    var author_link : String = ""
    var date : String = ""


    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("title",title)
        out.put("img",img)
        out.put("author",author)
        out.put("author_link",author_link)
        out.put("date",date)
        return  out
    }


    override fun toString(): String {
        return "NewsDataHeader(title: $title)"
    }
}
class NewsContentElem() {
    lateinit var type : NewsDataContentType  
    var metadata : HashMap<String,String> = HashMap()

    fun addMeta(key : String, value : String) {
        metadata.put(key, value)
    }


    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("type",type.name)
        for(metadataKey in metadata.keys) {
            out.put(metadataKey, metadata.get(metadataKey)!!)
        }
        return  out
    }    

    override fun toString(): String {
        return "NewsContentElem(type: $type)"
    }
}
class NewsData() {
    var header : NewsDataHeader = NewsDataHeader()  
    var content: ArrayList<NewsContentElem> = ArrayList()
    var related : ArrayList<NewsCard> = ArrayList()

    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("header",header.toJson())
    
        val jsonContent : ArrayList<HashMap<String,Any>> = ArrayList()
        for(i in 0..content.size - 1) {
            jsonContent.add(content[i].toJson())
        }
        out.put("content",jsonContent)
    
        val jsonRelated : ArrayList<HashMap<String,Any>> = ArrayList()
        for(i in 0..related.size-1) { 
            jsonRelated.add(related[i].toJson())
        }
        out.put("related",jsonRelated)
    
        return  out
    }

    override fun toString(): String {
        return "NewsData(header: $header ,contentSize: ${content.size} ,relatedSize: ${related.size})"
    }
}

enum class ErrorType(val type : String) {
    Network("Network"),
    NoHeadlines("NoHeadlines"),
    Extension("Extension"),
    None("None"),
}
class ErrorHandler {
    var msg : String = ""
    var type : ErrorType = ErrorType.None
    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("msg",msg)
        out.put("type",type.name)
        return  out
    }

}

abstract class ExtensionAbstract {
    var categories : ArrayList<String> = ArrayList()
    var errorHanlder : ErrorHandler = ErrorHandler()
    var version : String = "1.0.0";
    var iconLink : String = "placeholder.png";

    abstract  fun loadNewsHeadlines(type : String, count : Int, page : Int) : ArrayList<NewsCard>?
    open fun scrapeHomePage() :  ArrayList<NewsCard>? { return ArrayList(); }
    abstract  fun scrapeUrl(url: String) : NewsData?
}







