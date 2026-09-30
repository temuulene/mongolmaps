# mn_bags() explains how to get bag boundaries

    Code
      mn_bags()
    Condition
      Error in `mn_bags()`:
      ! Bag boundaries are not openly published, so they are not included.
      i Ask NSO for them (international@nso.mn), then use `mn_bags(path = "bags.gpkg")`.
      i Bag codes and names are available now: `mn_codes("bag")`.
      i Khoroos of Ulaanbaatar are available now: `mn_khoroos()`.

# mn_read_bags() rejects bad files

    Code
      mn_read_bags("no-such-file.gpkg")
    Condition
      Error in `mn_read_bags()`:
      ! Can't find the bag file 'no-such-file.gpkg'.

---

    Code
      mn_read_bags(local_bag_file(shift = TRUE))
    Condition
      Error in `mn_read_bags()`:
      ! 17 bags lie outside their soum:
      * 1-r bag, Alagtolgoi (MN840151, Jargalant)
      * 1-r bag, Bodonch (MN840451, Altai)
      * 1-r bag, Bayangol (MN840751, Bulgan)
      * 1-r bag, Nariin gol (MN841051, Buyant)
      * 1-r bag, Bulag (MN841351, Darvi)
      * 1-r bag, Agvash (MN841651, Durgun)
      * 1-r bag, Shiver (MN841951, Duut)
      * 1-r bag, Guvee (MN842251, Zereg)
      * 1-r bag, Takhilt (MN842551, Mankhan)
      * 1-r bag, Alag (MN842851, Munkhkhairkhan)
      * ... and 7 more
      i Check the codes, or skip this check with `check_nesting = FALSE`.

---

    Code
      mn_read_bags(path)
    Condition
      Error in `mn_read_bags()`:
      ! Can't find a column of bag codes in '<file>.gpkg'.
      i Bag codes are 7-digit NSO codes ("1830151") or P-codes ("MN830151").
      i Name the column with `code_col`.

---

    Code
      mn_read_bags(path, code_col = "id")
    Condition
      Error in `mn_read_bags()`:
      ! 2 values are not known NSO bag codes (column id):
      * 9999999
      * 1234567

# mn_bags() refuses ambiguous soum names

    Code
      mn_bags(soum = "Jargalant", path = local_bag_file())
    Condition
      Error in `mn_bags()`:
      ! Can't resolve `soum`.
      x Jargalant matches Jargalant (MN4149, Tuv); Jargalant (MN6104, Orkhon); Jargalant (MN6440, Bayankhongor); Jargalant (MN6510, Arkhangai); Jargalant (MN6719, Khuvsgul); Jargalant (MN8401, Khovd)
      i Use a code from `mn_codes()`, such as "MN84" for Khovd.

# mn_read_bags() needs a path and a coordinate system

    Code
      mn_read_bags(NULL)
    Condition
      Error in `mn_read_bags()`:
      ! `path` must be a single string.

---

    Code
      mn_read_bags(path)
    Condition
      Error in `mn_read_bags()`:
      ! The bag file '<file>.shp' has no usable coordinate reference system.
      i Set one with `sf::st_set_crs()` and save the file again.
      Caused by error:
      ! OGRCreateCoordinateTransformation(): transformation not available

