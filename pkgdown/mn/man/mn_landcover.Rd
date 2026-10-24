% source: man/mn_landcover.Rd md5 47243521ca283af70da97b0f4de1840b
\title{Газрын бүрхэвч}
\description{
ESA WorldCover 2021-ийн газрын бүрхэвчийн ангилал. Улсын 1 км тор нь эх өгөгдлийн тойм давхаргаас модаль дахин түүвэрлэлтээр ерөнхийлсөн тул 10 м нүд бүрийн жинхэнэ олонхийн ангилал гэж үзэж болохгүй. 10 м хувилбарыг сонгосон жижиг талбайд үүлэн эхээс уншина.
}
\arguments{
\item{resolution}{\code{"1km"} эсвэл \code{"10m"}.}

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
Ангиллын \code{terra} SpatRaster.
}
\details{
\itemize{
\item \code{resolution = "1km"} (анхдагч): улсын тор, квадрат километр бүрийн
зонхилох ангилал, нэг удаа (ойролцоогоор 2 МБ) татна.
\item \code{resolution = "10m"}: \code{within} дахь газрын (сум, дүүрэг эсвэл жижиг
аймаг) анхны 10 м-ийн өгөгдөл, үүлнээс уншина.
}
}
\section{Эх сурвалж}{

ESA WorldCover 10 m 2021 v200, (c) ESA WorldCover project / contains
modified Copernicus Sentinel data (2021) processed by the ESA WorldCover
consortium. CC BY 4.0.
}
