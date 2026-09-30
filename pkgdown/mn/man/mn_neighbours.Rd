% source: man/mn_neighbours.Rd md5 16a66c1b483102f2e6685aa15d044526
\title{Газрын зургийн орчин: хөрш орнууд, гол мөрөн, нуур}
\description{
Монголын газрын зурагт эргэн тойрон, усыг нэмэх давхаргууд.
}
\arguments{
\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}

\item{detail}{Томоохон гол, нуурт \code{"major"} (багцад), OpenStreetMap-ийн
бүх объектод \code{"all"} (татаж авна).}

\item{within}{Зөвхөн эдгээр газар доторх объектыг үлдээнэ (нэр эсвэл код).}
}
\value{
\code{sf} tibble. Natural Earth-ийн давхарга \code{name_en} ба \code{scalerank}
(бага нь илүү чухал) баганатай. OpenStreetMap-ийн давхарга \code{osm_id},
\code{name}, \code{name_en}, \code{name_mn}, \code{class} (жишээ нь \code{"river"},
\code{"stream"}, \code{"lake"}, \code{"reservoir"}) баганатай.
}
\details{
\itemize{
\item \code{mn_neighbours()}: Монголын эргэн тойрон дахь Орос, Хятад,
Казахстаны хэсэг (Natural Earth, нийтийн өмч), Монголоос 300 км-ийн
хүрээгээр тасалсан.
\item \code{mn_rivers()}, \code{mn_lakes()}: \code{detail = "major"} (анхдагч) бол
Natural Earth-ийн томоохон гол, нуур, багцтай ирнэ. \code{detail = "all"}
бол OpenStreetMap-д зурагдсан бүх гол, горхи, суваг, усан сан (ODbL),
нэг удаа (ойролцоогоор 20 МБ) татаж хадгална.
}
}
