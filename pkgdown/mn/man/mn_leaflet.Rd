% source: man/mn_leaflet.Rd md5 ba7aa52a67ed12b9c725c8dcd78457b9
\title{leaflet-ээр интерактив газрын зураг}
\description{
Багцын дурын газрын зураг, эсвэл холбосон өгөгдлийг суурь зурагтай,
хулганаар заахад нэр гардаг, дарахад мэдээлэл харуулдаг интерактив вэб
газрын зураг дээр харуулна.
}
\arguments{
\item{x}{\code{sf} объект; анхдагч нь аймгууд.}

\item{fill}{Будах багана (хашилтгүй), эсвэл нэг өнгө.}

\item{popup}{Цонхонд харуулах бичвэрийн багана (хашилтгүй). Анхдагч цонх
англи, монгол нэр, код, \code{fill} утгыг харуулна.}

\item{lang}{Хулганаар заахад гарах нэрийн хэл: \code{"en"}, \code{"mn"} эсвэл
\code{"mns"}.}

\item{tiles}{\link[leaflet:providers]{leaflet::providers}-оос суурь зураг, жишээ нь
\code{"CartoDB.Positron"} (анхдагч) эсвэл \code{"OpenStreetMap"}.}

\item{opacity}{Будгийн тунгалаг бус байдал, 0-ээс 1.}
}
\value{
\code{leaflet} htmlwidget.
}
