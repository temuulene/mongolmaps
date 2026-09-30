# Газрын нэр, кодыг Монголын засаг захиргааны нэгжтэй тааруулах

Монгол газар нутгийн нэрийн аливаа түгээмэл бичлэгийг кодод нь
хөрвүүлнэ: англи бичлэг ("Khuvsgul", "Khovsgol", "Hovsgol"), кирил,
ҮСХ-ны статистикийн код, ISO 3166-2 код, P-код. Нэрийг хэвийн болгосон
түлхүүрээр харьцуулдаг тул бичлэгийн хувилбар, том жижиг үсэг, цэг
таслал, "аймаг", "province", "сум", "дүүрэг" гэх мэт үг нөлөөлөхгүй.
Ингээд ч тохироогүй утгыг бага зэргийн засварын зайгаар тааруулахыг
оролдоно.

## Usage

``` r
mn_match(
  x,
  level = NULL,
  within = NULL,
  to = c("pcode", "name_en", "name_mn", "name_mns", "iso_code", "nso_code", "level",
    "type"),
  fuzzy = TRUE,
  max_dist = NULL,
  quiet = FALSE
)
```

## Arguments

- x:

  Нэр эсвэл кодын тэмдэгт мөрийн вектор (тоо, factor-ыг тэмдэгт мөр
  болгоно).

- level:

  Хайх түвшин(үүд): `"country"`, `"region"`, `"aimag"`, `"soum"`
  (Улаанбаатарын дүүргийг оруулна) эсвэл `"bag"` (хороог оруулна).
  `NULL` (анхдагч) бол бүх түвшнээс хайж, аймаг, дараа нь сум, бүс, улс,
  багийг тэргүүн ээлжинд авна.

- within:

  Хайлтыг нэг дээд нэгж доторх нэгжээр хязгаарлана. Нэг утга, эсвэл
  `x`-ийн элемент бүрт нэг утга өгнө.

- to:

  Юу буцаах: `"pcode"` (анхдагч), `"name_en"`, `"name_mn"`,
  `"name_mns"`, `"iso_code"`, `"nso_code"`, `"level"` эсвэл `"type"`.

- fuzzy:

  `TRUE` (анхдагч) бол яг тохироогүй утгыг, ганц ойролцоо хувилбар
  байвал засварын зайгаар тааруулна. Ойролцоогоор тааруулсан утга бүрийг
  шалгаж болохоор мэдэгдлээр харуулна.

- max_dist:

  Ойролцоо тааруулалтын засварын хамгийн их зай. `NULL` бол нэрийн
  уртаас хамааруулна (3 ба түүнээс цөөн үсэгтэйд 0, урт нэрт 3 хүртэл).

- quiet:

  `TRUE` бол ойролцоо тааруулалтын мэдэгдлийг нууна. Давхардсан эсвэл
  тохироогүй утгын анхааруулга үргэлж гарна.

## Value

`x`-тэй ижил урттай тэмдэгт мөрийн вектор. Тааруулж чадаагүй, эсвэл хэд
хэдэн нэгжтэй тохирсон утга `NA` болж, анхааруулгад жагсагдана.

## See also

Нэр, кодын бусад функц:
[`mn_codes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_codes.md),
[`mn_translit()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_translit.md)

## Examples

``` r
mn_match(c("Khuvsgul", "Hovsgol", "\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b", "MN-041"))
#> Warning: 1 value could not be matched and became "NA":
#> • \u0425\u04e9\u0432\u0441\u0433\u04e9\u043b
#> [1] "MN67" "MN67" NA     "MN67"

# NSO statistical codes work too
mn_match(c("183", "511", "51107"), to = "name_en")
#> [1] "Bayan-Ulgii" "Ulaanbaatar" "Bayangol"   

# Many soums share a name: say which aimag you mean
mn_match("Bayan-Uul", level = "soum", within = "Dornod")
#> [1] "MN2110"

# Khoroos are numbered within their district
mn_match("15-r khoroo", level = "bag", within = "Bayangol")
#> [1] "MN110779"
```
