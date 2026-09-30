% source: man/mn_aimags.Rd md5 e7ba230ab630363ace25d0c4aa9d7091
\title{Монгол Улсын аймгууд}
\description{
21 аймаг ба аймгийн статустай нийслэл Улаанбаатарыг (\code{type = "capital"})
буцаана.
}
\arguments{
\item{region}{Зөвхөн эдгээр эдийн засгийн бүсийн аймгуудыг үлдээнэ, жишээ нь
\code{"Баруун бүс"} эсвэл \code{"Khangai region"}. Аймгийн нэрийг энд шууд өгч
сонгож ч болно.}

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
