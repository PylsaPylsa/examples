resource "azuread_group" "CA_MFA_AllUsers_Exclude" {
  display_name     = "CA_MFA_AllUsers_Exclude"
  description      = "Excludes users from the CA policy \"MFA | All users\""
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "time_sleep" "wait_CA_MFA_AllUsers_Exclude" {
  depends_on = [azuread_group.CA_MFA_AllUsers_Exclude]
  create_duration = "15s"
}

resource "azuread_conditional_access_policy" "MFA_AllUsers" {
  display_name = "MFA | All users"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    locations {
      included_locations = ["All"]
      excluded_locations = [azuread_named_location.safecountries.id, azuread_named_location.safeIPs.id]
    }

    platforms {
      included_platforms = ["all"]
    }

    users {
      included_users  = [var.includeCAGroup]
      excluded_groups = [azuread_group.CA_MFA_AllUsers_Exclude.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }

  depends_on = [time_sleep.wait_CA_MFA_AllUsers_Exclude]
}