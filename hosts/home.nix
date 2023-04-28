{ config, lib, ... }:

with builtins;
with lib;
{

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "America/Toronto" then {
    latitude = 43.70011;
    longitude = -79.4163;
  } else if config.time.timeZone == "Europe/Copenhagen" then {
    latitude = 55.88;
    longitude = 12.5;
  } else {});

  # So the vaultwarden CLI knows where to find my server.
}
