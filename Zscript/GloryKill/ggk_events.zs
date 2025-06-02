class GGKDamageScaler : Inventory
{
	int prevtic;
	Default
	{
		Inventory.MaxAmount 1;
	}
	
	override void ModifyDamage(int damage, Name damagetype, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		float dmg_mod = passive ? sv_indamagemod : sv_outdamagemod;
		
		// 只有当 sv_ggk_enabled 为 true 时，才执行硬直逻辑
		if (sv_ggk_enabled) 
		{
			/*
				Do all the stagger logic, random chance an otherwise gibbed enemy to stagger instead
				Invuln is set because this function gets called multiple times per tic.
				Invuln should be inactive after 2 tics of stagger, if it isn't forcefully disable it.
			*/
			
			// Prevtic is used so that weapons that make multiple damage calls per-tic do not have a MUCH higher
			// chance to stagger enemies.
			
			if(!passive && source && source.bISMONSTER && !source.FindInventory("IStagger") && GetAge() != prevtic) // 确保source有效且是怪物
			{	
				prevtic = GetAge();
				// 只有当 lk_GGKHandler 认为可以硬直时 (它内部也会检查 sv_ggk_enabled)
				// 或者，如果会致死且随机硬直成功
				if( lk_GGKHandler.CheckStagger(source, damage*dmg_mod) || 
					(source.health-(damage*dmg_mod) <= 0 && lk_GGKHandler.DoStagger()) ) 
				{
					newdamage = source.health/2;
					source.A_GiveInventory("IStagger",1);
					source.bInvulnerable = true;
					// 应用伤害缩放后再返回，因为硬直也应该受到伤害修正的影响
					// newdamage = max(1, ApplyDamageFactors(GetClass(), damageType, newdamage, float(newdamage) * dmg_mod)); // 如果希望硬直伤害也应用dmg_mod
					// 或者，如果硬直伤害就是 source.health/2，不应用 dmg_mod，则直接 return
					// 当前的逻辑是硬直时，伤害就是 source.health/2，并且后续的伤害缩放也不会再执行，直接返回
					// 同时，硬直后的敌人血量也会是 source.health - source.health/2 = source.health/2
					return; 
				}
			}
			// 仅当MOD启用，且是主动攻击，且目标无敌，但目标身上没有IStagger时，才解除无敌
			// 这是为了处理非硬直攻击时，目标可能因其他原因（或之前的硬直逻辑bug）处于无敌状态的情况
			// 并且确保不会错误地解除真正硬直状态下的无敌
			else if(!passive && source && source.bInvulnerable && !source.FindInventory("IStagger"))  
				source.bInvulnerable = false;
		}
		// 即使MOD被禁用，或者硬直逻辑未触发，仍然应用基础的伤害缩放
		// 如果希望MOD禁用时完全不应用任何来自此物品的伤害修改，可以将这行也包在 if(sv_ggk_enabled) 里，并在else中设置 newdamage = damage;
		// 但通常dmg_mod是独立的伤害调整，可能希望保留
		newdamage = max(1, ApplyDamageFactors(GetClass(), damageType, damage, float(damage) * dmg_mod));
	}
}

class lk_GGKHandler : StaticEventHandler
{
	Actor pendingkill;
	GloryFist pfist;
	// IStagger estagger; // estagger 在 WorldTick 中赋值但未被有效使用，可以考虑移除或明确其用途

	// 静态方法，判定是否触发随机硬直
	static bool DoStagger()
	{
		// 只有当 sv_ggk_enabled 为 true 时，才有可能触发硬直
		if (!sv_ggk_enabled) return false;
		return ( (100-sv_glorystunchance)-random[StaggerRNG](0,100) <= 0 );
	}
	
	// 静态方法，检查一个 Actor 在受到一定伤害后是否应该进入硬直状态
	static bool CheckStagger(Actor thing, float dmgtaken)
	{
		// 只有当 sv_ggk_enabled 为 true 时，才有可能触发硬直
		if (!sv_ggk_enabled) return false;
		if (!thing) return false; // 添加空指针检查

		bool randstagger = DoStagger(); // DoStagger 内部已经检查了 sv_ggk_enabled
		return ( thing.health > 0 && (thing.health-dmgtaken <= thing.SpawnHealth()*sv_staggerhealth) && randstagger );
	}

	override void WorldTick()
	{
		PlayerPawn plr = PlayerPawn(players[consoleplayer].mo);
		if(!plr) return;
		
		// 确保玩家始终拥有伤害调整器（即使MOD关闭，伤害调整器的其他效果如dmg_mod可能仍需保留）
		if(!plr.FindInventory("GGKDamageScaler")) plr.GiveInventory("GGKDamageScaler", 1);

		// 如果MOD被禁用 (sv_ggk_enabled 为 false)
		if (!sv_ggk_enabled)
		{
			// 如果之前有待处理的击杀目标，清除它
			if (pendingkill)
			{
				// 尝试移除可能残留的IStagger和无敌状态
				if (pendingkill.FindInventory("IStagger")) pendingkill.TakeInventory("IStagger", 1);
				if (pendingkill.bInvulnerable) pendingkill.bInvulnerable = false;
				pendingkill = null;
			}
			// 如果玩家持有GloryFist，也移除它，并尝试切换回上一个武器
			GloryFist currentFist = GloryFist(plr.FindInventory("GloryFist"));
			if (currentFist)
			{
				// 如果 GloryFist 是当前武器，尝试切换到上一个武器
				if (plr.player && plr.player.ReadyWeapon == currentFist)
				{
					Weapon prevWeapon = plr.player.PendingWeapon; // PendingWeapon 通常是切换前的武器
					if (prevWeapon == currentFist || prevWeapon == null || prevWeapon.GetClass() == Name("Fist")) // 如果 PendingWeapon 还是 GloryFist 或无效，找个默认的
					{
						// 尝试找到一个非Fist, 非GloryFist的武器
						for (Inventory inv = plr.Inv; inv != null; inv = inv.Inv)
						{
							Weapon w = Weapon(inv);
							if (w && w != currentFist && w.GetClass() != Name("Fist") && w.GetClass() != Name("GloryFist"))
							{
								prevWeapon = w;
								break;
							}
						}
						if(prevWeapon == null || prevWeapon == currentFist) prevWeapon = Weapon(plr.FindInventory("Fist")); // 最后手段，切换到拳头
					}
					if (prevWeapon) plr.A_SelectWeapon(prevWeapon.GetClass());
				}
				plr.TakeInventory("GloryFist", 1);
			}
			pfist = null; // 清除引用
			return; // 不执行后续的GGK逻辑
		}

		// --- 以下是 MOD 启用时的逻辑 ---

		bool dokill = pendingkill && pendingkill.health >  0;
		bool isdead = pendingkill && pendingkill.health <= 0;
		
		pfist = GloryFist(plr.FindInventory("GloryFist"));
		// if(dokill) estagger = IStagger(pendingkill.FindInventory("IStagger")); // estagger 仍未被使用

		if(pfist && !pfist.ptarget) pfist.ptarget = pendingkill;
			
		if(isdead && pfist && pendingkill) // 添加pendingkill检查
		{
			pendingkill.TakeInventory("IStagger",1);
			// 当目标死亡时，重置 pendingkill，允许玩家寻找新目标
			pendingkill = null; 
		}
		
		if(dokill && plr.Distance3D(pendingkill) <= 64 && !pfist) 
		{	
			plr.A_GiveInventory("GloryFist",1);
			plr.A_SelectWeapon("GloryFist");
		}
		// 如果 pendingkill 目标跑远了或者玩家取消了（比如切换武器），也应该重置 pendingkill
		// 或者如果 pendingkill 上的 IStagger 超时消失了
		if (pendingkill && pendingkill.health > 0)
		{
			if (!pendingkill.FindInventory("IStagger") || plr.Distance3D(pendingkill) > sv_glorykillrange + 10) // sv_glorykillrange是NetworkProcess里的，这里用一个类似的值
			{
				// 如果目标不再硬直，或者跑太远，清除它
				if (pendingkill.bInvulnerable) pendingkill.bInvulnerable = false; // 解除可能残留的无敌
				pendingkill = null;
				// 如果玩家正拿着GloryFist但没有目标了，可以考虑切换回之前的武器
				if (pfist && plr.player && plr.player.ReadyWeapon == pfist)
				{
					// (切换武器逻辑，类似上面MOD禁用时的处理)
					Weapon prevWeapon = plr.player.PendingWeapon;
                    if (prevWeapon == pfist || prevWeapon == null || prevWeapon.GetClass() == Name("Fist"))
                    {
                        for (Inventory inv = plr.Inv; inv != null; inv = inv.Inv)
                        {
                            Weapon w = Weapon(inv);
                            if (w && w != pfist && w.GetClass() != Name("Fist") && w.GetClass() != Name("GloryFist"))
                            {
                                prevWeapon = w;
                                break;
                            }
                        }
                        if(prevWeapon == null || prevWeapon == pfist) prevWeapon = Weapon(plr.FindInventory("Fist"));
                    }
                    if (prevWeapon) plr.A_SelectWeapon(prevWeapon.GetClass());
				}
			}
		}
	}

	override void NetworkProcess(ConsoleEvent ev)
	{
		// 只有当 sv_ggk_enabled 为 true 时，才处理光荣击杀按键事件
		if (!sv_ggk_enabled) return;

		PlayerPawn plr = PlayerPawn(players[ev.Player].mo);
		if(!plr) return;
		
		// 如果当前已经有一个存活的待处理光荣击杀目标，则不寻找新的目标
		// 除非玩家再次按下 glory_kill 是为了取消当前目标或强制寻找（这需要更复杂的逻辑）
		// 当前逻辑是：如果已有pendingkill，则不处理新的按键，除非pendingkill已死亡
		if(pendingkill && pendingkill.health > 0) return; 
		
		if(ev.Name == "glory_kill")
		{
			FLineTraceData lt_data;
			plr.LineTrace(plr.angle,sv_glorykillrange,plr.pitch,0,plr.viewheight,0,0,lt_data);
			if(lt_data.HitType == TRACE_HitActor)
			{
				Actor thinghit = lt_data.HitActor;
				if (!thinghit || !thinghit.bISMONSTER) return; // 确保击中的是Actor且是怪物

				let staggered = IStagger(thinghit.FindInventory("IStagger"));
				if(!staggered) return;				
				
				pendingkill = thinghit;
				// 如果目标没有ObjectMover，才给予
				if (!pendingkill.FindInventory("ObjectMover")) pendingkill.GiveInventory("ObjectMover",1);
				
				let omover = ObjectMover(pendingkill.FindInventory("ObjectMover"));
				if(omover) 
				{
					omover.to = plr;
					omover.dist = 64; // 可以考虑使用一个CVAR来控制这个距离
				}
			}
		}
	}
}