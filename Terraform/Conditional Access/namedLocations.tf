resource "azuread_named_location" "safecountries" {
  display_name = "Safe Countries"
  country {
    countries_and_regions = [
      "NL",
      "DE",
      "BE"
    ]
    include_unknown_countries_and_regions = false
  }
}

resource "azuread_named_location" "safeIPs" {
  display_name = "Safe IP Addresses"
  ip {
    ip_ranges = [
      "1.2.3.4/32"
    ]
    trusted = true
  }
}
