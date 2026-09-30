# Transliterate Mongolian Cyrillic to Latin script

Converts Mongolian Cyrillic text to Latin script with a fixed,
package-owned table, so results never change between systems. Latin
characters, digits and punctuation pass through unchanged.

## Usage

``` r
mn_translit(x, to = c("mns", "nso"))
```

## Arguments

- x:

  A character vector (factors are converted to character).

- to:

  The romanisation scheme:

  - `"mns"` (default): the Mongolian national standard MNS 5217:2012,
    which writes the front vowels as o-umlaut and u-umlaut, for example
    "Khovsgol" with umlauts.

  - `"nso"`: the plain-ASCII spelling used in English tables of the
    National Statistics Office, for example "Khuvsgul".

## Value

A character vector the same length as `x`.

## See also

Other names and codes:
[`mn_codes()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_codes.md),
[`mn_match()`](https://temuulene.github.io/mongolmaps/mn/reference/mn_match.md)

## Examples

``` r
mn_translit("\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b")
#> [1] "\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b"
mn_translit("\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b", to = "nso")
#> [1] "\\u0425\\u04e9\\u0432\\u0441\\u0433\\u04e9\\u043b"
mn_translit("\\u0423\\u043b\\u0430\\u0430\\u043d\\u0431\\u0430\\u0430\\u0442\\u0430\\u0440")
#> [1] "\\u0423\\u043b\\u0430\\u0430\\u043d\\u0431\\u0430\\u0430\\u0442\\u0430\\u0440"
```
