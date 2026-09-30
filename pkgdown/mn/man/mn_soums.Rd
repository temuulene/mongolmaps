% source: man/mn_soums.Rd md5 c0dfbb5d8e08d8774f413fe9f19215c4
\title{Монгол Улсын сумд ба Улаанбаатарын дүүргүүд}
\description{
330 сумыг Улаанбаатарын 9 дүүргийн хамт буцаана; дүүрэг нь сумтай ижил
түвшинд байдаг (\code{type} нь \code{"soum"} эсвэл \code{"district"}).
}
\arguments{
\item{aimag}{Зөвхөн эдгээр аймгийн сумдыг үлдээнэ (нэр эсвэл код).}

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
}
\value{
\code{sf} tibble; баганыг \code{\link[=mn_admin]{mn_admin()}}-аас үзнэ үү.
}
