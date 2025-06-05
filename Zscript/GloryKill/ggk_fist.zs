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
			// pweapon.x -= 130; // 调整武器精灵的X坐标 (可能是为了配合动画或重置某种偏移)。
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
	action void A_GloryPunch(bool kill = false,int xPower=10,int zPower=8)
	{	
		A_Quake(3,3,0,10,"");
		A_CustomPunch(1,true,0,"BulletPuff",128,0,0,"","none"); 
		if(invoker.ptarget && kill) // 如果存在目标且标记为杀死。
		{
			invoker.ptarget.A_Die("GloryKill"); // 使目标以 "GloryKill" 的方式死亡 (用于触发特殊死亡动画或逻辑)。
			double pwmass = invoker.GetPushWeight(invoker.ptarget.mass); // 计算推力权重。
			// 将目标沿玩家当前角度推开，力度为 xPower * pwmass。
			invoker.ptarget.Thrust(xPower * pwmass, angle); 
			invoker.ptarget.vel.z += (zPower * pwmass); // 给予目标向上的垂直速度。
		}
	}
	
	// action 函数 A_GloryKick: 执行一次荣耀击杀的踢击动作。
	// kill: bool, 如果为true，则此踢击会杀死目标。
	action void A_GloryKick(bool kill = false,int xPower=20,int zPower=12)
	{	
		A_PlaySound("KICK");
		A_Quake(5,3,0,10,""); // 更强的屏幕震动。
		A_CustomPunch(1,true,0,"BulletPuff",128,0,0,"","none");
		{
			invoker.ptarget.A_Die("GloryKill");
			double pwmass = invoker.GetPushWeight(invoker.ptarget.mass);
			invoker.ptarget.Thrust(xPower * pwmass, angle); 
			invoker.ptarget.vel.z += (zPower * pwmass);
		}
	}	

	States
	{
		Ready:
			PUNG A 1 A_WeaponReady();
			goto Fire; // 直接跳转到 Fire 状态开始荣耀击杀动画 (这表明一旦选中此武器且有目标，就会自动开始攻击)。
		Done:
			TNT1 A 0 A_WeaponOffset(0,32);
			PUNG A 1 A_ResetWeapon(); // 显示 PUNG A 帧，持续1帧，并调用 A_ResetWeapon 清理并切换回原武器。
		Deselect:
			PUNG A 1 A_Lower(WEAPONBOTTOM);
			Loop; // 循环 Deselect 的最后一行，直到武器完全放下。完成后会自动调用 A_ResetWeapon。
		Select: 
			PUNG A 1 A_Raise(WEAPONTOP); 
			Loop; 
		Fire: 
			TNT1 A 0 A_Jump(85,"AltKill"); // 85/256 (约33%) 的概率跳转到 "AltKill" 状态标签。
			TNT1 A 0 A_Jump(170,"AltKill2"); // 85/256 (约33%) 的概率跳转到 "AltKill2" 状态标签。
			TNT1 A 0 A_Jump(256,"AltKill3"); // 剩余概率 (约33%) 跳转到 "AltKill3" 状态标签。
			Goto Done;
		AltKill:
			// Preparation phase - ready stance
			TNT1 A 0 A_PlaySound("*weaponup", 1);
			TNT1 A 0 SetPlayerProperty(0,1,0);
			TNT1 A 0 A_ZoomFactor(1.01);
			TNT1 A 0 A_WeaponOffset(-20,32);
			
			// Initial wind-up with camera movement
			PUNG B 2 {
				A_SetAngle(angle - 2);
				A_SetPitch(pitch - 1);
				A_ZoomFactor(1.00);
			}
			
			// Build tension
			PUNG C 2 {
				A_SetAngle(angle - 1);
				A_SetPitch(pitch - 1);
				A_ZoomFactor(0.99);
				A_Quake(1, 1, 0, 3, "");
			}
			
			// More wind-up
			PUNG C 1 {
				A_SetAngle(angle + 1);
				A_ZoomFactor(0.98);
			}
			
			// First strike preparation
			PUNG D 2 {
				A_SetAngle(angle + 2);
				A_SetPitch(pitch + 1);
				A_ZoomFactor(0.97);
				A_GloryPunch();
			}
			
			// First impact with recoil
			PUNG D 1 {
				A_WeaponOffset(30/2,-32/2,WOF_ADD | WOF_INTERPOLATE);
				A_SetRoll(roll+1.25,SPF_INTERPOLATE);
				A_SetAngle(angle + 3);
				A_Quake(2, 2, 0, 5, "");
				A_ZoomFactor(0.96);
			}
			
			// Hold and stabilize
			PUNG D 1 {
				A_WeaponOffset(-30/5,32/5,WOF_ADD | WOF_INTERPOLATE);
				A_SetRoll(roll-1.25,SPF_INTERPOLATE);
				A_SetAngle(angle - 1);
			}

			// Flip for second strike
			TNT1 A 0 A_ToggleFlip();

			PUNG B 2 {
				A_SetAngle(angle - 2);
				A_SetPitch(pitch - 1);
				A_ZoomFactor(1.00);
			}
			
			// Build tension
			PUNG C 2 {
				A_SetAngle(angle - 1);
				A_SetPitch(pitch - 1);
				A_ZoomFactor(0.99);
				A_Quake(1, 1, 0, 3, "");
			}
			
			// More wind-up
			PUNG C 1 {
				A_SetAngle(angle + 1);
				A_ZoomFactor(0.98);
			}
			
			// First strike preparation
			PUNG D 2 {
				A_SetAngle(angle + 2);
				A_SetPitch(pitch + 1);
				A_ZoomFactor(0.97);
				A_GloryPunch();
			}
			
			// First impact with recoil
			PUNG D 1 {
				A_WeaponOffset(30/2,-32/2,WOF_ADD | WOF_INTERPOLATE);
				A_SetRoll(roll+1.25,SPF_INTERPOLATE);
				A_SetAngle(angle + 3);
				A_Quake(2, 2, 0, 5, "");
				A_ZoomFactor(0.96);
			}
			
			// Hold and stabilize
			PUNG D 1 {
				A_WeaponOffset(-30/5,32/5,WOF_ADD | WOF_INTERPOLATE);
				A_SetRoll(roll-1.25,SPF_INTERPOLATE);
				A_SetAngle(angle - 1);
				A_GloryPunch(true);
			}

			// Return to neutral
			TNT1 A 0 A_GloryPunch(true);
			PUNG D 0 A_ZoomFactor(0.98);
			PUNG C 0 A_SetPitch(pitch - 1);
			PUNG B 0 A_ZoomFactor(1.0);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Goto Done;
		AltKill2:
			// Preparation phase - ready the blade
			TNT1 A 0 A_PlaySound("*weaponup", 1);
			TNT1 A 0 SetPlayerProperty(0,1,0);
			TNT1 A 0 A_ZoomFactor(1.02);
			TNT1 A 0 A_SetPitch(pitch - 1);
			
			// Initial crouch/ready position
			BLIN A 3 Offset(0, 45) {
				A_ZoomFactor(1.01);
				A_SetAngle(angle - 1);
			}
			
			// Wind up - building tension
			BLIN A 4 Offset(-8, 50) {
				A_SetAngle(angle - 3);
				A_SetPitch(pitch - 2);
				A_ZoomFactor(0.99);
				A_Quake(1, 1, 0, 3, "");
			}
			
			// More wind up - increasing tension
			BLIN A 3 Offset(-12, 55) {
				A_SetAngle(angle - 2);
				A_SetPitch(pitch - 1);
				A_ZoomFactor(0.98);
			}
			
			// Begin thrust - acceleration starts
			TNT1 A 0 A_ZoomFactor(0.96);
			BLIN B 2 Offset(-5, 48) {
				A_SetAngle(angle + 2);
				A_SetPitch(pitch + 1);
			}
			
			// Rapid extension - high speed
			TNT1 A 0 A_ZoomFactor(0.94);
			BLIN B 1 Offset(5, 40) {
				A_SetAngle(angle + 4);
				A_SetPitch(pitch + 2);
				A_Quake(2, 2, 0, 5, "");
			}
			
			// Maximum extension - peak velocity
			TNT1 A 0 A_ZoomFactor(0.92);
			BLIN C 1 Offset(15, 32) {
				A_SetAngle(angle + 3);
				A_SetPitch(pitch + 1);
			}
			
			// Impact moment - full extension
			TNT1 A 0 A_ZoomFactor(0.90);
			TNT1 A 0 A_Quake(4, 4, 0, 10, "");
			BLIN C 1 Offset(25, 28) {
				A_SetAngle(angle + 2);
				A_GloryPunch(true, 15, 10);
			}
			
			// Hold at maximum extension
			BLIN C 3 Offset(25, 28) {
				A_ZoomFactor(0.91);
			}
			
			// Begin retraction - slow start
			TNT1 A 0 A_PlaySound("*land", 3);
			TNT1 A 0 A_ZoomFactor(0.93);
			BLIN C 3 Offset(20, 30) {
				A_SetAngle(angle - 1);
			}
			
			// Accelerating retraction
			TNT1 A 0 A_ZoomFactor(0.95);
			BLIN A 2 Offset(12, 35) {
				A_SetAngle(angle - 2);
			}
			
			// Faster retraction
			TNT1 A 0 A_ZoomFactor(0.97);
			BLIN A 2 Offset(4, 42);
			
			// Final retraction to ready position
			TNT1 A 0 A_ZoomFactor(0.99);
			BLIN A 3 Offset(-2, 52) {
				A_SetAngle(angle - 1);
			}
			
			// Return to neutral
			TNT1 A 0 A_ZoomFactor(1.0);
			BLIN A 2 Offset(0, 65);
			
			// Reset everything
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Goto Done;
		AltKill3:
			// Preparation phase
			TNT1 A 0 A_PlaySound("KICK", 1);
			TNT1 A 0 SetPlayerProperty(0,1,0);
			TNT1 A 0 A_ZoomFactor(0.98);
			
			// Starting position
			KIC1 A 2 Offset(0, 40);
			TNT1 A 0 A_SetAngle(angle - 3);
			TNT1 A 0 A_ZoomFactor(0.97);
			
			// Wind up
			KIC1 A 3 Offset(-5, 45) {
				A_SetAngle(angle - 2);
				A_Quake(1, 2, 0, 5, "");
			}
			
			// Kick extension - fast and powerful
			TNT1 A 0 A_ZoomFactor(0.95);
			KIC1 B 1 Offset(10, 35) A_SetAngle(angle + 2);
			TNT1 A 0 A_ZoomFactor(0.92);
			KIC1 B 1 Offset(20, 30) A_SetAngle(angle + 3);
			TNT1 A 0 A_Quake(3, 3, 0, 8, "");
			
			// Impact moment
			TNT1 A 0 A_ZoomFactor(0.90);
			KIC1 C 1 Offset(30, 25) {
				A_SetAngle(angle + 5);
				A_GloryKick(true, 25, 15);
			}
			
			// Hold the extended position briefly
			KIC1 C 4 Offset(30, 25) A_ZoomFactor(0.91);
			
			// Begin retraction
			TNT1 A 0 A_PlaySound("PIHOL", 4);
			TNT1 A 0 A_ZoomFactor(0.93);
			KIC1 C 2 Offset(25, 28) A_SetAngle(angle - 2);
			
			// Continue retracting
			TNT1 A 0 A_ZoomFactor(0.95);
			KIC1 B 2 Offset(15, 32) A_SetAngle(angle - 3);
			
			// Return to normal position
			TNT1 A 0 A_ZoomFactor(0.97);
			KIC1 B 2 Offset(5, 38) A_SetAngle(angle - 2);
			
			// Final position
			TNT1 A 0 A_ZoomFactor(0.99);
			KIC1 A 2 Offset(0, 40);
			
			// Reset everything
			TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 SetPlayerProperty(0,0,0);
			Goto Done;
	}
}