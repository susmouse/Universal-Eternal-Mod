// GloryChainsaw: 荣耀击杀专用拳套武器。
class GloryChainsaw : Weapon
{	
	Default
	{
		AttackSound "*chainsaw"; // 攻击音效使用默认的拳头音效。
	}
	
	Weapon prevWeapon; // 存储切换到GloryChainsaw之前的武器。
	Actor ptarget; // 指向荣耀击杀的目标敌人。
	int ptics; // 存储目标敌人被冻结前的原始tics值。
	float vbob; // 存储玩家原始的视角晃动 (ViewBob) 设置。
	
	// action 函数 A_ResetWeapon: 用于在荣耀击杀完成或武器被取消选择时，重置玩家和目标的状态。
	// 'invoker' 在action函数中通常指代调用此action的武器自身 (即GloryChainsaw实例)。
	action void A_ResetWeapon()
	{
		PlayerInfo plr = PlayerPawn(self).player; // 获取武器持有者 (玩家) 的PlayerInfo。 'self' 在这里指代武器Actor。

		if(invoker.ptarget) // 如果存在荣耀击杀目标。
		{
			if(sv_glorykilldrops) // 如果启用了荣耀击杀掉落 (CVAR)。
			{
				// 计算掉落的生命恢复物品数量。基于玩家已损失的生命值，最少掉落1-6个。
				int drops = ceil((80-plr.health)/3)+1;
				if(drops <= 0) drops = random(1,6);
				for(int i = 0; i < drops; i++)
				{	
					// 这些 xoffs, yoffs 似乎是为掉落物设置初始速度或偏移量，但未在 A_SpawnItemEx 中直接用于位置偏移。
					float xoffs = cos(invoker.ptarget.angle)*frandom(-10,10);
					float yoffs = sin(invoker.ptarget.angle)*frandom(-10,10);
					// zoffs 用于调整掉落物生成的垂直位置。
					float zoffs = frandom(5,invoker.ptarget.height);
					// A_SpawnItemEx: 生成物品。
					// "DEHealthLoot": 要生成的物品类型名。 (注意：如果DEHealthLoot未定义，这里会出错。可能应为SuperHealthBonus或类似物品)
					// 0,0: x,y偏移量 (相对于调用者，即玩家)。
					// invoker.ptarget.pos.z-zoffs: z偏移量 (这个计算方式有些奇怪，它将目标z坐标减去一个随机值作为相对于玩家的z偏移，结果是 Player.Z + Target.Z - zoffs)。
					// FRandom(1,3),0,FRandom(4,6): x,y,z速度。
					// FRandom(1,360): 初始角度。
					// SXF_NOCHECKPOSITION: 生成时不检查位置是否合法 (可能穿墙)。
					// SXF_TRANSFERPOINTERS: 将生成物品的target和master指针设为调用者的target和master (在这里，调用者是武器，其target可能是ptarget)。
					// **注意**: 此处 A_SpawnItemEx 的x,y偏移量为0,0，意味着物品会在玩家脚下生成，Z坐标则比较复杂。
					//          更常见的做法是在 invoker.ptarget 的位置生成掉落物。
					//          例如: Spawn("DEHealthLoot", (invoker.ptarget.pos.x + x_rand_offset, invoker.ptarget.pos.y + y_rand_offset, invoker.ptarget.pos.z + z_rand_offset))
					A_SpawnItemEx("DEHealthLoot",0,0,invoker.ptarget.pos.z-zoffs,FRandom(1,3),0,FRandom(4,6),FRandom(1,360),SXF_NOCHECKPOSITION|SXF_TRANSFERPOINTERS);
					
					// 下面是被注释掉的旧代码，它尝试生成 SuperHealthBonus 并设置其速度和追踪目标。
					// let hpup = SuperHealthBonus(Spawn("DEHealthLoot",(invoker.ptarget.pos.x,invoker.ptarget.pos.y,invoker.ptarget.pos.z-zoffs)));
					// if(hpup)
					// {
					// 	hpup.plr = plr.mo;
					// 	hpup.vel.x = xoffs;
					// 	hpup.vel.y = yoffs;
					// }
				}
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
		RemoveInventory(invoker); // 从玩家物品栏中移除GloryChainsaw武器。
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
			invoker.ptarget.Thrust(20. * pwmass, angle); 
			invoker.ptarget.vel.z += (12. * pwmass); // 给予目标向上的垂直速度。
		}
	}
	
	// States: 定义武器的各种状态和动画序列。
	States
	{
		Ready: // 准备状态 (武器空闲时)
			FSTE A 1 A_WeaponReady(); // 显示 FSTE 精灵的 A 帧，持续1帧，并调用 A_WeaponReady (允许玩家开火或切换武器)。
		goto Fire; // 直接跳转到 Fire 状态开始荣耀击杀动画 (这表明一旦选中此武器且有目标，就会自动开始攻击)。
		Done: // 完成状态 (荣耀击杀动画结束)
			FSTE A 1 A_ResetWeapon(); // 显示 FSTE A 帧，持续1帧，并调用 A_ResetWeapon 清理并切换回原武器。
		Deselect: // 取消选择状态 (玩家切换到其他武器时)
			FSTE A 1 A_Lower(WEAPONBOTTOM); // 显示 FSTE A 帧，持续1帧，并开始降低武器的动画 (降至 WEAPONBOTTOM)。
		Loop; // 循环 Deselect 的最后一行，直到武器完全放下。完成后会自动调用 A_ResetWeapon。
		Select: // 选择状态 (玩家切换到此武器时)
			FSTE A 1 A_Raise(WEAPONTOP); // 显示 FSTE A 帧，持续1帧，并开始抬起武器的动画 (升至 WEAPONTOP)。
		Loop; // 循环 Select 的最后一行，直到武器完全抬起，然后通常会进入 Ready 状态。
		Fire: // 开火状态 (执行荣耀击杀动画序列)
			// 随机跳转到备选击杀动画：
            TNT1 A 0 A_Jump(64,"AltKill"); // 64/256 (25%) 的概率跳转到 "AltKill" 状态标签。
			TNT1 A 0 A_Jump(96,"AltKill2"); // 若未跳转到AltKill，则有 96/256 (37.5%) 的概率跳转到 "AltKill2" 状态标签。
			                        // "AltKill" 和 "AltKill2" 状态未在此代码片段中定义。
			// 默认击杀动画序列：
			TNT1 A 0 A_WeaponOffset(-20,60); // 瞬间调整武器屏幕精灵的偏移量 (x=-20, y=60)。
			FSTE ABBCC 1; // 依次显示 FSTE 精灵的 A, B, B, C, C 帧，每帧持续1 tick。
			FSTE D 1 A_GloryChainsaw(); // 显示 D 帧，持续1 tick，并执行一次非致命的 A_GloryChainsaw。
			FSTE D 2 // 显示 D 帧，持续2 ticks。
			{	
				// WOF_ADD: 偏移量是加到当前值上。 WOF_INTERPOLATE: 平滑插值到目标偏移。
				A_WeaponOffset(30/2,-32/2,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (15, -16) 平滑偏移。
				A_SetRoll(roll+1.25,SPF_INTERPOLATE); // 屏幕 (或武器模型) 旋转+1.25度，平滑插值。
			}
			FSTE D 3 // 显示 D 帧，持续3 ticks。
			{
				A_WeaponOffset(-30/5,32/5,WOF_ADD | WOF_INTERPOLATE); // 武器精灵向 (-6, 6.4) 平滑偏移。
				A_SetRoll(roll-1.25,SPF_INTERPOLATE); // 屏幕旋转-1.25度，平滑插值。
			}
			TNT1 A 0 A_WeaponOffset(-20,60); // 瞬间重置武器偏移到 (-20, 60)。
			FSTE DCB 3; // 依次显示 FSTE 精灵的 D, C, B 帧，每帧持续3 ticks。
			TNT1 A 0 A_ToggleFlip(); // 切换武器精灵的水平翻转。
			FSTE ABBCC 1; // 再次显示 A, B, B, C, C 帧，每帧1 tick。
			FSTE D 1 A_GloryChainsaw(true); // 显示 D 帧，持续1 tick，并执行一次致命的 A_GloryChainsaw(true)。
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
			FSTE DCBA 3; // 依次显示 FSTE 精灵的 D, C, B, A 帧，每帧持续3 ticks。
		Goto Done; // 跳转到 Done 状态，结束荣耀击杀。
	}
}