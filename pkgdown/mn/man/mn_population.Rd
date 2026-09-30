% source: man/mn_population.Rd md5 a5d1dc56a0cfd2792c197df7512b41a6
\title{Хүн амын тор}
\description{
WorldPop-ын нүд бүрийн хүн амын тооцоо (2015-2030 он, суурьшлын бүсээр
хязгаарласан), 1 км эсвэл 100 м нарийвчлалтай. Тухайн оны улсын файлыг
WorldPop-оос нэг удаа (1 км-т 0.4 МБ, 100 м-т 11 МБ) татаж хадгална.
Аймаг, сум, хороогоор нэгтгэхэд \code{\link[=mn_zonal]{mn_zonal()}}-ийг ашиглана.
}
\arguments{
\item{year}{2015-2030 оны хооронд он (сүүлийн тооллогоос хойших он нь
төсөөлөл).}

\item{resolution}{\code{"1km"} эсвэл \code{"100m"}.}

\item{within}{Буцаах газар (нэр эсвэл код). Онлайнаар уншдаг нарийвчлалд
заавал өгнө: өндөршилд \code{"90m"}, газрын бүрхэвчид \code{"10m"}.}

\item{mask}{\code{TRUE} (анхдагч) бол Монголоос (эсвэл \code{within}-ээс) гадуурх
нүдийг \code{NA} болгоно.}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}
}
\value{
Нүд бүрийн хүний тоо бүхий \code{terra} SpatRaster.
}
\section{Эх сурвалж}{

WorldPop (www.worldpop.org), Global 2015-2030 constrained population
counts, release R2025A. CC BY 4.0.
}
