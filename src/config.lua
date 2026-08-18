local roomDisplayNames = {
  "None",
  "Arachne",
  "Narcissus",
  "Echo",
  "Hades",
  "Medea",
  "Circe",
  "Dionysus",
  "Sisyphus / Orpheus",
  "Eurydice",
  "Patroclus",
}

local roomNames = {
  "None",
  "F_Story01",
  "G_Story01",
  "H_Bridge01",
  "I_Story01",
  "N_Story01",
  "O_Story01",
  "P_Story01",
  "A_Story01",
  "X_Story01",
  "Y_Story01",
}

local configDefault = {
  enabled = true;
  never_default = false;
  dream_dive_only = false;
  banned_room_1 = "None";
  banned_room_2 = "None";
}

local configDesc = {
  enabled = "Enable/disable NPC Room Randomizer";
  never_default = "NPC rooms are always different from default";
  dream_dive_only = "Allow random story rooms in Dream Dives only";
  banned_room_1 = {
    description = "Ban a particular room from appearing";
    values = roomNames,
    labels = roomDisplayNames,
  },
  banned_room_2 = {
    description = "Ban another particular room from appearing";
    values = roomNames,
    labels = roomDisplayNames,
  }
}

return configDefault, configDesc