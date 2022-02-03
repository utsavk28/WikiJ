module Articles

export Article, save, find
using ...Database, MySQL, JSON, DataFrames

struct Article
    content::String
    links::Vector{String}
    title::String
    image::String
    url::String
    Article(; content = "", links = String[], title = "", image = "", url = "") =
        new(content, links, title, image, url)
    Article(content, links, title, image, url) = new(content, links, title, image, url)
end

function find(url)::Vector{Article}
    articles = Article[]
    println(url)
    result = DBInterface.execute(CONN, "SELECT * FROM `articles` WHERE url = '$url'")
    result = DataFrame(result)
    print(result)
    println(nrow(result))
    nrow(result) == 0 && return articles
    links_arr = split(result[1, :links][3:end-2], ",")
    push!(articles,
        Article(result[1, :content],
            links_arr,
            result[1, :title],
            result[1, :image],
            result[1, :url])
    )
    articles
end

function save(a::Article)
    sql = "INSERT IGNORE INTO articles (title, content, links, image, url) VALUES (?, ?, ?, ?, ?)"
    stmt = DBInterface.prepare(CONN, sql)
    result = DBInterface.execute(stmt, [a.title, a.content, JSON.json(a.links), a.image, a.url])
end

function createtable()
    sql = """
    CREATE TABLE `articles` (
    `title` varchar(1000),
    `content` text,
    `links` text,
    `image` varchar(500),
    `url` varchar(500),
    UNIQUE KEY `url` (`url`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    """
    DBInterface.execute(CONN, sql, mysql_store_result = true)
end

end
