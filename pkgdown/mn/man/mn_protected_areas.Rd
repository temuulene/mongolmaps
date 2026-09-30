% source: man/mn_protected_areas.Rd md5 08c6777744db715a4d719a70fb0d3bb4
\title{Тусгай хамгаалалттай газар}
\description{
Дэлхийн тусгай хамгаалалттай газрын мэдээллийн сангаас (WDPA) Монгол
Улсын байгалийн цогцолборт газар, дархан цаазат газар болон бусад
хамгаалалттай газар. Өгөгдлийг анх удаа UNEP-WCMC-ээс татаж, 90 хоногийн
дараа шинэчилнэ; дахин тараах эрхгүй тул багцад хэзээ ч орохгүй.
}
\arguments{
\item{within}{Зөвхөн эдгээр газар доторх хэсгийг үлдээнэ (нэр эсвэл код).}

\item{refresh}{\code{TRUE} бол одоо дахин татна.}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}
}
\value{
WDPA-гийн шинжүүдтэй \code{sf} tibble, үүнд \code{name_eng}, \code{desig_eng}
(ангилал), \code{iucn_cat}, \code{status_yr} багтана.
}
\section{Ашиглах нөхцөл}{

UNEP-WCMC and IUCN, Protected Planet: The World Database on Protected
Areas (WDPA), Cambridge, UK. \url{https://www.protectedplanet.net/en/legal}-ийг
үзнэ үү. WDPA-г арилжааны бус зорилгоор эх сурвалжийг дурдан ашиглаж
болно; дахин тарааж болохгүй.
}
