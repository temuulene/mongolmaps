% source: man/mn_admin.Rd md5 71408da3cf7f08a8c7f33af3462824c0
\title{Монгол Улсын засаг захиргааны хил, дурын түвшинд}
\description{
\code{\link[=mn_country]{mn_country()}}, \code{\link[=mn_regions]{mn_regions()}}, \code{\link[=mn_aimags]{mn_aimags()}},
\code{\link[=mn_soums]{mn_soums()}}, \code{\link[=mn_khoroos]{mn_khoroos()}}, \code{\link[=mn_bags]{mn_bags()}} функцүүдийн
цаад хөдөлгүүр. Бүх функц ижил баганатай үр дүн буцаадаг тул өөр өөр
түвшний газрын зургийг нэгтгэж, өгөгдөлтэй адилхан холбож болно.
}
\arguments{
\item{level}{Буцаах түвшин:
\itemize{
\item \code{"country"}: Монгол Улс.
\item \code{"region"}: ҮСХ-ны ашигладаг эдийн засгийн таван бүс (Баруун, Хангай,
Төв, Зүүн, Улаанбаатар).
\item \code{"aimag"}: 21 аймаг ба нийслэл Улаанбаатар.
\item \code{"soum"}: 330 сум ба Улаанбаатарын 9 дүүрэг.
\item \code{"bag"}: Улаанбаатарын 204 хороо, мөн багийн хилийн файл бүртгэсэн
бол хөдөөгийн багууд (\code{\link[=mn_bags]{mn_bags()}}-ийг үзнэ үү).
}

\code{"province"}, \code{"district"}, \code{"adm1"}, \code{"khoroo"} зэрэг ижил утгатай
нэрийг ч хүлээн авна.}

\item{within}{Зөвхөн эдгээр газар доторх нэгжүүд, эсвэл эдгээр газрыг өөрсдийг
нь үлдээнэ: дурын түвшний нэр эсвэл код, жишээ нь \code{"Ховд"}, \code{"MN84"},
\code{"Баруун бүс"}.}

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
Нэгж бүрт нэг мөртэй, дараах баганатай \code{sf} tibble:
\describe{
\item{pcode}{Давтагдашгүй код (\code{\link[=mn_codes]{mn_codes()}}-ийг үзнэ үү).}
\item{name}{\code{lang}-аар сонгосон хэл дээрх нэр.}
\item{name_en, name_mn, name_mns}{Англи, кирил, MNS латин нэр.}
\item{level, type}{Түвшин (\code{"aimag"}, \code{"soum"}, ...) ба төрөл
(\code{"capital"}, \code{"district"}, \code{"khoroo"}, ...).}
\item{number}{Сум эсвэл дүүрэг доторх баг, хорооны дугаар.}
\item{iso_code}{ISO 3166-2 код (зөвхөн аймагт).}
\item{nso_code}{ҮСХ-ны статистикийн хүснэгтэд хэрэглэдэг код.}
\item{parent_pcode, region_pcode, aimag_pcode, soum_pcode}{Энэ нэгжийг
агуулах дээд нэгжүүдийн код.}
\item{area_km2}{Бүрэн нарийвчлалтай хилээр тооцсон талбай, км².}
\item{geometry}{Олон олигон хил.}
}
}
