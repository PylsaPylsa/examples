resource "azuread_group" "CA_LOC_BlockLegacyAuth_Exclude" {
  display_name     = "CA_LOC_BlockLegacyAuth_Exclude"
  description      = "Excludes users from the CA policy \" AUTH | Block Legacy Authentication\""
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "time_sleep" "wait_CA_LOC_BlockLegacyAuth_Exclude" {
  depends_on      = [azuread_group.CA_LOC_BlockLegacyAuth_Exclude]
  create_duration = "15s"
}

resource "azuread_conditional_access_policy" "LOC_BlockLegacyAuth" {
  display_name = "AUTH | Block Legacy Authentication"
  state        = var.CAPolicyState

  conditions {
    client_app_types = ["other", "exchangeActiveSync"]

    applications {
      included_applications = ["All"]
    }

    locations {
      included_locations = ["All"]
    }

    platforms {
      included_platforms = ["all"]
    }

    users {
      included_users  = [var.includeCAGroup]
      excluded_groups = [azuread_group.CA_LOC_BlockLegacyAuth_Exclude.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }

  depends_on = [time_sleep.wait_CA_LOC_BlockLegacyAuth_Exclude]
}