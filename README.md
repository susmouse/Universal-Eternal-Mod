![logo](https://s2.loli.net/2025/06/03/EqmM3fFOC7IQNvG.png)

This is my first MOD, which aims to recreate Doom Eternal's mechanics in ClassicDoom while maintaining compatibility with custom weapon packs and custom monster packs.

I'm not proficient in C#. This mod was created after just 10 minutes of reading the ZDoom wiki, based on [Hell Crusher](https://forum.zdoom.org/viewtopic.php?t=72084) and [Vanilla Glory Kill](https://github.com/OverDriver05/Vanilla-Glory-Kill), so please bear with any bugs you may encounter:

## Update Log

- v1.0: Initial release
- v1.1:
  - Added more Glory Kill animations
  - Fixed an issue where Glory Kill sometimes fails to properly kill enemies
  - Added cooldown time and maximum allowed enemy health threshold for chainsaw kills
- v1.2:
  - Added configurable cooldown times for shoulder cannon abilities through the menu
- v1.3:
  - Updated Glory Kill animations to better suit the style of classic Doom;
  - Fixed an issue where weapons would be misplaced after Glory Kills and Quick Chainsaw attacks;
- v1.4:
  - Add more customization options for ShoulderCannons;
- v1.4.1
  - [Breaking Change] Modified some class names for better compatibility.
- v1.4.2
  - Added a compatibility settings menu where you can configure the type and amount of ammo replenished via QuickChainsaw.
- v1.4.3
  - Added configuration options for the healing amount of Ice Bomb drops.

## Features

- Compatible with custom weapon packs (Tested working with: Doom4Vanilla, Unbroken, SmoothDoom. Please report if compatibility issues occur)
- Dual Grenade, Flame Belch and Ice Bomb
- Double Dash and Jump
- Glory Kill
- Ammo replenishment via Quick Chainsaw
- Configurable ability toggles

## Screenshots

![ShoulderCannons](https://files.catbox.moe/7imwq7.png)

![GloryKill](https://files.catbox.moe/3stxhq.png)

![QuickChainsaw](https://files.catbox.moe/jl9ne4.png)

![Config](https://files.catbox.moe/f9j9m1.png)

## Future Development Plans

- More customizable options
- Further streamline the mod by removing unused code and assets.

## Credit

The related code and assets for Shoulder Cannons, dash, and double jump come from H3LLW4LK3R's [HellCrusher](https://forum.zdoom.org/viewtopic.php?t=72084).

The sprites for the supplies generated after Ice Bomb and Flame Belch attacks come from [MetaDoom](https://www.doomworld.com/forum/topic/131595-gzdoom-metadoom-v71-ghost/).

The related code for Glory Kill comes from OverDriver05's [VanillaGloryKill](https://github.com/OverDriver05/Vanilla-Glory-Kill). Thanks to his code, I was able to implement Quick Chainsaw on top of it :)

The Kick sprites for Glory Kill come from H3LLW4LK3R's [HellCrusher](https://forum.zdoom.org/viewtopic.php?t=72084).

The sprites for Quick Chainsaw come from Somerandomguy' [Doom Eternal: 1994 Edition](https://www.doomworld.com/forum/topic/151800-doom-eternal-made-in-1994-doom-eternal-1994-edition-de94e/).

## Download

- [Github(Latest But Beta)](https://github.com/susmouse/Universal-Eternal-Mod) **If you enjoy this mod, please give the repo a star! **
- [Moddb(Stable)](https://www.moddb.com/mods/universal-eternal-mod)
