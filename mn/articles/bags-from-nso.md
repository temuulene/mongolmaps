# Баг: ҮСХ-оос авсан хилийг ашиглах

``` r

library(mongolmaps)
options(mongolmaps.lang = "mn")
```

Баг бол хөдөө орон нутгийн хамгийн жижиг нэгж: сум бүр хэдэн багт
хуваагдах бөгөөд нийт 1,650 орчим баг бий. mongolmaps багийн кодыг,
нэрийг бүгдийг мэднэ:

``` r

mn_codes("bag", within = "Ховд")
#> # A tibble: 91 × 16
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN840151 1-р б… 1-r ba… 1-р ба… 1-r bag… bag   bag        1 NA       1840151 
#>  2 MN840153 2-р б… 2-r ba… 2-р ба… 2-r bag… bag   bag        2 NA       1840153 
#>  3 MN840155 3-р б… 3-r ba… 3-р ба… 3-r bag… bag   bag        3 NA       1840155 
#>  4 MN840157 4-р б… 4-r ba… 4-р ба… 4-r bag… bag   bag        4 NA       1840157 
#>  5 MN840159 5-р б… 5-r ba… 5-р ба… 5-r bag… bag   bag        5 NA       1840159 
#>  6 MN840161 6-р б… 6-r ba… 6-р ба… 6-r bag… bag   bag        6 NA       1840161 
#>  7 MN840163 7-р б… 7-r ba… 7-р ба… 7-r bag… bag   bag        7 NA       1840163 
#>  8 MN840165 8-р б… 8-r ba… 8-р ба… 8-r bag… bag   bag        8 NA       1840165 
#>  9 MN840167 9-р б… 9-r ba… 9-р ба… 9-r bag… bag   bag        9 NA       1840167 
#> 10 MN840169 10-р … 10-r b… 10-р б… 10-r ba… bag   bag       10 NA       1840169 
#> # ℹ 81 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>, has_geometry <lgl>
```

гэвч **хилийг нь агуулаагүй**. Багийн хилийг ямар ч нээлттэй мэдээллийн
сан нийтлээгүй: GADM, geoBoundaries, хүмүүнлэгийн COD, OpenStreetMap
бүгд сумаар хязгаарлагддаг. Үндэсний статистикийн хороо (ҮСХ) хүсэлтээр
өгдөг.

## Файл авах

ҮСХ-нд <international@nso.mn> хаягаар хандаж дараахыг хүснэ үү:

- багийн хил shapefile эсвэл GeoPackage хэлбэрээр;
- баг бүрийн ҮСХ-ны код (7 оронтой, жишээ нь `1830151`), эсвэл сумын код
  ба багийн дугаар;
- хил хүчинтэй огноо;
- ашиглах нөхцөл (газрын зураг нийтэлж болох уу? файлыг дахин тарааж
  болох уу?).

## Файлыг ашиглах

mongolmaps-д файлын замыг зааж өгнө:

``` r

bags <- mn_bags(path = "bags_from_nso.gpkg")
mn_map(mn_bags(aimag = "Ховд", path = "bags_from_nso.gpkg"), label = TRUE)
```

эсвэл нэг удаа бүртгээд (жишээ нь `.Rprofile` файлд) мартаж болно:

``` r

options(mongolmaps.bags_path = "C:/data/bags_from_nso.gpkg")

mn_bags(aimag = "Ховд")
mn_admin("bag") # хороо, баг хамтдаа
mn_join(my_bag_table, by = "code", level = "bag")
```

[`mn_read_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md)
файлыг анх уншихдаа шалгана:

- багийн кодын баганыг олно (эсвэл `code_col`-оор зааж өгнө);
- код бүр ҮСХ-ны мэдэгдэж буй багийн код байх ёстой;
- баг бүр өөрийн сум дотор байх ёстой (`check_nesting = FALSE`-ээр
  унтраана).

Үүний дараа баг бусад бүх газрын зурагтай ижил баганатай болох тул
ҮСХ-ны багийн хүснэгтийг аймгийн хүснэгт шиг холбож болно.
