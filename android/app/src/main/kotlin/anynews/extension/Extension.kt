package anynews.extension.shared


enum class NewsType {
    Politics,
    Sport,
    General
}

class NewsCard(
    var title: String,
    var date : String,
    var imgURL: String,
    var link: String,
    ) {

    override fun toString(): String {
        return "NewsCard(title: $title, date: $date, link: ${link.substring(0,17)}...)"
    }
}


abstract class ExtensionAbstract {
    abstract  fun loadNewsHeadlines(type : NewsType, count : Int, page : Int) : ArrayList<NewsCard>
}