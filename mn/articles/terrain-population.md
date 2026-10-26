# Газрын гадарга, бүрхэвч, хүн амыг зурах

Растер нь нүд бүртээ өндөршил, хүн ам зэрэг утга хадгалсан тор юм.
Эдгээр жишээ улсын 1 км-ийн торыг нэг удаа татаж хадгална. Эхлээд terra,
ggplot2-ийг суулгана:

``` r

install.packages(c("terra", "ggplot2"))
```

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
library(ggplot2)
```

| Функц | Утга | Эх сурвалж |
|----|----|----|
| [`mn_elevation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md) | Өндөршил, метрээр | Copernicus DEM GLO-90 |
| [`mn_hillshade()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_elevation.md) | Өндөршлөөс тооцсон сүүдэрлэл | Copernicus DEM GLO-90 |
| [`mn_landcover()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_landcover.md) | Газрын бүрхэвчийн ангилал | ESA WorldCover 2021 |
| `mn_population(2025)` | Нүд бүрийн тооцоолсон хүн ам | WorldPop R2025A |

## Өндөршил

``` r

elevation <- mn_elevation()
mn_map(elevation, title = "Өндөршил") +
  geom_sf(data = mn_aimags(), fill = NA, colour = "white", linewidth = 0.2) +
  labs(fill = "Метр")
```

![Монгол Улсын өндөршил,
метрээр.](terrain-population_files/figure-html/elevation-1.png)

## Сүүдэрлэсэн газрын гадарга

Сүүдэрлэл нь хэлбэрийг тодруулсан хийсвэр гэрэлтүүлэг; өндөршил эсвэл
ургамлын хэмжилт биш.

``` r

mn_map(mn_hillshade()) +
  geom_sf(data = mn_aimags(), fill = NA, colour = "white", linewidth = 0.3) +
  geom_sf(data = mn_settlements(type = c("capital", "aimag_centre")),
          colour = "firebrick", size = 1) +
  labs(title = "Газрын гадарга, аймгийн төвүүд",
       caption = paste(strwrap(mn_citation(c("admin", "elevation_1km", "settlements")), width = 95), collapse = "\n"))
```

![Сүүдэрлэсэн газрын гадарга, аймгийн хил,
төвүүд.](terrain-population_files/figure-html/hillshade-1.png)

`within`-ээр нэг газар сонгож болно. Энэ жишээ хадгалсан 1 км-ийн тороо
ашиглах тул тусдаа нарийн файл татахгүй.

``` r

mn_map(mn_hillshade(within = "Ulaanbaatar")) +
  geom_sf(data = mn_ub_districts(), fill = NA, colour = "firebrick", linewidth = 0.4) +
  labs(title = "Улаанбаатар орчмын газрын гадарга", subtitle = "1 км-ийн тор",
       caption = paste(strwrap(mn_citation(c("admin", "khoroos", "elevation_1km")), width = 95), collapse = "\n"))
```

![Улаанбаатар орчмын 1 км-ийн газрын гадаргын тор, дүүргийн
хил.](terrain-population_files/figure-html/local-terrain-1.png)

## Газрын бүрхэвч

``` r

mn_map(mn_landcover(), title = "Газрын бүрхэвч, 2021") +
  labs(fill = "Бүрхэвч") +
  theme(legend.text = element_text(size = 8))
```

![2021 оны газрын бүрхэвчийн
ангилал.](terrain-population_files/figure-html/landcover-1.png)

1 км-ийн давхарга нь 10 м-ийн эх сурвалжийг ерөнхийлсөн зураг. Улсын
тоймд тохиромжтой ч жижиг хэсэг бүрийг нарийн илэрхийлэхгүй.

## Хүн ам

WorldPop нь **нүд бүрийн хүн амын тооцоо**. ҮСХ-ны албан ёсны дүнгээс
зөрж болно. Сүүлийн тооллогоос хойших онууд нь төсөөлөл юм.

[`mn_zonal()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_zonal.md)
олон өнцөгтийн доторх утгыг нэгтгэнэ. Анхны хүн амын тор дээр тооцоод,
талбайд хувааж нягтрал гаргана. Хурдан ажиллуулахын тулд нэг аймгаас
эхэлнэ. Улсын дүн гаргахдаа `within = "Khovd"` болон `aimag = "Khovd"`
хоёуланг хасна; бүх сумыг нэгтгэхэд илүү удаан.

``` r

pop <- mn_population(2025, within = "Khovd")
soums <- mn_zonal(pop, mn_soums(aimag = "Khovd"), fun = "sum", name = "population")
soums$density <- soums$population / soums$area_km2
soums$density[soums$density == 0] <- NA_real_
mn_map(soums, fill = density, trans = "log10",
       title = "Хүн амын тооцоолсон нягтрал, 2025",
       na_label = "Тэг үнэлгээ эсвэл торон өгөгдөлгүй") +
  labs(fill = "Хүн/км²", subtitle = "Ховдын сумд | WorldPop тооцоолол")
```

![Ховд аймгийн сумдын 2025 оны хүн амын тооцоолсон нягтрал,
WorldPop.](terrain-population_files/figure-html/population-1.png)

Логарифмын өнгөний хуваарьт тэгийг дүрслэх боломжгүй. Энэ зурагт тэг
тооцоог торон өгөгдөлгүй газартай хамт саарлаар харуулсан. Анхны
`population` багана өөрчлөгдөөгүй. Албан ёсны тоонд [ҮСХ-ны өгөгдөл
холбох
жишээ](https://temuulene.github.io/mongolmaps/mn/articles/joining-data.md)-г
ашиглана.

Хил дээр нүдний хамрагдсан хувиар жигнэнэ. Энэ нь нүд дотор хүн ам жигд
тархсан гэж үздэг. 1 км-ийн тор барилга тус бүрийн хүн амыг тогтоохгүй.
Дундаж нь нүдний хамралтын хувиар жигнэгддэг; өргөрөг, уртрагийн тор
дээр энэ нь бодит талбайн жин биш. Медианд `exact = FALSE` хэрэглэнэ.

## Тусгай хамгаалалттай газар

UNEP-WCMC-ээс татаж, 90 хоногийн дараа шинэчилнэ. Ашиглахын өмнө
нөхцөлийг шалгана. Эх өгөгдөл багцад ордоггүй, дахин түгээгддэггүй.

``` r

pa <- mn_protected_areas()
mn_map(mn_aimags()) +
  geom_sf(data = pa, fill = "#238b45", alpha = 0.6, colour = NA) +
  labs(title = "Тусгай хамгаалалттай газар", subtitle = "Ногоон: WDPA-д бүртгэлтэй газар",
       caption = paste(strwrap(mn_citation(c("admin", "wdpa")), width = 95), collapse = "\n"))
```

![Монгол Улсын тусгай хамгаалалттай
газрууд.](terrain-population_files/figure-html/protected-1.png)

## Илүү нарийн зураг хэрэгтэй үед

Доорх нь нэмэлт жор; дээрх 1 км-ийн зурагт ашиглаагүй. Эх сурвалжаас
шууд унших тул ажиллуулах бүрт интернет хэрэгтэй. Энэ гарын авлагыг
бүтээхэд ажиллуулаагүй.

``` r

# Limit fine grids to a small area.
elevation_90m <- mn_elevation("90m", within = "Nalaikh")
cover_10m <- mn_landcover("10m", within = "Nalaikh")
mn_map(elevation_90m)
mn_map(cover_10m)
```

`mn_population(2025, resolution = "100m")` нь улсын илүү нарийн хүн амын
тор татна. Нарийвчлал ихсэх нь загварын тодорхойгүй байдлыг арилгахгүй.
Шинжилгээнд анхны торыг ашиглана. Тор солиход үлдсэн нийт дүн
хадгалагдах ч орон нутгийн хуваарилалт өөрчлөгдөнө.
