resource "azuread_group" "CA_SIF_ExternalSSOApps_Exclude" {
  display_name     = "CA_SIF_ExternalSSOApps_Exclude"
  description      = "Excludes users from the CA policy \"SIF | External SSO Apps\""
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "time_sleep" "wait_CA_SIF_ExternalSSOApps_Exclude" {
  depends_on      = [azuread_group.CA_SIF_ExternalSSOApps_Exclude]
  create_duration = "15s"
}

resource "azuread_conditional_access_policy" "SIF_ExternalSSOApps" {
  display_name = "SIF | External SSO Apps"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    client_app_types = ["all"]

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
      excluded_groups = [azuread_group.CA_SIF_ExternalSSOApps_Exclude.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = []
  }

  session_controls {
    sign_in_frequency        = 1
    sign_in_frequency_period = "hours"
  }

  depends_on = [time_sleep.wait_CA_SIF_ExternalSSOApps_Exclude]
}