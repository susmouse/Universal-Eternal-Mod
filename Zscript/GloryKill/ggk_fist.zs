// GloryFist: 荣耀击杀专用拳套武器。
class GloryFist : Weapon
{	
	Default
	{
		AttackSound "*fist"; // 攻击音效使用默认的拳头音效。
	}
	
	Weapon prevWeapon; // 存储切换到GloryFist之前的武器。
	Actor ptarget; // 指向荣耀击杀的目标敌人。
	int ptics; // 存储目标敌人被冻结前的原始tics值。
	float vbob; // 存储玩家原始的视角晃动 (ViewBob) 设置。
	
	// action 函数 A_ResetWeapon: 用于在荣耀击杀完成或武器被取消选择时，重置玩家和目标的状态。
	// 'invoker' 在action函数中通常指代调用此action的武器自身 (即GloryFist实例)。
	action void A_ResetWeapon()
	{
		PlayerInfo plr = PlayerPawn(self).player; // 获取武器持有者 (玩家) 的PlayerInfo。 'self' 在这里指代武器Actor。
		Actor player = PlayerPawn(self); // 获取玩家Actor。

		if(invoker.ptarget) // 如果存在荣耀击杀目标。
		{
			if(sv_glorykilldrops) // 如果启用了荣耀击杀掉落 (CVAR)。
			{
				int healthAmmount = (plr.health + sv_glorykillhealth) < 100 ? (plr.health + sv_glorykillhealth) : 100; // 计算掉落的生命值。
				player.A_SetHealth(healthAmmount); // 恢复玩家的生命值。
			}
			invoker.ptarget.tics = invoker.ptics; // 恢复目标敌人的tics，使其行为解冻。
		}
		// 清除玩家在荣耀击杀期间被设置的作弊状态。
		plr.cheats &= ~(CF_TOTALLYFROZEN|CF_NOTARGET|CF_GODMODE|CF_GODMODE2|CF_INSTANTWEAPSWITCH|CF_DOUBLEFIRINGSPEED);
		plr.mo.ViewBob = invoker.vbob; // 恢复玩家的视角晃动设置。
		
		if(plr) 
		{
			plr.PendingWeapon = invoker.prevWeapon; // 设置待切换的武器为荣耀击杀前的武器。
			PSprite pweapon = plr.GetPSprite(PSP_WEAPON); // 获取武器的屏幕精灵(ViewModel)。
			pweapon.x -= 130; // 调整武器精灵的X坐标 (可能是为了配合动画或重置某种偏移)。
			//pweapon.y = WEAPONTOP; // (注释掉) 设置武器精灵Y坐标。
			pweapon.ResetInterpolation(); // 重置精灵的插值动画。
		}
		RemoveInventory(invoker); // 从玩家物品栏中移除GloryFist武器。
	}
	
	// action 函数 A_ToggleFlip: 切换武器屏幕精灵的水平翻转状态。
	action void A_ToggleFlip()
	{
		PlayerInfo plr = PlayerPawn(self).player; // 获取玩家信息。
		PSprite pweapon = plr.GetPSprite(PSP_WEAPON); // 获取武器屏幕精灵。
		if(pweapon) 
		{
			pweapon.bFlip = !pweapon.bFlip;	// 切换翻转状态。
			// 根据翻转状态调整X坐标，以保持精灵在屏幕上的相对位置或实现特定视觉效果。
			// (pweapon.bFlip*-1) 可能是笔误，通常是 (pweapon.bFlip ? -1 : 1) 或类似逻辑。
			// 如果 bFlip 是 true (已翻转)，则 pweapon.bFlip*-1 是 -1。如果 false, 则是 0。
			// 这意味着如果翻转了，x -= 130 * -1 (即 x += 130)。如果未翻转，x -= 0。
			// 这看起来像是：翻转时向右移，不翻转时不移。或者如果初始偏移是-130，翻转时变为0。
			pweapon.x -= 130 * (pweapon.bFlip ? -1 : 0); // 修正: 假设是想在翻转时反向偏移
			pweapon.ResetInterpolation(); // 重置插值。
		}
	}
	
	// 覆写 DoEffect 方法，在武器激活时每帧调用。
	override void DoEffect()
	{		
		if(!PlayerPawn(Owner)) // 如果武器的持有者不是玩家 (例如，怪物持有的武器，虽然不太可能用于此武器)。
		{
			super.DoEffect(); // 执行父类的DoEffect。
			return;
		}
		if(ptarget && ptarget.health >= 0) // 如果存在荣耀击杀目标且目标存活。
		{
			if(ptarget.tics != -1) // 如果目标尚未被此武器冻结。
			{
				ptics = ptarget.tics; // 存储目标原始tics。
				ptarget.tics = -1; // 冻结目标。
			}
			PlayerInfo plr = PlayerPawn(Owner).player; // 获取玩家信息。
			plr.mo.vel *= 0; // 停止玩家的移动。
			if(!vbob) // 如果尚未存储原始视角晃动值。
			{	
				vbob = plr.mo.ViewBob; // 存储当前视角晃动值。
				plr.mo.ViewBob *= 0; // 禁用视角晃动。
			}
			// 给予玩家一系列作弊状态，使其在荣耀击杀期间无敌、无法被瞄准、动作固定等。
			plr.cheats |= CF_TOTALLYFROZEN|CF_NOTARGET|CF_GODMODE2|CF_GODMODE|CF_DOUBLEFIRINGSPEED|CF_INSTANTWEAPSWITCH;
			if(!prevWeapon) prevWeapon = plr.ReadyWeapon; // 如果尚未存储先前的武器，则存储当前手持武器。
		}
		super.DoEffect(); // 调用父类的DoEffect。
	}
	
	// 静态方法 GetPushWeight: 根据敌人质量计算一个推力权重。
	// emass: 敌人的质量 (mass)。
	static double GetPushWeight(double emass)
	{
		// Deviation from small weight, 0 means no deviation.
		// (原注释：与小重量的偏差，0表示无偏差。)
		double m = 200; // 基准质量。
		double d = 0.15; // 质量衰减系数。
		double x = (1. - (emass/m)); // 质量与基准质量的比率差。
		double y = -d*(x**2) + 1; // 一个二次函数，当emass=m时y=1，emass偏离m时y减小。
		return clamp(y*0.75,0.1,1.0); // 将计算出的权重限制在0.1到1.0之间，并乘以0.75。
	}
	
	// action 函数 A_GloryPunch: 执行一次荣耀击杀的拳击动作。
	// kill: bool, 如果为true，则此拳击会杀死目标。
	action void A_GloryPunch(bool kill = false)
	{	
		A_Quake(3,3,0,10,""); // 屏幕震动效果: 强度3, 持续3帧, 半径0 (全屏), 衰减10, 音效标签""。
		// 自定义近战攻击: 伤害1, true表示强制命中, 0点护甲穿透, "BulletPuff"命中效果, 范围64, 无特殊标志, 无特殊伤害类型, 无忽略Actor。
		A_CustomPunch(1,true,0,"BulletPuff",64,0,0,"","none"); 
		if(invoker.ptarget && kill) // 如果存在目标且标记为杀死。
		{
			invoker.ptarget.A_Die("GloryKill"); // 使目标以 "GloryKill" 的方式死亡 (用于触发特殊死亡动画或逻辑)。
			double pwmass = invoker.GetPushWeight(invoker.ptarget.mass); // 计算推力权重。
			// 将目标沿玩家当前角度推开，力度为 20 * pwmass。
			invoker.ptarget.Thrust(20. * pwmass, angle); 
			invoker.ptarget.vel.z += (12. * pwmass); // 给予目标向上的垂直速度。
		}
	}
	
	// action 函数 A_GloryKick: 执行一次荣耀击杀的踢击动作。 (此函数目前在States中未被使用)
	// kill: bool, 如果为true，则此踢击会杀死目标。
	action void A_GloryKick(bool kill = false)
	{	
		PlayerInfo plr = PlayerPawn(self).player; // 获取玩家信息。
		A_PlaySound("fht1",0); // 播放音效 "fht1" (通常是拳击或踢击声)。
		A_Quake(5,3,0,10,""); // 更强的屏幕震动。
		A_CustomPunch(1,true,0,"BulletPuff",64,0,0,"","none"); // 近战攻击。
		if(invoker.ptarget && kill) invoker.ptarget.A_Die("GloryKill"); // 杀死目标。
		//plr.mo.ViewBob *= 1; // (注释掉) 恢复视角晃动，但值是1，可能不是预期效果。
	}	

	States
	{
		Ready:
			FSTE A 1 A_WeaponReady();
			goto Fire; // 直接跳转到 Fire 状态开始荣耀击杀动画 (这表明一旦选中此武器且有目标，就会自动开始攻击)。
		Done:
			FSTE A 1 A_ResetWeapon(); // 显示 FSTE A 帧，持续1帧，并调用 A_ResetWeapon 清理并切换回原武器。
		Deselect:
			FSTE A 1 A_Lower(WEAPONBOTTOM);
			Loop; // 循环 Deselect 的最后一行，直到武器完全放下。完成后会自动调用 A_ResetWeapon。
		Select: 
			FSTE A 1 A_Raise(WEAPONTOP); 
			Loop; 
		Fire: 
            // TNT1 A 0 A_Jump(64,"AltKill"); // 64/256 (25%) 的概率跳转到 "AltKill" 状态标签。
			TNT1 A 0 A_Jump(256,"AltKill2");
			TNT1 A 0 A_WeaponOffset(-20,60); // 瞬间调整武器屏幕精灵的偏移量 (x=-20, y=60)。
			FSTE ABBCC 1; 
			FSTE D 1 A_GloryPunch(); 
			FSTE D 2 
			{	
				// WOF_ADD: 偏移量是加到当前值上。 WOF_INTERPOLATE: 平滑插值到目标偏移。
				A_WeaponOffset(30/2,-32/2,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (15, -16) 平滑偏移。
				A_SetRoll(roll+1.25,SPF_INTERPOLATE); // 屏幕 (或武器模型) 旋转+1.25度，平滑插值。
			}
			FSTE D 3 
			{
				A_WeaponOffset(-30/5,32/5,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (-6, 6.4) 平滑偏移。
				A_SetRoll(roll-1.25,SPF_INTERPOLATE); // 屏幕旋转-1.25度，平滑插值。
			}
			TNT1 A 0 A_WeaponOffset(-20,60); // 瞬间重置武器偏移到 (-20, 60)。
			FSTE DCB 3;
			TNT1 A 0 A_ToggleFlip(); // 切换武器精灵的水平翻转。
			FSTE ABBCC 1;
			FSTE D 1 A_GloryPunch(true);
			FSTE D 2 
			{	
				A_WeaponOffset(-30/2,-32/2,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (-15, -16) 平滑偏移。
				A_SetRoll(roll-1.25,SPF_INTERPOLATE); // 屏幕旋转-1.25度。
			}
			FSTE D 3 
			{
				A_WeaponOffset(30/5,32/5,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (6, 6.4) 平滑偏移。
				A_SetRoll(roll+1.25,SPF_INTERPOLATE); // 屏幕旋转+1.25度。
			}
			FSTE DCBA 3;
			Goto Done;
		AltKill:
			BLDE B 1 Offset(-100,70) A_Playsound("weapons/sshoto",7);
			BLDE B 1 Offset(-50,50);
			BLDE A 1 Offset(-5,32)A_Custompunch(17,0,CPF_PULLIN,"bulletpuff");
			BLDE A 4 Offset(1,33);
			TNT1 A 0{
				A_Weaponready(WRF_NOBOB);
				A_GloryPunch(true);
			}
			BLDE A 8 Offset(1,33);
			TNT1 A 0 A_Weaponready(WRF_NOBOB);
			BLDE A 1 Offset(-2,35);
			TNT1 A 0 A_Weaponready(WRF_NOBOB);
			BLDE A 1 Offset(-20,55);
			TNT1 A 0 A_Weaponready(WRF_NOBOB);
			BLDE A 1 Offset(-40,90);
			Goto Done;
		AltKill2:
            // --- 踢击准备和踢出 ---
            TNT1 A 0 A_WeaponOffset(10, -20); // 初始偏移: X向右(或向后), Y向上 (蓄力感)
            KICK A 2;
            KICK B 2 
            {
                A_WeaponOffset(-30, 40, WOF_ADD | WOF_INTERPOLATE);
                A_SetRoll(roll+8.0, SPF_INTERPOLATE);
            }
            KICK C 2 
            {
                A_WeaponOffset(-25, 30, WOF_ADD | WOF_INTERPOLATE);
                A_SetRoll(roll+7.0, SPF_INTERPOLATE);
            }
            // --- 冲击点 ---
            KICK D 5 // 踢中，持续时间稍长以感受冲击
            {
                A_WeaponOffset(-5, 5, WOF_ADD | WOF_INTERPOLATE); // 命中时的微小额外前冲和震动
                A_Custompunch(22, 0, CPF_PULLIN, "BulletPuff"); // 增强的屏幕震动
                A_GloryPunch(true); // 保留原有的荣耀击杀效果
                A_PlaySound("melee/kickhit", CHAN_WEAPON); // 假设有一个踢中音效
            }
            KICK D 2 // 紧接着冲击，开始有收回的趋势
            {
                A_WeaponOffset(20, -30, WOF_ADD | WOF_INTERPOLATE); // X向右(或向后), Y向上 (开始收回)
                A_SetRoll(roll-10.0, SPF_INTERPOLATE); // 屏幕旋转开始恢复
            }
            TNT1 A 0 A_WeaponOffset(5, -10); // 重置到一个稍微收回的中间状态

            KICK C 2
            {
                A_WeaponOffset(-5, 10, WOF_ADD | WOF_INTERPOLATE); // 继续收回，目标是(0,0)
                A_SetRoll(roll-5.0, SPF_INTERPOLATE); // 继续恢复屏幕旋转
            }
            KICK BA 2;
			Goto Done;
	}
}