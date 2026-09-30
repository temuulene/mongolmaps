% source: man/mn_bags.Rd md5 03bddd8a1bb503494bf72436195cf372
\title{Баг: хөдөөгийн хамгийн жижиг нэгж}
\description{
Баг бол сумын хуваарь; нийт 1,650 орчим баг бий. Тэдгээрийн код, нэр багцад
бий (\code{mn_codes("bag")}-ийг үзнэ үү), гэхдээ \strong{хил нь нээлттэй
нийтлэгдээгүй}: Үндэсний статистикийн хороо (ҮСХ) хүсэлтээр өгдөг. Багийн
хилийн файлтай болсон бол \code{mn_bags()} болон багцын бусад бүх функц
үүнийг ашиглаж чадна.
}
\arguments{
\item{aimag, soum}{Зөвхөн эдгээр аймаг, сумын багуудыг үлдээнэ (нэр эсвэл
код).}

\item{path}{\code{\link[sf:st_read]{sf::st_read()}}-ээр уншигдах багийн хилийн файлын зам.
Анхдагч нь \code{getOption("mongolmaps.bags_path")}.}

\item{resolution}{\code{"low"} (анхдагч) нь багцтай хамт ирдэг, ихэнх газрын
зурагт тохирох хялбаршуулсан хилийг ашиглана. \code{"high"} нь бүрэн
нарийвчлалтай хилийг нэг удаа (ойролцоогоор 10 МБ) татаж, хадгална;
\code{\link[=mn_cache_dir]{mn_cache_dir()}}-ийг үзнэ үү.}

\item{lang}{\code{name} баганын хэл: \code{"en"} (англи, ҮСХ-ны хүснэгтийн
бичлэгээр), \code{"mn"} (кирил) эсвэл \code{"mns"} (MNS 5217 стандартын
латин, тэмдэгттэй). Анхдагч утга нь \code{getOption("mongolmaps.lang", "en")}.}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}

\item{code_col}{Багийн кодын баганын нэр: ҮСХ-ны 7 оронтой код
(\code{"1830151"}) эсвэл P-код (\code{"MN830151"}). \code{NULL} бол автоматаар олно.}

\item{check_nesting}{\code{TRUE} (анхдагч) бол баг сумаасаа гадуур байвал
зогсоно.}
}
\value{
\code{sf} tibble; баганыг \code{\link[=mn_admin]{mn_admin()}}-аас үзнэ үү.
}
\section{Багийн хил авах}{

ҮСХ-нд (\href{mailto:international@nso.mn}{international@nso.mn}) хандаж, багийн
хилийг баг бүрийн ҮСХ-ны кодтой shapefile эсвэл GeoPackage хэлбэрээр
хүснэ үү. Дараа нь файлыг \code{mn_bags(path = ...)}-д өгөх, эсвэл нэг удаа
\code{options(mongolmaps.bags_path = "path/to/bags.gpkg")}-ээр бүртгэнэ (байнга
ашиглах бол энэ мөрийг \code{.Rprofile}-даа нэмнэ). Бүртгэсэн багийг
\code{mn_admin("bag")} мөн буцааж, \code{\link[=mn_join]{mn_join()}} ашиглана.

\code{mn_read_bags()} файлыг шалгана: баг бүр мэдэгдэж буй кодтой, өөрийн сум
дотор байх ёстой.
}
