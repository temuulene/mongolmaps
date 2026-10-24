# mn_join() joins NSO codes at the aimag level and drops other levels

    Code
      out <- mn_join(pop, by = "Region", level = "aimag")
    Message
      i Joining at the aimag level; dropped 5 rows for larger units ("country" and "region") and 2196 rows for smaller units ("soum" and "bag").

# mn_join() detects the level and joins khoroos

    Code
      out <- mn_join(pop, Region, within = "Ulaanbaatar")
    Message
      i Joining at the bag level; dropped 371 rows for larger units ("country", "region", "aimag", and "soum").

# mn_join() reports unmatched rows and places without boundaries

    Code
      out <- mn_join(df, "place", level = "aimag")
    Condition
      Warning:
      1 value could not be matched and became "NA":
      * Narnia

---

    Code
      out <- mn_join(villages, "code", level = "soum")
    Message
      i 1 matched place has no boundary and is left out:
      * Khatgal (MN6770, Khuvsgul)
      i Villages and rural bags have NSO codes but no public boundary; see `?mongolmaps::mn_bags()`.

# mn_join() validates its inputs

    Code
      mn_join(list(a = 1), "a")
    Condition
      Error in `mn_join()`:
      ! `data` must be a data frame, not a list.

---

    Code
      mn_join(pop, "Province")
    Condition
      Error in `mn_join()`:
      ! Column Province is not in `data`.

---

    Code
      mn_join(pop, "Region", by_parent = "Aimag")
    Condition
      Error in `mn_join()`:
      ! Column Aimag is not in `data`.

# mn_join() takes Ulaanbaatar from code 5 when 511 is empty

    Code
      out <- mn_join(df, "Region", level = "aimag")
    Message
      i Using Ulaanbaatar region values to fill capital data within 1 statistical stratum/strata.
      i Joining at the aimag level; dropped 2 rows for larger units ("country" and "region").

# mn_join() takes Ulaanbaatar from code 5 when 511 is absent

    Code
      out <- mn_join(df, "Region", level = "aimag")
    Message
      i Using Ulaanbaatar region values to fill capital data within 1 statistical stratum/strata.
      i Joining at the aimag level; dropped 2 rows for larger units ("country" and "region").

# mn_join() keeps 511 when both Ulaanbaatar codes have data

    Code
      out <- mn_join(df, "Region", level = "aimag")
    Condition
      Warning:
      Conflicting Ulaanbaatar region/capital values in "value" (input row 5).
    Message
      i Joining at the aimag level; dropped 2 rows for larger units ("country" and "region").

# mn_join() takes Ulaanbaatar from code 5 when other levels are kept

    Code
      out <- mn_join(df, "Region", level = "aimag", drop_other_levels = FALSE)
    Message
      i Using Ulaanbaatar region values to fill capital data within 1 statistical stratum/strata.
    Condition
      Warning:
      2 values could not be matched and became "NA":
      * 0
      * 1

# mn_join() checks `by_parent` is a single string

    Code
      mn_join(pop, "Region", by_parent = 1)
    Condition
      Error in `mn_join()`:
      ! `by_parent` must be a single string.

