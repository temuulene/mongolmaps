% source: man/mn_elevation.Rd md5 229a5b822f497fd001e3cfdcacbeb522
\title{Өндөршил ба рельефийн сүүдэр}
\description{
Copernicus DEM GLO-90-ээс Монгол Улсын гадаргуугийн растер.
}
\arguments{
\item{resolution}{\code{"1km"} эсвэл \code{"90m"}.}

\item{within}{Буцаах газар (нэр эсвэл код). Онлайнаар уншдаг нарийвчлалд
заавал өгнө: өндөршилд \code{"90m"}, газрын бүрхэвчид \code{"10m"}.}

\item{mask}{\code{TRUE} (анхдагч) бол Монголоос (эсвэл \code{within}-ээс) гадуурх
нүдийг \code{NA} болгоно.}

\item{crs}{Үр дүнгийн координатын систем. \code{NULL} (анхдагч) бол уртраг,
өргөрөг (EPSG:4326) хэвээр. Монголд тохирсон проекцод \code{"albers"},
\code{"lcc"} эсвэл \code{"utm"}-ийг (\code{\link[=mn_crs]{mn_crs()}}-ийг үзнэ үү), эсвэл
\code{\link[sf:st_crs]{sf::st_crs()}}-ийн хүлээн авах дурын утгыг өгнө.}

\item{angle, direction}{Рельефийн сүүдрийн нарны өндөр, чиглэл (градус).}
}
\value{
\code{terra} SpatRaster: метрээр илэрхийлсэн өндөршил, эсвэл 0-ээс 1-ийн
хоорондох рельефийн сүүдрийн утга.
}
\details{
\itemize{
\item \code{resolution = "1km"} (анхдагч): Альберсийн проекц дахь улсын тор,
нэг удаа (ойролцоогоор 5 МБ) татаж хадгална.
\item \code{resolution = "90m"}: анхны 90 м-ийн өгөгдөл, \code{within} дахь газарт
(аймаг эсвэл түүнээс жижиг) үүлнээс шууд уншина. Юу ч хадгалахгүй.
}

\code{mn_hillshade()} өндөршлөөс рельефийн сүүдэр тооцоолно; бусад давхаргын
дэвсгэрт тохиромжтой.
}
\section{Эх сурвалж}{

Copernicus DEM GLO-90, (c) DLR e.V. 2010-2014 and (c) Airbus Defence and
Space GmbH 2014-2018, provided under COPERNICUS by the European Union and
ESA. Эх сурвалжийг дурдан чөлөөтэй ашиглана.
}
