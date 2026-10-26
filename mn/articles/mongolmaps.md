# mongolmaps багцыг ашиглаж эхлэх

mongolmaps нь Монголын хил зааг, газар нутгийн нэр, газрын зураг зурах
функцүүдийг агуулна. Хялбаршуулсан хил зааг багцад багтсан тул доорх
жишээнүүд интернетгүй ажиллана.

Багцуудыг нэг удаа суулгана:

``` r

install.packages(c("mongolmaps", "ggplot2"))
```

## Эхний газрын зургаа зурах

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
library(ggplot2)

mn_map(mn_aimags(), title = "Монгол Улс: аймаг, нийслэл")
```

![Монгол Улсын аймаг, нийслэлийн хил
зааг.](mongolmaps_files/figure-html/first-map-1.png)

[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md)
хил заагийг авч,
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md)
зурна. Гарсан зураг нь ggplot объект тул ggplot2-ийн функцээр өөрчилж
болно.

## Хил заагийн түвшинг сонгох

Монгол Улс 21 аймаг, нийслэл Улаанбаатартай. Аймаг сумдад, сум багуудад
хуваагдана. Улаанбаатар дүүргүүдэд, дүүрэг хороодод хуваагдана.

| Хэрэгцээ | Функц | Багцад багтсан эсэх |
|----|----|----|
| Улсын хил | [`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md) | Тийм |
| Эдийн засгийн дөрвөн бүс, Улаанбаатар | [`mn_regions()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md) | Тийм |
| 21 аймаг, нийслэл | [`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md) | Тийм |
| 330 сум, 9 дүүрэг | [`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md) | Тийм |
| Нийслэлийн хил | [`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md) | Тийм |
| Есөн дүүрэг | [`mn_ub_districts()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md) | Тийм |
| 204 хороо | [`mn_khoroos()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md) | Тийм, албан бус хил |
| Хөдөөгийн баг | [`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md) | Нэр, код бий; хил заагийн файлаа өгнө |

Функцүүд нь дүрс хадгалах `geometry` баганатай `sf` хүснэгт буцаана.
`pcode` нь давтагдахгүй код, `name` нь нэр, `nso_code` нь ҮСХ-ны код,
`parent_pcode` нь харьяалах нэгжийн код, `area_km2` нь талбай.

``` r

aimags <- mn_aimags()
knitr::kable(head(sf::st_drop_geometry(aimags)[c("name", "pcode", "nso_code")]))
```

| name        | pcode | nso_code |
|:------------|:------|:---------|
| Улаанбаатар | MN11  | 511      |
| Дорнод      | MN21  | 421      |
| Сүхбаатар   | MN22  | 422      |
| Хэнтий      | MN23  | 423      |
| Төв         | MN41  | 341      |
| Говьсүмбэр  | MN42  | 342      |

`name_en`, `name_mn`, `name_mns` нь англи, кирилл монгол, латин монгол
нэрийг хадгална. Дэлгэрэнгүйг [Нэр ба
код](https://temuulene.github.io/mongolmaps/mn/articles/names-and-codes.md)-оос
үзнэ үү.

## Нэг хэсгийг сонгон зурах

`aimag` эсвэл `region`-оор газар нутгаа сонгоно. Нэрийн түгээмэл өөр
бичлэгүүдийг танина.

``` r

west <- mn_soums(aimag = c("Khovd", "Uvs", "Bayan-Ulgii"))
mn_map(west, title = "Баруун Монголын сумд")
```

![Ховд, Увс, Баян-Өлгий аймгийн сумдын хил
зааг.](mongolmaps_files/figure-html/map-soums-1.png)

`mn_aimags(region = "Western")` нь баруун бүсийн бүх аймгийг авна. Олон
нэр давхардах үед нэг аймгийг тусад нь зурвал уншихад хялбар.

## Суурин газар, гол, хөрш орнуудыг нэмэх

Эдгээр жижиг давхарга багцад багтсан.

``` r

mn_map(mn_regions(), fill = name, context = TRUE) +
  geom_sf(
    data = mn_settlements(type = c("capital", "aimag_centre")),
    colour = "firebrick", size = 1
  ) +
  labs(title = "Эдийн засгийн бүс, аймгийн төвүүд", fill = "Бүс",
       caption = paste(strwrap(mn_citation(c("admin", "naturalearth", "settlements")), width = 95), collapse = "\n"))
```

![Эдийн засгийн бүсүүд, хөрш орнууд, гол ус, аймгийн
төвүүд.](mongolmaps_files/figure-html/map-context-1.png)

## Кирилл нэрээр тэмдэглэх

``` r

mn_map(mn_aimags(), label = TRUE, lang = "mn", label_size = 2.5)
```

![Аймгуудыг кирилл монгол нэрээр тэмдэглэсэн
зураг.](mongolmaps_files/figure-html/mongolian-1.png)

`options(mongolmaps.lang = "mn")` нь монгол нэрийг анхдагчаар сонгоно.
Үсэг дөрвөлжин болж харагдвал кирилл дэмждэг фонт сонгоно. Жишээ нь
`+ theme_mn(base_family = "Arial")`.

## Координат ба нарийвчлал

Хил зааг нь өргөрөг, уртрагийн EPSG:4326 системтэй.
[`mn_map()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_map.md)
зурагт тохирох тусгагийг сонгоно. Улсын түвшний талбайн ажилд
`crs = "albers"`, Улаанбаатарт `crs = "utm"` ашиглаж болно.

Доорх нэмэлт команд бүтэн нарийвчлалтай хил заагийг нэг удаа татаж
хадгална. Эхний удаад интернет хэрэгтэй.

``` r

khovd <- mn_soums(aimag = "Khovd", resolution = "high")
```

## Дараагийн алхам

- [Өгөгдлөө газрын зурагтай
  холбох](https://temuulene.github.io/mongolmaps/mn/articles/joining-data.md).
- [Улаанбаатарын дүүрэг, хороог
  зурах](https://temuulene.github.io/mongolmaps/mn/articles/ulaanbaatar.md).
- [Зам, ус, суурин газар
  нэмэх](https://temuulene.github.io/mongolmaps/mn/articles/thematic-layers.md).
- [Өндөршил, газрын бүрхэвч, хүн амын тор
  зурах](https://temuulene.github.io/mongolmaps/mn/articles/terrain-population.md).

[`mn_sources()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)
эх сурвалж, лицензийг жагсаана.
[`mn_citation()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_sources.md)
ишлэх текстийг өгнө. Хороо болон тэдгээрээс нэгтгэсэн дүүргийн дотоод
хил нь албан бус; эх файлын огноо нь хил хүчин төгөлдөр болсон огноо
биш.
