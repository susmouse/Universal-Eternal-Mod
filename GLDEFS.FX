/////////////////////////Flame Belch Fire

flickerlight FlameBelchFireMain
{
    color 0.5 0.4 0.2
    size 50
    secondarySize 100
    chance 1.0
}

flickerlight FlameBelchFireAdds
{
    color 0.5 0.4 0.2
    size 20
    secondarySize 40
    chance 1.0
}

object Flame_Belch_Fire		{	frame FRFX { light FlameBelchFireMain }	}
object Flame_Belch_Fire_Add	{	frame FRFX { light FlameBelchFireMain }	}
object Flame_Belch_Fire_FX	{	frame FLMF { light FlameBelchFireAdds }	}

//EXPLOSION


pointlight EXPLODE1
{
    color 1.0 0.2 0.0
    size 40
}

pointlight EXPLODE2
{
    color 1.0 0.2 0.0
    size 120
}

pointlight EXPLODE3
{
    color 1.0 0.2 0.0
    size 60
}

pointlight EXPLODE4
{
    color 1.0 0.2 0.0
    size 35
}

pointlight EXPLODE5
{
    color 1.0 0.2 0.0
    size 15
}

pointlight EXPLODE6
{
    color 1.0 0.2 0.0
    size 10
}

object ExplosionAddG
{	
	frame HCEXA { light EXPLODE1 }
	frame HCEXB { light EXPLODE2 }
	frame HCEXC { light EXPLODE3 }
	frame HCEXD { light EXPLODE4 }
	frame HCEXE { light EXPLODE5 }
	frame HCEXF { light EXPLODE6 }
}

object ExplosionAddBig
{	
	frame HCEXA { light EXPLODE1 }
	frame HCEXB { light EXPLODE2 }
	frame HCEXC { light EXPLODE3 }
	frame HCEXD { light EXPLODE4 }
	frame HCEXE { light EXPLODE5 }
	frame HCEXF { light EXPLODE6 }
}

/////////////////////////PROPS

pointlight BarrelEX1
{
    color 1.0 0.5 0.5
    size 30
}

pointlight BarrelEX2
{
    color 1.0 0.5 0.5
    size 150
}

pointlight BarrelEX3
{
    color 1.0 0.5 0.5
    size 500
}


// object HC_ExplosiveBarrel
// {
// 	frame BEXPC0 { light BarrelEX1 }
// 	frame BEXPD0 { light BarrelEX2 }
// 	frame BEXPE0 { light BarrelEX3 }
// }

flickerlight ARCHFIRE1
{
    color 1.0 1.0 0.5
    size 36
    secondarySize 48
    chance 0.3
    offset 0 8 0
	attenuate 1
}

flickerlight ARCHFIRE2
{
    color 1.0 1.0 0.5
    size 60
    secondarySize 72
    chance 0.3
    offset 0 24 0
	attenuate 1
}

flickerlight ARCHFIRE3
{
    color 1.0 1.0 0.5
    size 96
    secondarySize 108
    chance 0.3
    offset 0 32 0
	attenuate 1
}

flickerlight ARCHFIRE4
{
    color 0.8 0.8 0.4
    size 96
    secondarySize 108
    chance 0.3
    offset 0 40 0
	attenuate 1
}

flickerlight ARCHFIRE5
{
    color 0.8 0.8 0.4
    size 96
    secondarySize 108
    chance 0.3
    offset 0 48 0
	attenuate 1
}

flickerlight ARCHFIRE6
{
    color 0.6 0.6 0.3
    size 72
    secondarySize 84
    chance 0.3
    offset 0 64 0
	attenuate 1
}

flickerlight ARCHFIRE7
{
    color 0.4 0.4 0.2
    size 48
    secondarySize 60
    chance 0.3
    offset 0 72 0
	attenuate 1
}

flickerlight ARCHFIRE8
{
    color 0.2 0.2 0.1
    size 24
    secondarySize 36
    chance 0.3
    offset 0 80 0
	attenuate 1
}

object BarrelFire
{
    frame FIREA { light ARCHFIRE1 }
    frame FIREB { light ARCHFIRE2 }
    frame FIREC { light ARCHFIRE3 }
    frame FIRED { light ARCHFIRE4 }
    frame FIREE { light ARCHFIRE5 }
    frame FIREF { light ARCHFIRE6 }
    frame FIREG { light ARCHFIRE7 }
    frame FIREH { light ARCHFIRE8 }
}

///////////////////

flickerlight BPUFF1
{
    color 0.5 0.5 0.0
    size 6
    secondarySize 8
    chance 0.8
}

flickerlight BPUFF2
{
    color 0.5 0.5 0.0
    size 3
    secondarySize 4
    chance 0.8
}

object HC_PuffParticlesBase
{
	frame PUFFA { LIGHT BPUFF1 }
	frame PUFFB { LIGHT BPUFF2 }
}


flickerlight BBPUFF1
{
    color 0.5 0.5 0.0
    size 8
    secondarySize 10
    chance 0.8
}

flickerlight BBPUFF2
{
    color 0.5 0.5 0.0
    size 5
    secondarySize 6
    chance 0.8
}

object HC_PuffParticlesBig
{
	frame PUFFA { LIGHT BBPUFF1 }
	frame PUFFB { LIGHT BBPUFF2 }
}


flickerlight HBPUFF1
{
    color 0.5 0.5 0.0
    size 10
    secondarySize 12
    chance 0.8
}

flickerlight HBPUFF2
{
    color 0.5 0.5 0.0
    size 7
    secondarySize 8
    chance 0.8
}

object HC_PuffParticlesHUGE
{
	frame PUFFA { LIGHT HBPUFF1 }
	frame PUFFB { LIGHT HBPUFF2 }
}


flickerlight NBPUFF
{
    color 0.5 0.5 0.0
    size 15
    secondarySize 20
    chance 0.8
}

object HC_BulletPuff
{
	frame HPUF { LIGHT NBPUFF }
}


flickerlight BigBPUFF
{
    color 0.5 0.5 0.0
    size 20
    secondarySize 30
    chance 0.8
}

// object RevolverPuff	{	frame PUFB { LIGHT BigBPUFF }}
// object RiflePuff	{	frame PUFB { LIGHT BigBPUFF }}
// object RiflePuffBIG	{	frame PUFB { LIGHT BigBPUFF }}

// GloryKill
pointlight GloryLight
{
    color 2.0 0.4 0.2
    size 16
	offset 0 16 0
}

object ShadedActor_Light
{	
	frame TNT1 { light GloryLight }
}
