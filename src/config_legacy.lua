local config = {
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
  banned_room_1 = "Ban a particular room from appearing\nArachne - F_Story01\nNarcissus - G_Story01\nEcho - H_Bridge01\nHades - I_Story01\nMedea - N_Story01\nCirce - O_Story01\nDionysus - P_Story01\nSisyphus - A_Story01\nEurydice - X_Story01\nPatroclus - Y_Story01";
  banned_room_2 = "Ban another particular room from appearing";
}

return config, configDesc