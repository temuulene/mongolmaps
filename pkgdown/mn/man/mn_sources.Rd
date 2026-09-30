% source: man/mn_sources.Rd md5 c8f9f1bab5e3b8630da6eae97a9df04f
\title{Өгөгдлийн эх сурвалж, лиценз, иш татах}
\description{
\code{mn_sources()} багцын өгөгдлийн давхарга бүрийг жагсаана: хэн нийлүүлдэг,
ямар лицензтэй, багцад ирдэг эсвэл татдаг, хэр шинэ. \code{mn_citation()}
газрын зургийн доор тавих эх сурвалжийн бичвэрийг буцаана;
\code{\link[=mn_map]{mn_map()}} үүнийг тайлбар мөрөөр автоматаар нэмнэ.
}
\arguments{
\item{layer, layers}{Давхаргын id, жишээ нь \code{"admin"}, \code{"khoroos"},
\code{"settlements"}. \code{NULL} бол бүх давхаргыг жагсаана.}
}
\value{
\code{mn_sources()}: \code{id}, \code{title}, \code{group}, \code{delivery}
(\code{"bundled"}, \code{"release"} эсвэл \code{"upstream"}), \code{provider}, \code{license},
\code{license_url}, \code{valid_on}, \code{source_url}, \code{attribution}, \code{notes}
баганатай tibble. \code{mn_citation()}: нэг тэмдэгт мөр.
}
\details{
Газрын зураг нийтлэхдээ өгөгдөл нийлүүлэгчийг дурдана уу. Ихэнх давхарга
эх сурвалжийг дурдахыг шаарддаг лицензтэй (CC BY, ODbL).
}
