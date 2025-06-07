class GloryChainsaw : Weapon
{	
	Default
	{
		AttackSound "*chainsaw"; // 攻击音效使用默认的音效。
	}
	
	Weapon prevWeapon; // 存储切换到GloryChainsaw之前的武器。
	Actor ptarget; // 指向荣耀击杀的目标敌人。
	int ptics; // 存储目标敌人被冻结前的原始tics值。
	float vbob; // 存储玩家原始的视角晃动 (ViewBob) 设置。

	// 解析全局变量sv_ggs_ammo并生成相应的弹药
	static void spawnAmmoFromConfig(Actor target)
	{
		if (!target) return;
		// 获取全局变量sv_ggs_ammo的值
		string configStr = sv_ggs_ammo;
		if (configStr == "" || configStr == "0") return;
		// 分割字符串，每两个元素为一组 (物品名,数量)
		Array<String> parts;
		configStr.Split(parts, ",");
		// 确保数组长度是偶数 (物品名和数量成对出现)
		int pairCount = parts.Size() / 2;
		
		for (int i = 0; i < pairCount; i++)
		{
			int itemIndex = i * 2;
			int amountIndex = itemIndex + 1;
			if (itemIndex < parts.Size() && amountIndex < parts.Size())
			{
				string itemName = parts[itemIndex];
				int amount = parts[amountIndex].ToInt();
				// 去除可能的空格
				itemName.Replace(" ", "");
				if (itemName != "" && amount > 0)
				{
					spawnAmmo(target, itemName, amount);
				}
			}
		}
	}

	static void spawnAmmo(Actor target, string item, int amount=1)
	{
		// 合法性判断
		if (!target) return;
		Class<Actor> itemClass = item;
		if (!itemClass){Console.Printf("Warning: '%s' is not a vaila class", item);return;}

		vector3 basePos = target.pos;
		for (int i = 0; i < amount; i++)
		{
			vector3 spawnPos = basePos;
			spawnPos += (
				cos(target.angle) * frandom(-30, 30),
				sin(target.angle) * frandom(-30, 30),
				frandom(5, target.height * 0.75)
			);
			Spawn(item, spawnPos);
		}
	}

	// action 函数 A_ResetWeapon: 用于在荣耀击杀完成或武器被取消选择时，重置玩家和目标的状态。
	// 'invoker' 在action函数中通常指代调用此action的武器自身 (即GloryChainsaw实例)。
	action void A_ResetWeapon()
	{
		PlayerInfo plr = PlayerPawn(self).player; // 获取武器持有者 (玩家) 的PlayerInfo。 'self' 在这里指代武器Actor。

		if(invoker.ptarget) // 如果存在荣耀击杀目标。
		{
			if(sv_glorykilldrops) // 如果启用了荣耀击杀掉落 (CVAR)。
			{
				// float xoffs = cos(invoker.ptarget.angle)*frandom(-30,30);
				// float yoffs = sin(invoker.ptarget.angle)*frandom(-30,30);
				// float zoffs = frandom(5,invoker.ptarget.height * 0.75);
				// vector3 spawnPos = invoker.ptarget.pos + (xoffs, yoffs, zoffs);
				// SpawnAmmo(invoker.ptarget, "ClipBox", 1);
				// SpawnAmmo(invoker.ptarget, "ShellBox", 1);
				// SpawnAmmo(invoker.ptarget, "RocketAmmo", 5);
				// SpawnAmmo(invoker.ptarget, "Cell", 3);
				SpawnAmmoFromConfig(invoker.ptarget);
				
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
			pweapon.ResetInterpolation(); // 重置精灵的插值动画。
		}
		RemoveInventory(invoker); // 从玩家物品栏中移除GloryChainsaw武器。
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
	
	// action 函数 A_GloryChainsaw: 执行一次荣耀击杀的拳击动作。
	// kill: bool, 如果为true，则此拳击会杀死目标。
	action void A_GloryChainsaw(bool kill = false)
	{	
		A_Quake(3,3,0,10,""); // 屏幕震动效果: 强度3, 持续3帧, 半径0 (全屏), 衰减10, 音效标签""。
		// 自定义近战攻击: 伤害1, true表示强制命中, 0点护甲穿透, "BulletPuff"命中效果, 范围64, 无特殊标志, 无特殊伤害类型, 无忽略Actor。
		A_CustomPunch(1,true,0,"BulletPuff",64,0,0,"","none"); 
		if(invoker.ptarget && kill) // 如果存在目标且标记为杀死。
		{
			invoker.ptarget.A_Die("GloryKill"); // 使目标以 "GloryKill" 的方式死亡 (用于触发特殊死亡动画或逻辑)。
			double pwmass = invoker.GetPushWeight(invoker.ptarget.mass); // 计算推力权重。
			// 将目标沿玩家当前角度推开，力度为 20 * pwmass。
			invoker.ptarget.Thrust(4. * pwmass, angle); 
			invoker.ptarget.vel.z += (3. * pwmass); // 给予目标向上的垂直速度。
		}
	}
	
	// States: 定义武器的各种状态和动画序列。
	States
	{
		Ready: 
			TNT1 A 0 A_WeaponReady(); 
			goto Fire; 
		Done: 
			TNT1 A 0 A_WeaponOffset(0,32);
			TNT1 A 0 A_ResetWeapon(); 
		Deselect: 
			TNT1 A 0 A_Lower(WEAPONBOTTOM); 
			Loop; 
		Select: 
			TNT1 A 0 A_Raise(WEAPONTOP); 
			Loop; 
		Fire:
			TNT1 A 0 A_Jump(256,"Altkill1", "Altkill2");
		Altkill1:
			TNT1 A 0 A_AlertMonsters;
			TNT1 A 0 A_Playsound("SAWSWING",7);
			CS2W B 1 Offset(167,117);
			CS2W B 1 Offset(114,111);
			CS2W B 1 Offset(70,107);
			CS2W B 1 Offset(30,103);
			CS2W B 1 Offset(9,103);
			TNT1 A 0 A_Setangle(angle+3);
			CS2W C 2 Offset(-14,99) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W D 2 Offset(-18,99) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W E 2 Offset(-22,98) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W F 2 Offset(-26,98) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W C 2 Offset(-30,97) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W D 2 Offset(-34,97) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W E 2 Offset(-38,96) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W F 2 Offset(-42,96) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W C 2 Offset(-46,97) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W D 2 Offset(-50,97) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W E 2 Offset(-54,98) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W F 2 Offset(-58,98) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W C 2 Offset(-62,99) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			CS2W D 2 offset(-76,99) A_Custompunch(4,0,CPF_PULLIN,"bulletpuff");
			TNT1 A 0 A_GloryChainsaw(true);
			TNT1 A 0 A_Setangle(angle-2);
			CS2W B 1 Offset(-118,101);
			CS2W B 1 Offset(-147,107);
			CS2W B 1 Offset(-192,120);
			CS2W B 1 Offset(-222,129);
			CS2W B 1 Offset(-271,156);
			TNT1 A 0 A_Setangle(angle-1);
			Goto Done; 
		Altkill2:
			TNT1 A 0 A_AlertMonsters;
			FSRD DE 2  {
				A_WeaponOffset(5, 36, WOF_INTERPOLATE);
				A_ZoomFactor(1.1);
			}
			FSRD F 2 {
				A_WeaponOffset(5, 36, WOF_INTERPOLATE);
				A_ZoomFactor(1.2);
				A_SetPitch(pitch - 2);
			}
			FSRD G 5 {
				A_WeaponOffset(5, 36, WOF_INTERPOLATE);
				A_GloryChainsaw(true);
				A_ZoomFactor(1.3);
				A_SetPitch(pitch - 4);
				A_Quake(5, 8, 0, 15, "");
			}
			FSRD H 2 {
				A_WeaponOffset(5, 36, WOF_INTERPOLATE);
				A_ZoomFactor(1.1);
				A_SetPitch(pitch + 2);
				A_Quake(3, 5, 0, 10, "");
			}
			FSRD I 2 {
				A_WeaponOffset(5, 36, WOF_INTERPOLATE);
				A_ZoomFactor(1.0);
				A_SetPitch(pitch + 1);
			}
			FSRD I 10 {
				A_WeaponOffset(5, 150, WOF_INTERPOLATE);
				A_ZoomFactor(1.0);
			}
			Goto Done;
	}
}