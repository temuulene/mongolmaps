% source: man/mn_zonal.Rd md5 ecf18dd96392c97455d148c7f6e7329f
\title{Растерийг газрын зургийн нэгжээр нэгтгэх}
\description{
\code{x}-д нэгж бүр доторх растерийн нүдний нэгтгэлийг шинэ баганаар нэмнэ,
жишээ нь сум бүрийн нийт хүн ам, аймаг бүрийн дундаж өндөршил.
}
\arguments{
\item{r}{\code{terra} SpatRaster (нэг давхаргатай), жишээ нь
\code{\link[=mn_population]{mn_population()}}-ийн үр дүн.}

\item{x}{Олигоны \code{sf} объект, жишээ нь \code{\link[=mn_soums]{mn_soums()}}. Анхдагч нь
аймгууд.}

\item{fun}{Нэгтгэх функцийн нэр: \code{"sum"} (анхдагч), \code{"mean"}, \code{"min"},
\code{"max"} эсвэл \code{"median"}.}

\item{name}{Шинэ баганын нэр.}
}
\value{
Шинэ баганатай \code{x}.
}
