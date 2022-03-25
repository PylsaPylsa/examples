resource "azuread_group" "CA_LOC_AllowedCountries_Exclude" {
  display_name     = "CA_LOC_AllowedCountries_Exclude"
  description      = "Excludes users from the CA policy \"LOC | Allowed Countries\""
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "time_sleep" "wait_CA_LOC_AllowedCountries_Exclude" {
  depends_on      = [azuread_group.CA_LOC_AllowedCountries_Exclude]
  create_duration = "15s"
}

resource "azuread_conditional_access_policy" "LOC_AllowedCountries" {
  display_name = "LOC | Allowed Countries"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.safecountries.id]
    }

    platforms {
      included_platforms = ["all"]
    }

    users {
      included_users  = [var.includeCAGroup]
      excluded_groups = [azuread_group.CA_LOC_AllowedCountries_Exclude.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }

  depends_on = [time_sleep.wait_CA_LOC_AllowedCountries_Exclude]
}