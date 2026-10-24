% source: man/mn_sources.Rd md5 48a066099a8b49f10342fb5cb1ece0d5
\title{Өгөгдлийн эх сурвалж, лиценз, иш татах}
\description{
Эх үүсвэр, үйлчилгээ үзүүлэгч, лиценз, эхийн хувилбар, геометр болон кодын үе, эрх бүхий эсэхийг жагсаана. Эхийн авсан огноо нь захиргааны хил хүчин төгөлдөр болсон огноотой адил биш. \code{mn_citation()} нь давхаргын id эсвэл мета өгөгдөлтэй объектын эхийг ишлэх текст буцаана.
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
