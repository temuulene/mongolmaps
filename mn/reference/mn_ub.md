# Ulaanbaatar: city, districts and khoroos

Maps of the capital at three levels:

- `mn_ub()`: the city boundary;

- `mn_ub_districts()`: its 9 districts (duureg);

- `mn_khoroos()`: its 204 khoroos (subdistricts).

## Usage

``` r
mn_ub(resolution = c("low", "high"), lang = NULL, crs = NULL)

mn_ub_districts(resolution = c("low", "high"), lang = NULL, crs = NULL)

mn_khoroos(
  district = NULL,
  resolution = c("low", "high"),
  lang = NULL,
  crs = NULL
)
```

## Arguments

- resolution:

  `"low"` (default) uses simplified boundaries that ship with the
  package and suit most maps. `"high"` uses full-resolution boundaries,
  downloaded once (about 10 MB) and cached; see
  [`mn_cache_dir()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_cache_dir.md).

- lang:

  Language of the `name` column: `"en"` (English, as in NSO tables),
  `"mn"` (Cyrillic) or `"mns"` (Latin with diacritics, MNS 5217).
  Defaults to `getOption("mongolmaps.lang", "en")`.

- crs:

  Coordinate reference system of the result. `NULL` (default) keeps
  longitude/latitude (EPSG:4326). Use `"albers"`, `"lcc"` or `"utm"` for
  a projection suited to Mongolia (see
  [`mn_crs()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_crs.md)),
  or any value accepted by
  [`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

- district:

  Keep only khoroos in these districts (names or codes, such as
  `"Bayangol"`, `"BGD"` or `"MN1107"`).

## Value

An `sf` tibble; see
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md)
for the columns. For khoroos, `number` holds the khoroo number within
its district.

## Details

The three layers share borders exactly: khoroos tile their districts and
districts tile the city.

## Data source

Khoroo boundaries come from the open khoroo-map project
(<https://github.com/Tuvshin-Level/khoroo-map>, 0BSD licence), which
does not state where its data come from, so treat them as
**unofficial**. They were fitted to the official Ulaanbaatar outline,
with small gaps and overlaps between khoroos resolved: 0.6% of the city
area was reassigned, and 97% of khoroos changed area by less than 1%.
Khoroo codes and names follow NSO.

The district lines are the unions of their khoroos. They follow the
current city layout and can differ slightly from the 2020 district lines
in
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md).

## See also

Other admin boundaries:
[`mn_admin()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_admin.md),
[`mn_aimags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_aimags.md),
[`mn_bags()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_bags.md),
[`mn_country()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_country.md),
[`mn_soums()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_soums.md)

## Examples

``` r
mn_ub()
#> Simple feature collection with 1 feature and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 106.3626 ymin: 47.30196 xmax: 108.5008 ymax: 48.27193
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 16
#>   pcode name       name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr> <chr>      <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN11  Улаанбаат… Ulaanb… Улаанб… Ulaanba… aimag capi…     NA MN-1     511     
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_ub_districts()
#> Simple feature collection with 9 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 106.3626 ymin: 47.30196 xmax: 108.5008 ymax: 48.27193
#> Geodetic CRS:  WGS 84
#> # A tibble: 9 × 16
#>   pcode  name      name_en name_mn name_mns level type  number iso_code nso_code
#>   <chr>  <chr>     <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#> 1 MN1101 Багануур  Baganu… Багану… Baganuur soum  dist…     NA NA       51101   
#> 2 MN1104 Багаханг… Bagakh… Багаха… Bagakha… soum  dist…     NA NA       51104   
#> 3 MN1107 Баянгол   Bayang… Баянгол Bayangol soum  dist…     NA NA       51107   
#> 4 MN1110 Баянзүрх  Bayanz… Баянзү… Bayanzü… soum  dist…     NA NA       51110   
#> 5 MN1113 Налайх    Nalaikh Налайх  Nalaikh  soum  dist…     NA NA       51113   
#> 6 MN1116 Сонгинох… Songin… Сонгин… Songino… soum  dist…     NA NA       51116   
#> 7 MN1119 Сүхбаатар Sukhba… Сүхбаа… Sükhbaa… soum  dist…     NA NA       51119   
#> 8 MN1122 Хан-Уул   Khan-U… Хан-Уул Khan-Uul soum  dist…     NA NA       51122   
#> 9 MN1125 Чингэлтэй Chinge… Чингэл… Chingel… soum  dist…     NA NA       51125   
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_khoroos(district = "Bayangol")
#> Simple feature collection with 34 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 106.7843 ymin: 47.87398 xmax: 106.9132 ymax: 47.94424
#> Geodetic CRS:  WGS 84
#> # A tibble: 34 × 16
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>    <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN110751 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110751 
#>  2 MN110752 26-р … 26-r k… 26-р х… 26-r kh… bag   khor…     26 NA       5110752 
#>  3 MN110753 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110753 
#>  4 MN110754 27-р … 27-r k… 27-р х… 27-r kh… bag   khor…     27 NA       5110754 
#>  5 MN110755 3-р х… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110755 
#>  6 MN110756 28-р … 28-r k… 28-р х… 28-r kh… bag   khor…     28 NA       5110756 
#>  7 MN110757 4-р х… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110757 
#>  8 MN110758 29-р … 29-r k… 29-р х… 29-r kh… bag   khor…     29 NA       5110758 
#>  9 MN110759 5-р х… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110759 
#> 10 MN110760 30-р … 30-r k… 30-р х… 30-r kh… bag   khor…     30 NA       5110760 
#> # ℹ 24 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
mn_khoroos(lang = "mn", crs = "utm")
#> Simple feature collection with 204 features and 15 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 601134.8 ymin: 5241556 xmax: 762404.3 ymax: 5347530
#> Projected CRS: WGS 84 / UTM zone 48N
#> # A tibble: 204 × 16
#>    pcode    name   name_en name_mn name_mns level type  number iso_code nso_code
#>  * <chr>    <chr>  <chr>   <chr>   <chr>    <chr> <chr>  <int> <chr>    <chr>   
#>  1 MN110151 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110151 
#>  2 MN110153 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110153 
#>  3 MN110155 3-р х… 3-r kh… 3-р хо… 3-r kho… bag   khor…      3 NA       5110155 
#>  4 MN110157 4-р х… 4-r kh… 4-р хо… 4-r kho… bag   khor…      4 NA       5110157 
#>  5 MN110159 5-р х… 5-r kh… 5-р хо… 5-r kho… bag   khor…      5 NA       5110159 
#>  6 MN110451 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110451 
#>  7 MN110453 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110453 
#>  8 MN110751 1-р х… 1-r kh… 1-р хо… 1-r kho… bag   khor…      1 NA       5110751 
#>  9 MN110752 26-р … 26-r k… 26-р х… 26-r kh… bag   khor…     26 NA       5110752 
#> 10 MN110753 2-р х… 2-r kh… 2-р хо… 2-r kho… bag   khor…      2 NA       5110753 
#> # ℹ 194 more rows
#> # ℹ 6 more variables: parent_pcode <chr>, region_pcode <chr>,
#> #   aimag_pcode <chr>, soum_pcode <chr>, area_km2 <dbl>,
#> #   geometry <MULTIPOLYGON [m]>
```
