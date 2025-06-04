//////PLAYER

//LedgeClimb

CLIMB_1 CLIMB_1
CLIMB_2 CLIMB_2
ClIMB_3 ClIMB_3

$random ledgeclimb {CLIMB_1 CLIMB_2 ClIMB_3}

//DoubleJump

JMPBOT1 JMPBOT1
JMPBOT2 JMPBOT2

$random JMPBOOT {JMPBOT1 JMPBOT2}

//Dashing

DASH1 DASH1
DASH2 DASH2
DASH3 DASH3
DASH4 DASH4
DASH5 DASH5

$random Player/Dash {DASH1 DASH2 DASH3 DASH4 DASH5}

DASHR1 DASHR1
DASHR2 DASHR2

$random Player/DashReady {DASHR1 DASHR2}

//Crucible Armblade

Crucible/Pickup "Sounds/Player/Weapons/Crucible/CruciblePickup.ogg"

Crucible/Slice1 "Sounds/Player/Weapons/Crucible/Slice1.ogg"
Crucible/Slice2 "Sounds/Player/Weapons/Crucible/Slice2.ogg"
Crucible/Slice3 "Sounds/Player/Weapons/Crucible/Slice3.ogg"
Crucible/Slice4 "Sounds/Player/Weapons/Crucible/Slice4.ogg"
Crucible/Slice5 "Sounds/Player/Weapons/Crucible/Slice5.ogg"
Crucible/Slice6 "Sounds/Player/Weapons/Crucible/Slice6.ogg"
$random Crucible/Slice {Crucible/Slice1 Crucible/Slice2 Crucible/Slice3 Crucible/Slice4 Crucible/Slice5 Crucible/Slice6}

Crucible/MeatChop1	"Sounds/Player/Weapons/Crucible/MeatChop1.wav"
Crucible/MeatChop2	"Sounds/Player/Weapons/Crucible/MeatChop2.wav"
Crucible/MeatChop3	"Sounds/Player/Weapons/Crucible/MeatChop3.wav"
Crucible/MeatChop4	"Sounds/Player/Weapons/Crucible/MeatChop4.wav"
Crucible/MeatChop5	"Sounds/Player/Weapons/Crucible/MeatChop5.wav"
$random Crucible/MeatChop {Crucible/MeatChop1 Crucible/MeatChop2 Crucible/MeatChop3 Crucible/MeatChop4 Crucible/MeatChop5}

Crucible/HitZap1 "Sounds/Player/Weapons/Crucible/CruciblePuffHit1.ogg"
Crucible/HitZap2 "Sounds/Player/Weapons/Crucible/CruciblePuffHit2.ogg"
Crucible/HitZap3 "Sounds/Player/Weapons/Crucible/CruciblePuffHit3.ogg"
Crucible/HitZap4 "Sounds/Player/Weapons/Crucible/CruciblePuffHit4.ogg"
Crucible/HitZap5 "Sounds/Player/Weapons/Crucible/CruciblePuffHit5.ogg"
Crucible/HitZap6 "Sounds/Player/Weapons/Crucible/CruciblePuffHit6.ogg"
Crucible/HitZap7 "Sounds/Player/Weapons/Crucible/CruciblePuffHit7.ogg"
Crucible/HitZap8 "Sounds/Player/Weapons/Crucible/CruciblePuffHit8.ogg"
$random Crucible/HitZap {Crucible/HitZap1 Crucible/HitZap2 Crucible/HitZap3 Crucible/HitZap4 Crucible/HitZap5 Crucible/HitZap6 Crucible/HitZap7 Crucible/HitZap8}

Crucible/Deploy "Sounds/Player/Weapons/Crucible/Deploy.ogg"

Crucible/Return1 "Sounds/Player/Weapons/Crucible/Return1.ogg"
Crucible/Return2 "Sounds/Player/Weapons/Crucible/Return2.ogg"
Crucible/Return3 "Sounds/Player/Weapons/Crucible/Return3.ogg"
Crucible/Return4 "Sounds/Player/Weapons/Crucible/Return4.ogg"
Crucible/Return5 "Sounds/Player/Weapons/Crucible/Return5.ogg"
$random Crucible/Return {Crucible/Return1 Crucible/Return2 Crucible/Return3 Crucible/Return4 Crucible/Return5}

Crucible/Swing1 "Sounds/Player/Weapons/Crucible/Swing1.ogg"
Crucible/Swing2 "Sounds/Player/Weapons/Crucible/Swing2.ogg"
Crucible/Swing3 "Sounds/Player/Weapons/Crucible/Swing3.ogg"
Crucible/Swing4 "Sounds/Player/Weapons/Crucible/Swing4.ogg"
Crucible/Swing5 "Sounds/Player/Weapons/Crucible/Swing5.ogg"
Crucible/Swing6 "Sounds/Player/Weapons/Crucible/Swing6.ogg"
Crucible/Swing7 "Sounds/Player/Weapons/Crucible/Swing7.ogg"
$random Crucible/Swing {Crucible/Swing1 Crucible/Swing2 Crucible/Swing3 Crucible/Swing4 Crucible/Swing5 Crucible/Swing6 Crucible/Swing7}

Crucible/PuffHit1	"Sounds/Player/Weapons/Crucible/CruciblePuffHit1.ogg"
Crucible/PuffHit2	"Sounds/Player/Weapons/Crucible/CruciblePuffHit2.ogg"
Crucible/PuffHit3	"Sounds/Player/Weapons/Crucible/CruciblePuffHit3.ogg"
Crucible/PuffHit4	"Sounds/Player/Weapons/Crucible/CruciblePuffHit4.ogg"
Crucible/PuffHit5	"Sounds/Player/Weapons/Crucible/CruciblePuffHit5.ogg"
Crucible/PuffHit6	"Sounds/Player/Weapons/Crucible/CruciblePuffHit6.ogg"
Crucible/PuffHit7	"Sounds/Player/Weapons/Crucible/CruciblePuffHit7.ogg"
Crucible/PuffHit8	"Sounds/Player/Weapons/Crucible/CruciblePuffHit8.ogg"
$random Crucible/PuffHit {Crucible/PuffHit1 Crucible/PuffHit2 Crucible/PuffHit3 Crucible/PuffHit4 Crucible/PuffHit5 Crucible/PuffHit6 Crucible/PuffHit7 Crucible/PuffHit8}

//BloodPunch

BloodPunch/ChargeGet	"Sounds/Player/Weapons/Melee/BPCharge.ogg"
$limit BloodPunch/ChargeGet 2

BloodPunch/HitSuccess	"Sounds/Player/Weapons/Melee/FistBloodPunchSuccess"
$limit BloodPunch/HitSuccess 0

//Melee

STATK1 STATK1
STATK2 STATK2
STATK3 STATK3
$random PunchSwing {STATK1 STATK2 STATK3}

PunchSwingAdd	STATKADD

ZRKSWNG1 ZRKSWNG1
ZRKSWNG2 ZRKSWNG2
$random BerzerkSwing {ZRKSWNG1 ZRKSWNG2}

PunchHit DSPUNCH

$limit PunchHit 0

MELEHIT1 MELEHIT1
MELEHIT2 MELEHIT2
MELEHIT3 MELEHIT3
MELEHIT4 MELEHIT4
MELEHIT5 MELEHIT5
$random MeleeHit {MELEHIT1 MELEHIT2 MELEHIT3 MELEHIT4 MELEHIT5}
$limit MeleeHit 0

WALLHIT1 WALLHIT1
WALLHIT2 WALLHIT2
WALLHIT3 WALLHIT3
WALLHIT4 WALLHIT4
WALLHIT5 WALLHIT5
$random BigWallHit {WALLHIT1 WALLHIT2 WALLHIT3 WALLHIT4 WALLHIT5}

ZERKHIT1 ZERKHIT1
ZERKHIT2 ZERKHIT2
ZERKHIT3 ZERKHIT3
ZERKHIT4 ZERKHIT4
$random BerzerkHit {ZERKHIT1 ZERKHIT2 ZERKHIT3 ZERKHIT4}
$limit BerzerkHit 0

ZERKHTM1 ZERKHTM1
ZERKHTM2 ZERKHTM2
ZERKHTM3 ZERKHTM3
ZERKHTM4 ZERKHTM4
ZERKHTM5 ZERKHTM5
$random BerzerkHitMonster {ZERKHTM1 ZERKHTM2 ZERKHTM3 ZERKHTM4 ZERKHTM5}
$limit BerzerkHitMonster 0

KICK01 KICK01
KICK02 KICK02

//$random Kick {KICK01 KICK02}

		
Kick 		KICK
KickWall	FOOTWALL
$limit KickWall 0



//Chainsaw
Chainsaw/AmmoGet1	"Sounds/Player/Weapons/Chainsaw/chainsaw_ammo_get_1.ogg"
Chainsaw/AmmoGet2	"Sounds/Player/Weapons/Chainsaw/chainsaw_ammo_get_2.ogg"

Chainsaw/inspect	"Sounds/Player/Weapons/Chainsaw/chainsaw_inspect.ogg"

Chainsaw/idle		"Sounds/Player/Weapons/Chainsaw/chainsaw_idle.ogg"

Chainsaw/OutRange	"Sounds/Player/Weapons/Chainsaw/chainsaw_out_of_range.ogg"

Chainsaw/Full1		"Sounds/Player/Weapons/Chainsaw/chainsaw_full_1.ogg"
Chainsaw/Full2		"Sounds/Player/Weapons/Chainsaw/chainsaw_full_2.ogg"
Chainsaw/Full3		"Sounds/Player/Weapons/Chainsaw/chainsaw_full_3.ogg"
$random Chainsaw/Full {Chainsaw/Full1 Chainsaw/Full2 Chainsaw/Full3}
/*
Chainsaw/CutFlesh1	"Sounds/Player/Weapons/Chainsaw/CuttingMeat/chainsaw_cut_1.ogg"
Chainsaw/CutFlesh2	"Sounds/Player/Weapons/Chainsaw/CuttingMeat/chainsaw_cut_2.ogg"
$random Chainsaw/CutFlesh {Chainsaw/CutFlesh1 Chainsaw/CutFlesh2}
*/
Chainsaw/CutFlesh	"Sounds/Player/Weapons/Chainsaw/CuttingMeat/chainsaw_cut_2.ogg"

Chainsaw/LowFuel1	"Sounds/Player/Weapons/Chainsaw/chainsaw_insufficient_fuel.ogg"
Chainsaw/LowFuel2	"Sounds/Player/Weapons/Chainsaw/chainsaw_insufficient_fuel_02.ogg"
Chainsaw/LowFuel3	"Sounds/Player/Weapons/Chainsaw/chainsaw_insufficient_fuel_03.ogg"
$random Chainsaw/LowFuel {Chainsaw/LowFuel1 Chainsaw/LowFuel2 Chainsaw/LowFuel3}

Chainsaw/Swing1 "Sounds/Player/Weapons/Chainsaw/CSROAR01.ogg"
Chainsaw/Swing2 "Sounds/Player/Weapons/Chainsaw/CSROAR02.ogg"
$random Chainsaw/Swing {Chainsaw/Swing1 Chainsaw/Swing2}

Chainsaw/End1	"Sounds/Player/Weapons/Chainsaw/chainsaw_end1.ogg"
Chainsaw/End2	"Sounds/Player/Weapons/Chainsaw/chainsaw_end2.ogg"
$random Chainsaw/End {Chainsaw/End1 Chainsaw/End2}


////////////////Grenade Launchers

EQLNMI1 EQLNMI1
EQLNMI2 EQLNMI2
EQLNMI3 EQLNMI3
$random EquipmentMoveIn {EQLNMI1 EQLNMI2 EQLNMI3}

EQLNMO1 EQLNMO1
EQLNMO2 EQLNMO2
EQLNMO3 EQLNMO3
$random EquipmentMoveOut {EQLNMO1 EQLNMO2 EQLNMO3}

EQLNGL1 EQLNGL1
EQLNGL2 EQLNGL2
EQLNGL3 EQLNGL3
EQLNGL4 EQLNGL4
EQLNGL5 EQLNGL5
$random EquipmentGrenadeLauncher {EQLNGL1 EQLNGL2 EQLNGL3 EQLNGL4 EQLNGL5}

EquipmentGrenadeLauncherCantUse EQLNGLC1
EquipmentGrenadeLauncherDoneCharging EQLNGLC2
EquipmentGrenadeLauncherTimer EQLNGLT

////////////////Flame Belch

EQLNFB1 EQLNFB1
EQLNFB2 EQLNFB2
EQLNFB3 EQLNFB3
$random EquipmentFlameBelch {EQLNFB1 EQLNFB2 EQLNFB3}

EquipmentFlameBelchNotReady EQLNFL
EquipmentFlameBelchReady EQLNFBR

////////////////Ice Bomb

EquipmentIceBombFire EQLNICF
EquipmentIceBombReload EQLNIR
EquipmentIceBombFail EQLNIFL

EQLNIE1 EQLNIE1
EQLNIE2 EQLNIE2
EQLNIE3 EQLNIE3
EQLNIE4 EQLNIE4
$random EquipmentIceExplode {EQLNIE1 EQLNIE2 EQLNIE3 EQLNIE4}

EQLNIEA1 EQLNIEA1
EQLNIEA2 EQLNIEA2
EQLNIEA3 EQLNIEA3
EQLNIEA4 EQLNIEA4
EQLNIEA5 EQLNIEA5
EQLNIEA6 EQLNIEA6
$random EquipmentIceExplodeAdd {EQLNIEA1 EQLNIEA2 EQLNIEA3 EQLNIEA4 EQLNIEA5 EQLNIEA6}

ICEDMB1 ICEDMB1
ICEDMB2 ICEDMB2
ICEDMB3 ICEDMB3
ICEDMB4 ICEDMB4
ICEDMB5 ICEDMB5
ICEDMB6 ICEDMB6
ICEDMB7 ICEDMB7
ICEDMB8 ICEDMB8
ICEDMB9 ICEDMB9
$random	EquipmentIceMonsterBreak {ICEDMB1 ICEDMB2 ICEDMB3 ICEDMB4 ICEDMB5 ICEDMB6 ICEDMB7 ICEDMB8 ICEDMB9}

ICEDAMB1 ICEDAMB1
ICEDAMB2 ICEDAMB2
ICEDAMB3 ICEDAMB3
$random EquipmentIceAmbient {ICEDAMB1 ICEDAMB2 ICEDAMB3}

//Casings

$volume casings/bullet/bounce 0.6
$random Casings/Bullet/bounce { CBNCE1 CBNCE2 CBNCE3 CBNCE4 CBNCE5 CBNCE6 CBNCE7 CBNCE8 CBNCE9 CBNCE10 }
CBNCE1 CBNCE1
CBNCE2 CBNCE2
CBNCE3 CBNCE3
CBNCE4 CBNCE4
CBNCE5 CBNCE5
CBNCE6 CBNCE6
CBNCE7 CBNCE7
CBNCE8 CBNCE8
CBNCE9 CBNCE9
CBNCE10 CBNCE10

$volume casings/bullet/die 0.6
$random Casings/Bullet/die { CASDIE1 CASDIE2 CASDIE3 CASDIE4 CASDIE5 CASDIE6 CASDIE7 CASDIE8 CASDIE9 CASDIE10 }
CASDIE1 CASDIE1
CASDIE2 CASDIE2
CASDIE3 CASDIE3
CASDIE4 CASDIE4
CASDIE5 CASDIE5
CASDIE6 CASDIE6
CASDIE7 CASDIE7
CASDIE8 CASDIE8
CASDIE9 CASDIE9
CASDIE10 CASDIE10

$volume casings/shell/die 0.6
$random casings/shell/die { SDIE1 SDIE2 SDIE3 }
SDIE1 SDIE1
SDIE2 SDIE2
SDIE3 SDIE3

$volume casings/shell/bounce 0.6
$random casings/shell/bounce { SBNCE1 SBNCE2 SBNCE3 SBNCE4 SBNCE5 }
SBNCE1 SBNCE1
SBNCE2 SBNCE2
SBNCE3 SBNCE3
SBNCE4 SBNCE4
SBNCE5 SBNCE5

//Generic Bullet Impacts

B/I/Med01	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_01.ogg"
B/I/Med02	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_02.ogg"
B/I/Med03	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_03.ogg"
B/I/Med04	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_04.ogg"
B/I/Med05	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_05.ogg"
B/I/Med06	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_06.ogg"
B/I/Med07	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_07.ogg"
B/I/Med08	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_08.ogg"
B/I/Med09	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_09.ogg"
B/I/Med10	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_10.ogg"
B/I/Med11	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_11.ogg"
B/I/Med12	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_12.ogg"
B/I/Med13	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_13.ogg"
B/I/Med14	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_14.ogg"
B/I/Med15	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Medium_15.ogg"
$random BulletImpactMedium {B/I/Med01 B/I/Med02 B/I/Med03 B/I/Med04 B/I/Med05 B/I/Med06 B/I/Med07 B/I/Med08 B/I/Med09 B/I/Med10 B/I/Med11 B/I/Med12 B/I/Med13 B/I/Med14 B/I/Med15}
//$limit BulletImpactMedium 0

B/I/Lar01	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Large_01.ogg"
B/I/Lar02	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Large_02.ogg"
B/I/Lar03	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Large_03.ogg"
B/I/Lar04	"Sounds/Player/Weapons/BulletImpacts/Bullet_Impacts_Large_04.ogg"
$random BulletImpactLarge {B/I/Lar01 B/I/Lar02 B/I/Lar03 B/I/Lar04}
$limit BulletImpactLarge 0

//Weapons

WEPDRAW1 WEPDRAW1
WEPDRAW2 WEPDRAW2
WEPDRAW3 WEPDRAW3
WEPDRAW4 WEPDRAW4
WEPDRAW5 WEPDRAW5
WEPDRAW6 WEPDRAW6
WEPDRAW7 WEPDRAW7

$random WeaponDraw {WEPDRAW1 WEPDRAW2 WEPDRAW3 WEPDRAW4 WEPDRAW5 WEPDRAW6 WEPDRAW7}

//SWORD

EnergySword/Deploy	"Sounds/Player/Weapons/Sword/EnergySwordCast.wav"

EnergySword/Swing1	"Sounds/Player/Weapons/Sword/EnergySwordswing1.wav"
EnergySword/Swing2	"Sounds/Player/Weapons/Sword/EnergySwordswing2.wav"
EnergySword/Swing3	"Sounds/Player/Weapons/Sword/EnergySwordswing3.wav"
EnergySword/Swing4	"Sounds/Player/Weapons/Sword/EnergySwordswing4.wav"
EnergySword/Swing5	"Sounds/Player/Weapons/Sword/EnergySwordswing5.wav"
EnergySword/Swing6	"Sounds/Player/Weapons/Sword/EnergySwordswing6.wav"
EnergySword/Swing7	"Sounds/Player/Weapons/Sword/EnergySwordswing7.wav"
EnergySword/Swing8	"Sounds/Player/Weapons/Sword/EnergySwordswing8.wav"
$random EnergySword/Swing	{EnergySword/Swing1 EnergySword/Swing2 EnergySword/Swing3 EnergySword/Swing4 EnergySword/Swing5 EnergySword/Swing6 EnergySword/Swing7 EnergySword/Swing8}

EnergySword/hit1	"Sounds/Player/Weapons/Sword/EnergySwordhit1.ogg"
EnergySword/hit2	"Sounds/Player/Weapons/Sword/EnergySwordhit2.ogg"
EnergySword/hit3	"Sounds/Player/Weapons/Sword/EnergySwordhit3.ogg"
EnergySword/hit4	"Sounds/Player/Weapons/Sword/EnergySwordhit4.ogg"
EnergySword/hit5	"Sounds/Player/Weapons/Sword/EnergySwordhit5.ogg"
$random EnergySword/hit {EnergySword/hit1 EnergySword/hit2 EnergySword/hit3 EnergySword/hit4 EnergySword/hit5}
$limit EnergySword/hit 0

//HAMMER

HAMSL1 HAMSL1
HAMSL2 HAMSL2
HAMSL3 HAMSL3

$random HammerSelect {HAMSL1 HAMSL2 HAMSL3}

HAMSW1 HAMSW1
HAMSW2 HAMSW2
HAMSW3 HAMSW3

$random HammerSwing {HAMSW1 HAMSW2 HAMSW3}

HAMHI1 HAMHI1
HAMHI2 HAMHI2
HAMHI3 HAMHI3

$random HammerHit {HAMHI1 HAMHI2 HAMHI3}

HammerGet HAMPCK
HammerGetHum HAMHUM

//BoomStick

BoomStickFire 		BOOMSF

BoomStickShellIn 	BOOMR

BoomStickOpen		BOOMOP
BoomStickClose		BOOMCL

BoomStickGet		BOOMCL
$volume BoomStickGet .4

//Deagle
DEAGFIR1	DEAGFIR1
DEAGFIR2	DEAGFIR2
DEAGFIR3	DEAGFIR3

$random DeagleFire {DEAGFIR1 DEAGFIR2 DEAGFIR3}

SledgeAddFire	SLEDGAD

DEAGLD1 DEAGLD1
DEAGLD2 DEAGLD2
DEAGLD3 DEAGLD3

$random DeagleDraw {DEAGLD1 DEAGLD2 DEAGLD3}

DeagleAirGrab DEAGLAG
/*
PistolGet PISGET
$volume PistolGet .4
*/
PistolGet	"Sounds/Player/Weapons/Pistol/Big_Pistol_Pickup1.ogg"

DeagleMagIn		DEAGLIN
DeagleMagOut	DEAGLOUT

//Daul

DaulPistolSlideBackward	DEAGLS1
DaulPistolSlideForward	DEAGLS2

//Revolver

RevolverFireAdd			REVFIRAD
RevolverFire 			REVFIR

RevolverSpin			REVSPIN
RevolverHammer			REVHAM
RevolverCharge			REVCHARG

//RevolverChargeSingle	REVCHRGS

RevolverChargeSingle 			REVCHRG1

//$pitchshiftrange RevolverChargeSingle 0.5,4
//$pitchset RevolverChargeSingle 0.5 10

//REVCHRG2 				REVCHRG2 

//$random RevolverChargeSingle {REVCHRG1 REVCHRG2}

REVSPIN1	REVSPIN1
REVSPIN2	REVSPIN2
REVSPIN3	REVSPIN3
REVSPIN4	REVSPIN4
REVSPIN5	REVSPIN5
REVSPIN6	REVSPIN6
REVSPIN7	REVSPIN7
REVSPIN8	REVSPIN8
REVSPIN9	REVSPIN9
$random RevolverFullSpin {REVSPIN1 REVSPIN2 REVSPIN3 REVSPIN4 REVSPIN5 REVSPIN6 REVSPIN7 REVSPIN8 REVSPIN9}	//Pulled from the Sony Pictures Sound Effects Series

//Infinity Pistol
EnergyPistolfire 	ENGPFIR

ENGPFIR1 ENGPFR1
ENGPFIR2 ENGPFR2
ENGPFIR3 ENGPFR3
ENGPFIR4 ENGPFR4
ENGPFIR5 ENGPFR5
ENGPFIR6 ENGPFR6
ENGPFIR7 ENGPFR7
ENGPFIR8 ENGPFR8
ENGPFIR9 ENGPFR9
ENGPFIR10 ENGPFR10
ENGPFIR11 ENGPFR11
ENGPFIR12 ENGPFR12
ENGPFIR13 ENGPFR13

$random EnergyPistolfireAdd {ENGPFIR1 ENGPFIR2 ENGPFIR3 ENGPFIR4 ENGPFIR5 ENGPFIR6 ENGPFIR7 ENGPFIR8 ENGPFIR9 ENGPFIR10 ENGPFIR11 ENGPFIR12 ENGPFIR13}

EnergyPistolCharge 		EMGCHRG
EnergyPistolCharged 	EMGCHRGI
EnergyPistolChargeBeep	EMGCHRGB
EnergyPistolChargeVent	EMGVENT

EnergyPistolChargeFire	ENGPCF

//NewShotgun
NewShotgunFire NSGFIRE
NewShotgunPump NSGPUMP
NewShotgunPump1 NSGPUMP1
NewShotgunPump2 NSGPUMP2
NewShotgunAltSteam STEAM
NewShotgunSelect NSGPUMP2
NewShotgunGet NSGPCK
$volume NewShotgunGet .4

//HexSSG
HexShotgunFire HSSGF
HexShotgunOpen HSSGOP
HexShotgunClose HSSGCL
HexShotgunShellIn SHEIN
HexShotgunGet HSSGPCK
$volume HexShotgunGet .4

HexShotgunSelect HSSGRAIS

HexShotgunCharge1 	HSGAL1
HexShotgunCharge2 	HSGAL2
HexShotgunCharge3 	HSGAL3
HexShotgunCharge4 	HSGAL4

HexShotgunShing		HSAFRD

ZERKHIT1 ZERKHIT1
ZERKHIT2 ZERKHIT2
ZERKHIT3 ZERKHIT3
ZERKHIT4 ZERKHIT4

$random HexShotgunFireAdd1 {ZERKHIT1 ZERKHIT2 ZERKHIT3 ZERKHIT4}

HexShotgunFireAdd2 HSGAA1
HexShotgunFireAdd3 HSGAA2

HexShotgun/DemonScreamLoop	"Sounds/Player/Weapons/SuperShotgun/DemonScreamLoop"

//Rifle

ScopeIn 	SCPZI
ScopeOut 	SCPZO
ScopeReady 	SCPRDY
ScopeDry 	SCPDRY
ScopeAdd1 	SCPAD1
ScopeAdd2 	SCPAD2
RifleFire 	RIFIRE

RifleGet RIPCK
RifleSelect RIRAISE

Rifle/SniperModeFire	"Sounds/Player/Weapons/Rifle/SniperFireTest.ogg"

//Chaingun

ChaingunGet 		CHNGPK
ChaingunSelect 		CHNRAISE

ChaingunShoot 		CHNSHOT
ChaingunClunk 		CHNCC
ChaingunCasingLoop 	CHNCAS

ChaingunFireLoop 	CHNLOOP
ChaingunFireLoop2 	CHNLOOP2
ChaingunFireLoop3 	CHNLOOP3
ChaingunFireLoop4 	CHNLOOP4

ChaingunFireLoopStop CHNSTP

ChaingunTurretOpen1 		TUROPEN1
ChaingunTurretOpen 			TUROPEN
ChaingunTurretClose 		TURCLOSE
ChaingunTurretBarrelsOut 	CHNBCNK

//RocketLauncer
RocketlauncherFire RLSTART
RocketMid RCKTFLY
$volume RocketMid .6

$random RocketExplode {RCKTEXP1 RCKTEXP2 RCKTEXP3 RCKTEXP4 RCKTEXP5 RCKTEXP6}
RCKTEXP1 RCKTEXP1
RCKTEXP2 RCKTEXP2
RCKTEXP3 RCKTEXP3
RCKTEXP4 RCKTEXP4
RCKTEXP5 RCKTEXP5
RCKTEXP6 RCKTEXP6
$limit RocketExplode 4
$rolloff  RocketExplode 900 1400

$random RocketExplodeAdd {RCKTADD1 RCKTADD2 RCKTADD3 RCKTADD4}
RCKTADD1 RCKTADD1
RCKTADD2 RCKTADD2
RCKTADD3 RCKTADD3
RCKTADD4 RCKTADD4
$limit RocketExplodeAdd 4
$rolloff  RocketExplodeAdd 900 1400

RocketLauncher/BoomDistant		"Sounds/Player/Weapons/RocketLauncher/RocketBoomDistant01"
$limit RocketLauncher/BoomDistant 4
$rolloff RocketLauncher/BoomDistant 1000 9000


RocketBurstLoadFail RKLDFL 

RocketBurstLoad1 RKLD1
RocketBurstLoad2 RKLD2
RocketBurstLoad3 RKLD3

RocketLauncherSelect RLRAISE
RocketLauncherGet RLPCK

RocketLauncher/Nuke/Fire		"Sounds/Player/Weapons/RocketLauncher/RocketNukeFireFull"

$random RocketLauncher/Nuke/BoomA {RocketLauncher/Nuke/BoomA01 RocketLauncher/Nuke/BoomA02 RocketLauncher/Nuke/BoomA03}
RocketLauncher/Nuke/BoomA01			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomA01"
RocketLauncher/Nuke/BoomA02			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomA02"
RocketLauncher/Nuke/BoomA03			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomA03"
$limit RocketLauncher/Nuke/BoomA 4
$rolloff RocketLauncher/Nuke/BoomA 1000 7500

$random RocketLauncher/Nuke/BoomB {RocketLauncher/Nuke/BoomB01 RocketLauncher/Nuke/BoomB02 RocketLauncher/Nuke/BoomB03 RocketLauncher/Nuke/BoomB04}
RocketLauncher/Nuke/BoomB01			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomB01"
RocketLauncher/Nuke/BoomB02			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomB02"
RocketLauncher/Nuke/BoomB03			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomB03"
RocketLauncher/Nuke/BoomB04			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomB04"
$limit RocketLauncher/Nuke/BoomB 4
$rolloff RocketLauncher/Nuke/BoomB 1000 7500

$random RocketLauncher/Nuke/BoomC {RocketLauncher/Nuke/BoomC01 RocketLauncher/Nuke/BoomC02 RocketLauncher/Nuke/BoomC03}
RocketLauncher/Nuke/BoomC01			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomC01"
RocketLauncher/Nuke/BoomC02			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomC02"
RocketLauncher/Nuke/BoomC03			"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomC03"
$limit RocketLauncher/Nuke/BoomC 4
$rolloff RocketLauncher/Nuke/BoomC 1000 7500

$random RocketLauncher/Nuke/BoomDistant {RocketLauncher/Nuke/BoomDistant01 RocketLauncher/Nuke/BoomDistant02 RocketLauncher/Nuke/BoomDistant03 RocketLauncher/Nuke/BoomDistant04 RocketLauncher/Nuke/BoomDistant05 RocketLauncher/Nuke/BoomDistant06 RocketLauncher/Nuke/BoomDistant07}
RocketLauncher/Nuke/BoomDistant01	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant01"
RocketLauncher/Nuke/BoomDistant02	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant02"
RocketLauncher/Nuke/BoomDistant03	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant03"
RocketLauncher/Nuke/BoomDistant04	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant04"
RocketLauncher/Nuke/BoomDistant05	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant05"
RocketLauncher/Nuke/BoomDistant06	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant06"
RocketLauncher/Nuke/BoomDistant07	"Sounds/Player/Weapons/RocketLauncher/RocketNukeBoomDistant07"
$limit RocketLauncher/Nuke/BoomDistant 4
$rolloff RocketLauncher/Nuke/BoomDistant 1000 9000



//Plasma Rifle

PlasmaAltfire		PLSALT

PlasmaRifleSelect 	PLSRAISE

PlasmaRifleFire 	PLSFIRE
PlasmaRifleHiss 	PLSHISS

PHBLAST1			PHBLAST1
PHBLAST2 			PHBLAST2
PHBLAST3 			PHBLAST3

$random HeatBlast {PHBLAST1 PHBLAST2 PHBLAST3}

PHBADD1 PHBADD1
PHBADD2 PHBADD2
PHBADD3 PHBADD3
PHBADD4 PHBADD4

$random HeatBlastAdd {PHBADD1 PHBADD2 PHBADD3 PHBADD4}

HBDSTRT1 HBDSTRT1
HBDSTRT2 HBDSTRT2
HBDSTRT3 HBDSTRT3
HBDSTRT4 HBDSTRT4

$random HeatBlastStart {HBDSTRT1 HBDSTRT2 HBDSTRT3 HBDSTRT4}

PlasmaRifleGet PLSPCK

PLASDRY1 PLASDRY1
PLASDRY2 PLASDRY2
PLASDRY3 PLASDRY3
PLASDRY4 PLASDRY4
$random HeatBlastFail {PLASDRY1 PLASDRY2 PLASDRY3 PLASDRY4}

//Gauss Cannon

GaussCannonFire GCNFIRE

GaussCannonFireAdd	"Sounds/Player/Weapons/GaussCannon/GaussCannonFireAdd"

GCNADD1 GCNADD1
GCNADD2 GCNADD2
GCNADD3 GCNADD3
GCNADD4 GCNADD4
$random GaussCannonAdd {GCNADD1 GCNADD2 GCNADD3 GCNADD4}

GaussCannonClose GCNCYCLE

GCIMPCT1 GCIMPCT1
GCIMPCT2 GCIMPCT2
GCIMPCT3 GCIMPCT3
$random GaussCannonHit {GCIMPCT1 GCIMPCT2 GCIMPCT3}
$limit GaussCannonHit 2

GaussCannonSiegeCharge GCSCHRG

GCSFIRE1 GCSFIRE1
GCSFIRE2 GCSFIRE2
GCSFIRE3 GCSFIRE3
$random GaussCannonSiegeFire {GCSFIRE1 GCSFIRE2 GCSFIRE3}

GCSADD1 GCSADD1
GCSADD2 GCSADD2
GCSADD3 GCSADD3
GCSADD4 GCSADD4
$random GaussCannonSiegeAdd {GCSADD1 GCSADD2 GCSADD3 GCSADD4}

GaussCannonSiegeClose GCSCLOSE
GaussCannonSiegeReady GCSCHRGI

GaussCannonGet GCPCK
GaussCannonSelect GCRAISE

GaussCannonDestroyerBladeFire	GCDESTFR

GaussCannon/Idle "Sounds/Player/Weapons/GaussCannon/GaussCannonIdle"

//BFG
$random BFGFireD16 {BFGFIRE1 BFGFIRE2 BFGFIRE3}
BFGFIRE1 		BFGFIRE1
BFGFIRE2 		BFGFIRE2
BFGFIRE3 		BFGFIRE3

BFGAddD16 		BFGADD
BFGChargeD16 	BFGCHRGE
BFGidle 		BFGIDLE

BFGballexplode BFGEXP
$limit BFGballexplode 4
$rolloff BFGballexplode 1200 2000

$random BFGballexplodeadd {BFGEXPS1 BFGEXPS2 BFGEXPS3 BFGEXPS4 BFGEXPS5 BFGEXPS6}
BFGEXPS1 		BFGEXPS1
BFGEXPS2 		BFGEXPS2
BFGEXPS3 		BFGEXPS3
BFGEXPS4 		BFGEXPS4
BFGEXPS5 		BFGEXPS5
BFGEXPS6 		BFGEXPS6
$limit BFGballexplodeadd 4
$rolloff BFGballexplodeadd 1200 2000

BFGBall/Explode/Distant "Sounds/Player/Weapons/BFG/BFGBallExplodeDistant"
$limit BFGBall/Explode/Distant 4
$rolloff BFGBall/Explode/Distant 5000 10000


BFGBALL1 		BFGBALL1
BFGBALL2 		BFGBALL2
BFGBALL3 		BFGBALL3

$random BFGBall {BFGBALL1 BFGBALL2 BFGBALL3}

BFGup 				BFGRAISE
BFGGet 				BFGPCK

BFGLazorChargeAdd	BFGLAZCU
BFGLazorCharge		BFGLAZCG

BFGLazorStart		BFGLAZST

BFGLazorAdd			BFGLAZAD
BFGLazorSpin		BFGSPIN
BFGLazorShoot 		BFGLAZOR

BFGLazorSpinStop	BFGSPINP
BFGLazorStop		BFGLAZSP

//Items

//Ammo

//Bullets

MAGUP1 MAGUP1
MAGUP2 MAGUP2

$random MagazineUp {MAGUP1 MAGUP2}

MagazineBoxUp MAGUP3

//Shells
ShellUp 	SHELUP

ShellBoxUp 	SHELBUP

//Rockets

RKONE1 RKONE1
RKONE2 RKONE2
RKONE3 RKONE3

$random RocketOne {RKONE1 RKONE2 RKONE3}

RocketBox RKBOX

//Cells

CellPackUp CELLPKUP

CellUp CELPIK

//Armor

ArmorBonus ARMRSHRD
$volume ArmorBonus .5
ArmorFull ARMRPICK
$volume ArmorFull .5

//Health

HealthBonus 		HEALTHBN
$volume HealthBonus .5

HealthStimpack 		MEDISTIM
$volume HealthStimpack .5

MEDIPAC1 	MEDIPAC1
MEDIPAC2 	MEDIPAC2

$random HealthMedipack {MEDIPAC1 MEDIPAC2}
$volume HealthMedipack .5

//Keys

CardPickup	CARDPKUP
SkullPickup	SKULPKUP

//PotClink

PotClnk1 PotClnk1
PotClnk2 PotClnk2
PotClnk3 PotClnk3

$random PotionClink {PotClnk1 PotClnk2 PotClnk3}
$volume PotionClink .5

//Props

//Barrel Explosions

BARADD1 BARADD1
BARADD2 BARADD2
BARADD3 BARADD3
BARADD4 BARADD4
BARADD5 BARADD5

$random BarrelAdd {BARADD1 BARADD2 BARADD3 BARADD4 BARADD5}

BARDBR1 BARDBR1
BARDBR2 BARDBR2
BARDBR3 BARDBR3
BARDBR4 BARDBR4
BARDBR5 BARDBR5

$random BarrelDebris {BARDBR1 BARDBR2 BARDBR3 BARDBR4 BARDBR5}

BAREXP1 BAREXP1
BAREXP2 BAREXP2
BAREXP3 BAREXP3
BAREXP4 BAREXP4
BAREXP5 BAREXP5

$random BarrelExplode {BAREXP1 BAREXP2 BAREXP3 BAREXP4 BAREXP5}


PlayerDeath/CompanyScreamLoop	"Sounds/Player/DeathSounds/CompanyScream.wav"
PlayerDeath/CompanyScream		"Sounds/Player/DeathSounds/CompanyMainScream.ogg"

Kane/Step1	"Sounds/Player/MoveSounds/KaneStep1.ogg"
Kane/Step2	"Sounds/Player/MoveSounds/KaneStep2.ogg"
Kane/Step3	"Sounds/Player/MoveSounds/KaneStep3.ogg"
Kane/Step4	"Sounds/Player/MoveSounds/KaneStep4.ogg"
Kane/Step5	"Sounds/Player/MoveSounds/KaneStep5.ogg"
Kane/Step6	"Sounds/Player/MoveSounds/KaneStep6.ogg"

$random Kane/Step {Kane/Step1 Kane/Step2 Kane/Step3 Kane/Step4 Kane/Step5 Kane/Step6}

// Kane Noises and Grunts

PLAKIK1 PLAKIK1
PLAKIK2 PLAKIK2
PLAKIK3 PLAKIK3
PLAKIK4 PLAKIK4

$random PlayerKickGrunt {PLAKIK1 PLAKIK2 PLAKIK3 PLAKIK4}

PLADSM1 PLADSM1
PLADSM2 PLADSM2
PLADSM3 PLADSM3

$random PlayerDeathScream {PLADSM1 PLADSM2 PLADSM3}


PLAPMD1 PLAPMD1
PLAPMD2 PLAPMD2
PLAPMD3 PLAPMD3
PLAPMD4 PLAPMD4
PLAPMD5 PLAPMD5
PLAPMD6 PLAPMD6
PLAPMD7 PLAPMD7
PLAPMD8 PLAPMD8
PLAPMD9 PLAPMD9
PLAPMD10 PLAPMD10
PLAPMD11 PLAPMD11
PLAPMD12 PLAPMD12

$random PlayerPainMedium {PLAPMD1 PLAPMD2 PLAPMD3 PLAPMD4 PLAPMD5 PLAPMD6 PLAPMD7 PLAPMD8 PLAPMD9 PLAPMD10 PLAPMD11 PLAPMD12}


PLAPSM1 PLAPSM1
PLAPSM2 PLAPSM2
PLAPSM3 PLAPSM3
PLAPSM4 PLAPSM4
PLAPSM5 PLAPSM5
PLAPSM6 PLAPSM6
PLAPSM7 PLAPSM7
PLAPSM8 PLAPSM8
PLAPSM9 PLAPSM9
PLAPSM10 PLAPSM10
PLAPSM11 PLAPSM11
PLAPSM12 PLAPSM12

$random PlayerPainSmall {PLAPSM1 PLAPSM2 PLAPSM3 PLAPSM4 PLAPSM5 PLAPSM6 PLAPSM7 PLAPSM8 PLAPSM9 PLAPSM10 PLAPSM11 PLAPSM12}


PLAPBG1 PLAPBG1
PLAPBG2 PLAPBG2
PLAPBG3 PLAPBG3
PLAPBG4 PLAPBG4
PLAPBG5 PLAPBG5
PLAPBG6 PLAPBG6
PLAPBG7 PLAPBG7
PLAPBG8 PLAPBG8
PLAPBG9 PLAPBG9
PLAPBG10 PLAPBG10
PLAPBG11 PLAPBG11
PLAPBG12 PLAPBG12
PLAPBG13 PLAPBG13
PLAPBG14 PLAPBG14

$random PlayerPainBig {PLAPBG1 PLAPBG2 PLAPBG3 PLAPBG4 PLAPBG5 PLAPBG6 PLAPBG7 PLAPBG8 PLAPBG9 PLAPBG10 PLAPBG11 PLAPBG12 PLAPBG13 PLAPBG14}

PLAUFL1 PLAUFL1
PLAUFL2 PLAUFL2
PLAUFL3 PLAUFL3

$random PlayerUseFail {PLAUFL1 PLAUFL2 PLAUFL3}

/*

PLALND1 PLALND1
PLALND2 PLALND2
PLALND3 PLALND3

$random PlayerLand {PLALND1 PLALND2 PLALND3}

*/

PlayerLand	"Sounds/Player/MoveSounds/Landingtest.ogg"

PlayerSilence	PLASIL

$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*xdeath		PlayerDeathScream
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*death		PlayerDeathScream

$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*pain100	PlayerPainSmall
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*pain75		PlayerPainSmall
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*pain50		PlayerPainMedium
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*pain25		PlayerPainBig
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*pain5		PlayerDeathScream

$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*land		PlayerSilence
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*grunt		PlayerLand
$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*jump		PlayerSilence

$PlayerAlias		HellCrusherGuy	HellCrusherGuy	*usefail	PlayerUseFail

//NV

nightvision/get	"Sounds/Items/PowerUps/NightVisionGoggles/night_vision_get.ogg"

//AllMap/AutoMap

AllMap/get	"Sounds/Items/PowerUps/AllMap/pickup_allmap.ogg"

//RadSuit

RadSuit/Get	"Sounds/Items/PowerUps/RadSuit/Rad_Suit_Get.ogg"

//Quad damage

QuadDamagePickup			QUADPICK
QuadDamageIdle				QUADIDLE
QuadDamageLoop				QUADLOOP
QuadDamageVoice				QUADVOCL
QuadDamageWarn				QUADWARN
QuadDamageEnd				QUADEND
QuadDamageShot				QDMGSHOT

//Soul / Mega Sphere

MegaHealthGet				MEGAHLTH

//Invul

INVULHM1					INVULHM1
INVULHM2					INVULHM2
INVULHM3					INVULHM3
$random InvulnerabilityHum {INVULHM1 INVULHM2 INVULHM3}

InvulnerabilityGet			INVULPCK

Prop/Sparks1	"Sounds/Props/BrokenStuff/Prop_Sparks_1.ogg"
Prop/Sparks2	"Sounds/Props/BrokenStuff/Prop_Sparks_2.ogg"
Prop/Sparks3	"Sounds/Props/BrokenStuff/Prop_Sparks_3.ogg"
Prop/Sparks4	"Sounds/Props/BrokenStuff/Prop_Sparks_4.ogg"
Prop/Sparks5	"Sounds/Props/BrokenStuff/Prop_Sparks_5.ogg"
Prop/Sparks6	"Sounds/Props/BrokenStuff/Prop_Sparks_6.ogg"
Prop/Sparks7	"Sounds/Props/BrokenStuff/Prop_Sparks_7.ogg"
Prop/Sparks8	"Sounds/Props/BrokenStuff/Prop_Sparks_8.ogg"
Prop/Sparks9	"Sounds/Props/BrokenStuff/Prop_Sparks_9.ogg"
Prop/Sparks10	"Sounds/Props/BrokenStuff/Prop_Sparks_10.ogg"
Prop/Sparks11	"Sounds/Props/BrokenStuff/Prop_Sparks_11.ogg"
Prop/Sparks12	"Sounds/Props/BrokenStuff/Prop_Sparks_12.ogg"
Prop/Sparks13	"Sounds/Props/BrokenStuff/Prop_Sparks_13.ogg"
Prop/Sparks14	"Sounds/Props/BrokenStuff/Prop_Sparks_14.ogg"
Prop/Sparks15	"Sounds/Props/BrokenStuff/Prop_Sparks_15.ogg"
Prop/Sparks16	"Sounds/Props/BrokenStuff/Prop_Sparks_16.ogg"
Prop/Sparks17	"Sounds/Props/BrokenStuff/Prop_Sparks_17.ogg"
Prop/Sparks18	"Sounds/Props/BrokenStuff/Prop_Sparks_18.ogg"
$random Prop/Sparks {Prop/Sparks1 Prop/Sparks2 Prop/Sparks3 Prop/Sparks4 Prop/Sparks5 Prop/Sparks6 Prop/Sparks7 Prop/Sparks8 Prop/Sparks9 Prop/Sparks10 Prop/Sparks11 Prop/Sparks12 Prop/Sparks13 Prop/Sparks14 Prop/Sparks15 Prop/Sparks16 Prop/Sparks17 Prop/Sparks18}

Prop/Metal/Break1	"Sounds/Props/BrokenStuff/Prop_Metal_Break_1.ogg"
Prop/Metal/Break2	"Sounds/Props/BrokenStuff/Prop_Metal_Break_2.ogg"
Prop/Metal/Break3	"Sounds/Props/BrokenStuff/Prop_Metal_Break_3.ogg"
$random Prop/Metal/Break {Prop/Metal/Break1 Prop/Metal/Break2 Prop/Metal/Break3}