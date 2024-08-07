package anynews.extension.shared




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
        return "NewsCard(title: $title, date: $date, link: ${link.substring(0,17)}...)"
    }


}

class NewsPage(
    var header: HashMap<String,String>,
    var content: ArrayList<HashMap<String,String>>,
    ) {

    fun toJson() : HashMap<String,Any>{
        val out : HashMap<String,Any>  = HashMap()
        out.put("header",header)
        out.put("content",content)
        return  out
    }

    override fun toString(): String {
        return "NewsPage(header: $header)"
    }

}


abstract class ExtensionAbstract {
    var categories : ArrayList<String> = ArrayList();

    abstract  fun loadNewsHeadlines(type : String, count : Int, page : Int) : ArrayList<NewsCard>?
    abstract  fun scrapeUrl(url: String) : NewsPage?
}







