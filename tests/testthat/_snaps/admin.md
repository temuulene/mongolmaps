# mn_admin('bag') explains that only khoroos have boundaries

    Code
      x <- mn_admin("bag")
    Message
      Only Ulaanbaatar khoroos have boundaries at the bag level.
      i Rural bag boundaries come from NSO on request; see `?mongolmaps::mn_bags()`.
      This message is displayed once per session.

# bad arguments give clear errors

    Code
      mn_aimags(crs = "mercator-ish")
    Condition
      Error in `mn_admin()`:
      ! `crs` must be "albers", "lcc", "utm", "wgs84", an EPSG code or an <crs>.
      x Could not interpret `mercator-ish`.

---

    Code
      mn_aimags(lang = "fr")
    Condition
      Error in `mn_admin()`:
      ! `lang` must be one of "en", "mn", or "mns", not "fr".

---

    Code
      mn_aimags(resolution = "medium")
    Condition
      Error in `mn_admin()`:
      ! `resolution` must be one of "low" or "high", not "medium".

---

    Code
      mn_soums(aimag = "Atlantis")
    Condition
      Error in `mn_soums()`:
      ! Can't resolve `aimag`.
      x Atlantis matches nothing
      i Use a code from `mn_codes()`, such as "MN84" for Khovd.

---

    Code
      mn_admin(c("aimag", "soum"))
    Condition
      Error in `mn_admin()`:
      ! `level` must be a single string naming a level, such as "aimag".

