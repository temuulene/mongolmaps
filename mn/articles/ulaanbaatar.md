# Улаанбаатарын газрын зураг

[`mn_ub()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)
нийслэлийн хил,
[`mn_ub_districts()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)
есөн дүүрэг,
[`mn_khoroos()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)
204 хороог авна. Бүгд багцад багтсан.

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
library(ggplot2)
```

## Есөн дүүргийг харуулах

``` r

districts <- mn_ub_districts()
mn_map(districts, fill = name, label = TRUE,
       title = "Улаанбаатарын есөн дүүрэг") +
  guides(fill = "none")
```

![Улаанбаатарын есөн дүүрэг бодит
байрлалаараа.](ulaanbaatar_files/figure-html/districts-1.png)

Багануур, Багахангай нь хотын үндсэн хэсгээс зайтай. Тэдгээрийг тусдаа
хэсэгт зурвал үндсэн хот том харагдана. Энэ жишээнд patchwork хэрэгтэй:
`install.packages("patchwork")`.

``` r

mn_map_ub(fill = name, label = TRUE, title = "Улаанбаатарын дүүргүүд") &
  guides(fill = "none")
```

![Улаанбаатар, Багануур, Багахангайг тусдаа хэсгүүдэд харуулсан
зураг.](ulaanbaatar_files/figure-html/district-panels-1.png)

Хэсэг бүр өөр газарзүйн масштабтай. Дүүргүүдийн хоорондох зайг
харьцуулахдаа эхний зургийг ашиглана.

## Төвийн хороодыг сонгох

Дүүргийн нэр эсвэл `"BZD"`, `"SBD"`, `"KhUD"` зэрэг товчлол хэрэглэнэ.
Кирилл нэр, товчлолыг мөн танина.

``` r

central <- mn_khoroos(district = c("Bayangol", "Sukhbaatar", "Chingeltei"))
central$district <- districts$name[match(central$parent_pcode, districts$pcode)]
mn_map(central, fill = district, title = "Төвийн гурван дүүргийн хороод") +
  labs(fill = "Дүүрэг")
```

![Баянгол, Сүхбаатар, Чингэлтэй дүүргийн
хороод.](ulaanbaatar_files/figure-html/central-1.png)

Хорооны дугаар дүүрэг бүрт давтагдана. Дугаарыг харагдахуйц тэмдэглэхийн
тулд нэг дүүргийг сонгоод `label = TRUE` хэрэглэнэ.

``` r

mn_map(mn_khoroos(district = "Sukhbaatar"), label = TRUE,
       title = "Сүхбаатар дүүрэг: хорооны дугаар")
```

![Сүхбаатар дүүргийн хороодыг дугаараар тэмдэглэсэн
зураг.](ulaanbaatar_files/figure-html/khoroos-1.png)

Нэг хороо хайхдаа дүүргийг нь хамт өгнө:

``` r

mn_match("15-r khoroo", level = "bag", within = "Bayangol")
#> [1] "MN110779"
```

## Хүн амын өгөгдөл холбох

Багцын ҮСХ-ны жишээ хүснэгтэд 2015, 2020, 2025 оны жилийн дундаж хүн ам
бий. Нэг оноо сонгоод `Region` кодоор холбоно. Багцын кодын системд
хороод `level = "bag"` түвшинд орно.

``` r

pop <- mn_example_population[mn_example_population$Year == 2025, ]
khoroo_pop <- mn_join(pop, by = "Region", level = "bag", within = "Ulaanbaatar")
central_pop <- khoroo_pop[khoroo_pop$parent_pcode %in% central$parent_pcode, ]

mn_map(central_pop, fill = value / area_km2, trans = "log10",
       title = "Хүн амын нягтрал, 2025") +
  labs(fill = "Хүн/км²", subtitle = "Баянгол, Сүхбаатар, Чингэлтэй")
```

![Төвийн гурван дүүргийн 2025 оны хүн амын
нягтрал.](ulaanbaatar_files/figure-html/join-1.png)

Логарифмын өнгөний хуваарь нь нягтралын өргөн хүрээний ялгааг харуулна.
Саарал нь утга байхгүйг илэрхийлнэ; хүн ам тэг гэсэн үг биш.

## Интерактив зураг

leaflet-ийг нэг удаа суулгана: `install.packages("leaflet")`. Хулганаа
аваачвал нэр, дарвал дэлгэрэнгүй мэдээлэл гарна. Суурь зургийн тайлд
интернет хэрэгтэй.

``` r

mn_leaflet(central_pop, fill = value)
```

Интерактив зураг багцын вебсайтад харагдана. Ижил кодыг R-д ажиллуулбал
Viewer эсвэл хөтөч дээр нээгдэнэ.

## Хил заагийн хязгаарлалт

Хорооны дүрсийг khoroo-map төслөөс авсан бөгөөд анхны мэдээллийн эх
сурвалж нь тодорхойгүй. Иймээс **албан бус** гэж үзнэ. Багц тэдгээрийг
нийслэлийн албан ёсны гадна хилд тааруулж, хороодыг нэгтгэн дүүргийн
дүрс үүсгэдэг. Давхаргууд таарч байгаа нь хууль ёсны хил, хүчин төгөлдөр
огноог батлахгүй.
[`?mn_khoroos`](https://temuulene.github.io/mongolmaps/mn/reference/mn_ub.md)-оос
дэлгэрэнгүйг үзнэ үү.
