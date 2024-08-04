package anynews.extension.Extension


enum class NewsType {
    Politics,
    Sport,
    General
}

class NewsCard(
    var date : String,
    var title: String,
    var imgURL: String,
    var link: String,
    ) {
}


abstract class Extension {
    abstract fun loadNewsHeadlines(type : NewsType, count : Integer, page : Integer) : List<NewsCard>
}