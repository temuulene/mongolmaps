# Зам, ус, суурин газар нэмэх

Нэмэлт давхаргууд нь газар хаана байгааг, хэрхэн холбогддогийг ойлгоход
тусална. Гол, нуур, суурин газрын жижиг давхаргууд багцад бий. Замын
өгөгдлийг анхны хэрэглээнд татаж хадгална.

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
library(ggplot2)
```

| Давхарга | Функц | Анхны хэрэглээ |
|----|----|----|
| Нийслэл, аймаг, сумын төв | [`mn_settlements()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_settlements.md) | Багцад бий |
| Хөрш орнууд | [`mn_neighbours()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md) | Багцад бий |
| Голлох гол, нуур | [`mn_rivers()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md), [`mn_lakes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_neighbours.md) | Багцад бий |
| Илүү дэлгэрэнгүй усны объект | `mn_rivers("all")`, `mn_lakes("all")` | Татна |
| Авто зам, гудамж | [`mn_roads()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md) | Ойролцоогоор 30 МБ татна |
| Төмөр зам, өртөө, нисэх буудал | [`mn_railways()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md), [`mn_airports()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md) | Татна |
| Газрын зурагт бүртгэлтэй суурин | [`mn_places()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md) | Татна |

“All” нь эх сурвалжид байгаа бүх объект гэсэн үг; бүрэн тооллого биш.
OpenStreetMap-ийн хамралт газар бүрт өөр.

## Өгөгдөл татахгүйгээр эхлэх

``` r

mn_map(mn_aimags(), context = TRUE) +
  geom_sf(data = mn_settlements(type = c("capital", "aimag_centre")),
          colour = "firebrick", size = 1) +
  labs(title = "Аймаг, ус, суурин газрууд",
       caption = paste(strwrap(mn_citation(c("admin", "naturalearth", "settlements")), width = 95), collapse = "\n"))
```

![Аймгийн хил, гол ус, аймгийн
төвүүд.](thematic-layers_files/figure-html/bundled-1.png)

## Улсын тээврийн сүлжээ нэмэх

[`mn_roads()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_roads.md)
анхдагчаар гол замыг сонгоно. Авто замыг нарийн, төмөр замыг бүдүүн
зурвал ялгахад хялбар.

``` r

mn_map(mn_aimags(), context = TRUE) +
  geom_sf(data = mn_roads(), colour = "firebrick", linewidth = 0.25) +
  geom_sf(data = mn_railways(), colour = "black", linewidth = 0.5) +
  geom_sf(data = mn_airports(), shape = 17, colour = "navy", size = 1.5) +
  labs(title = "Гол авто зам, төмөр зам, нисэх буудал",
       subtitle = "Авто зам: улаан | Төмөр зам: хар | Нисэх буудал: цэнхэр гурвалжин",
       caption = paste(strwrap(mn_citation(c("admin", "naturalearth", "osm_roads", "osm_transport")), width = 95), collapse = "\n"))
```

![Улсын авто зам, төмөр зам, нисэх
буудал.](thematic-layers_files/figure-html/country-1.png)

## Нэг аймгийг харуулах

`within` газар нутгийг сонгож, шугамыг хил дээр нь тасална. Доорх жишээ
дэлгэрэнгүй усны болон замын давхаргыг татна.

``` r

aimag <- "Khuvsgul"
mn_map(mn_soums(aimag = aimag)) +
  geom_sf(data = mn_lakes("all", within = aimag), fill = "#9ecae1", colour = NA) +
  geom_sf(data = mn_rivers("all", within = aimag), colour = "#4292c6", linewidth = 0.2) +
  geom_sf(data = mn_roads(within = aimag), colour = "grey30", linewidth = 0.3) +
  geom_sf(data = mn_settlements(within = aimag), size = 1) +
  labs(title = "Хөвсгөл: сум, ус, зам, сумын төв",
       caption = paste(strwrap(mn_citation(c("admin", "osm_roads", "osm_water", "settlements")), width = 95), collapse = "\n"))
```

![Хөвсгөл аймгийн сум, ус, зам, сумын
төвүүд.](thematic-layers_files/figure-html/khuvsgul-1.png)

## Хотын гудамжийг ойртуулж харах

Бүх хотын оронд цөөн дүүрэг сонговол гудамж илүү тод харагдана. Энгийн
дэвсгэр нь зам, хорооны заагийг ялгахад тусална.

``` r

# Bayangol, Chingeltei, Sukhbaatar
central <- c("MN1107", "MN1125", "MN1119")
streets <- mn_roads(class = c("main", "minor"), within = central)
#> Re-reading with feature count reset from 20405 to 20404
mn_map(mn_khoroos(district = central)) +
  geom_sf(data = streets, aes(linewidth = class), colour = "grey25") +
  scale_linewidth_manual(values = c(main = 0.45, minor = 0.12),
                         breaks = c("main", "minor"), labels = c("Гол", "Туслах")) +
  labs(title = "Улаанбаатарын төвийн гудамж, зам", linewidth = "Зам",
       caption = paste(strwrap(mn_citation(c("admin", "khoroos", "osm_roads")), width = 95), collapse = "\n"))
```

![Төвийн гурван дүүргийн хорооны хил, гол болон туслах
замууд.](thematic-layers_files/figure-html/ub-1.png)

## Интернетгүй ажиллах, эх сурвалжийг дурдах

[`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md)
хадгалсан хавтсыг,
[`mn_cache_list()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md)
файлуудыг харуулна. Интернетгүй болохоос өмнө хэрэгтэй давхаргаа татна:

``` r

mn_download(c("osm_roads", "osm_transport", "osm_water"))
```

Давхарга хослуулахдаа бүх эх сурвалжийг тайлбарт оруулна. OpenStreetMap
нь Open Database Licence-тэй.
[`mn_citation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)
ишлэх текстийг өгнө.
