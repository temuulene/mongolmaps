% source: man/mn_cache_dir.Rd md5 ffbf40749aff6dd0e94e06e243b2b904
\title{Татаж авсан газрын зургийн өгөгдлийг удирдах}
\description{
Бүрэн нарийвчлалтай хил болон томоохон сэдэвчилсэн давхаргуудыг анх
ашиглахад татаж, кэш хавтаст хадгалдаг тул дараагийн удаа интернетгүй
ажиллана.
}
\arguments{
\item{layers}{Давхаргын id эсвэл бүлэг (\code{\link[=mn_sources]{mn_sources()}}-ийг үзнэ үү),
жишээ нь \code{"admin_high"}, \code{"osm"}. \code{NULL} (\code{mn_cache_clear()}-ийн
анхдагч) бол бүгдийг; \code{"all"} (\code{mn_download()}-ийн анхдагч) бол татаж
болох бүх давхаргыг.}

\item{old_versions}{\code{TRUE} бол \code{mn_cache_clear()} зөвхөн багцын өмнөх
хувилбаруудаас үлдсэн өгөгдлийг устгана.}
}
\value{
\code{mn_cache_dir()}: зам. \code{mn_cache_list()}: кэшд буй файл бүрт нэг
мөртэй tibble. \code{mn_cache_clear()} ба \code{mn_download()}: хамаарах замууд,
харагдахгүйгээр.
}
\details{
\itemize{
\item \code{mn_cache_dir()} кэш хавтсыг буцаана.
\code{options(mongolmaps.cache_dir = "path")}-ээр өөрчилнө.
\item \code{mn_cache_list()} кэшд юу байгааг жагсаана.
\item \code{mn_cache_clear()} кэшийн файлыг устгана.
\item \code{mn_download()} давхаргыг одоо татна, жишээ нь интернетгүй газар
хээрийн ажилд гарахын өмнө. Давхаргын id-г \code{\link[=mn_sources]{mn_sources()}}-ээс
харна уу.
}
}
