% source: man/mn_settlements.Rd md5 393a3f5f571338f3571f8ba3e7ce4290
\title{Суурин: нийслэл, аймгийн төв, сумын төв}
\description{
Улаанбаатар, 21 аймгийн төв, сумдын төвийн цэг; газрын зурагт нэр
тавихад тохиромжтой. Байршлыг Wikidata-аас авсан; тэнд координатгүй цөөн
сумын хувьд сумын дотор орших цэгийг ашигласан (\code{location_source}-ийг
үзнэ үү).
}
\arguments{
\item{type}{Аль суурин буцаах: \code{"capital"}, \code{"aimag_centre"},
\code{"soum_centre"}-ийн аль нь ч. Анхдагч нь бүгд.}

\item{within}{Зөвхөн эдгээр газар доторх суурийг үлдээнэ (нэр эсвэл код).}

\item{lang}{\code{name} баганын хэл: \code{"en"} (англи, ҮСХ-ны хүснэгтийн
бичлэгээр), \code{"mn"} (кирил) эсвэл \code{"mns"} (MNS 5217 стандартын
латин, тэмдэгттэй). Анхдагч утга нь \code{getOption("mongolmaps.lang", "en")}.}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}
}
\value{
Цэгийн \code{sf} tibble, баганууд: \code{admin_pcode} (суурин нь аль аймаг эсвэл
сумын төв болох), \code{soum_pcode}, \code{aimag_pcode}, \code{type}, \code{name},
\code{name_en}, \code{name_mn}, \code{name_mns}, \code{location_source}.
}
