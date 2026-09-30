% source: man/mn_roads.Rd md5 bc287c5f4d483f33f161c39dae5cd77c
\title{OpenStreetMap-аас авто зам, төмөр зам, нисэх буудал, суурин}
\description{
Хүмүүнлэгийн OpenStreetMap багийн (HOT) экспортоос бэлтгэсэн тээвэр,
суурин газрын OpenStreetMap давхаргууд. Давхарга бүрийг нэг удаа татаж
(авто зам ойролцоогоор 30 МБ, бусад нь бага) хадгална;
\code{\link[=mn_download]{mn_download()}}-ийг үзнэ үү.
}
\arguments{
\item{class}{Үлдээх замын ангилал: \code{"main"} (хурдны замаас гуравдугаар
зэрэглэлийн зам хүртэл, анхдагч), \code{"minor"} (орон сууцны, үйлчилгээний,
ангилалгүй гудамж), \code{"track"}, \code{"path"} эсвэл \code{"all"}.}

\item{within}{Зөвхөн эдгээр газар доторх объектыг үлдээнэ (хилтэй дурын
түвшний нэр эсвэл код, жишээ нь \code{"Улаанбаатар"}, \code{"Ховд"}).}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}

\item{stations}{\code{TRUE} бол \code{mn_railways()} шугамын оронд төмөр замын
өртөөг цэгээр буцаана.}

\item{type}{\code{mn_places()}-ийн суурины төрөл: \code{"city"}, \code{"town"},
\code{"village"}, \code{"hamlet"}, \code{"suburb"}, \code{"isolated_dwelling"}-ийн аль
нь ч.}

\item{lang}{\code{name} баганын хэл: \code{"en"} (англи, ҮСХ-ны хүснэгтийн
бичлэгээр), \code{"mn"} (кирил) эсвэл \code{"mns"} (MNS 5217 стандартын
латин, тэмдэгттэй). Анхдагч утга нь \code{getOption("mongolmaps.lang", "en")}.}
}
\value{
\code{osm_id}, \code{name} (OpenStreetMap-д байгаа бол сонгосон хэлээр),
\code{name_en}, \code{name_mn} болон давхарга бүрийн баганатай \code{sf} tibble:
авто замд \code{highway}, \code{class}, \code{surface}; төмөр замд \code{railway};
суурин газарт \code{place}, \code{population}.
}
\details{
Нэг газрын давхарга авахын тулд \code{within}-ийг ашиглана: зөвхөн тухайн
газрын хүрээ доторх объектыг дискнээс уншаад, шугамыг хил дээр нь тасална.
}
\section{Лиценз}{

OpenStreetMap-ийн өгөгдөл Open Database License (ODbL) лицензтэй.
Газрын зураг нийтлэхдээ "(c) OpenStreetMap contributors" гэж дурдана уу;
\code{mn_citation("osm_roads")} бичвэрийг нь өгнө.
}
