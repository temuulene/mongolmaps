% source: man/mn_cache_dir.Rd md5 0f6b10c858f04f7c5fef8e291e4f977c
\title{Татаж авсан газрын зургийн өгөгдлийг удирдах}
\description{
\code{mn_assets()} нь татаж болох файлууд, WorldPop-ийн он, нарийвчлалыг жагсаана. \code{mn_download()} урьдчилан татаж, \code{mn_cache_list()} кэшийг харуулж, \code{mn_cache_verify()} шалгах нийлбэрийг дахин тооцно. \code{mn_cache_clear()} сонгосон файлыг цэвэрлэнэ. Хуучин хувилбарыг автоматаар устгахгүй.
}
\arguments{
\item{layers}{Давхаргын id эсвэл бүлэг. \code{"all"} нь тогтмол файлуудыг татах бөгөөд WorldPop-ийн бүх он, нарийвчлалыг татахгүй. Жишээ нь \code{"worldpop_2025_1km"}-ийг тусад нь сонгоно. \code{"worldpop"} нь бүх хувилбарыг сонгоно.}

\item{old_versions}{\code{TRUE} бол \code{mn_cache_clear()} зөвхөн багцын өмнөх
хувилбаруудаас үлдсэн өгөгдлийг устгана.}
}
\value{
Кэшийн зам, файлын мэдээлэл, татах файлын бүртгэл эсвэл шалгах нийлбэрийн тайлан. Татах болон цэвэрлэх функц нөлөөлсөн замуудыг үл харагдах байдлаар буцаана.
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
