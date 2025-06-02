// GloryKill/
// │   ├── ggk_events.zs
// │   ├── ggk_items.zs
// │   └── ggk_weapons.zs

// ---

// **ggk_events.zs**

// ZScript头文件，通常包含事件处理器和伤害修改等逻辑

class GGKDamageScaler : Inventory // 定义一个名为 GGKDamageScaler 的类，它继承自 Inventory 类。这类物品通常用于修改玩家或怪物的属性或行为。
{
	int prevtic; // 上一个游戏逻辑帧（tic）的编号，用于防止单次攻击（但可能在同一帧内多次调用ModifyDamage）多次触发硬直判定。
	Default
	{
		Inventory.MaxAmount 1; // 此物品在玩家物品栏中最多只能存在1个。
	}
	
	// 覆写父类的 ModifyDamage 方法，用于修改将要造成的伤害值。
	// damage: 原始伤害值
	// damagetype: 伤害类型名
	// newdamage: (out) 修改后的伤害值
	// passive: bool, 如果为true，表示是承受伤害（输入伤害）；如果为false，表示是造成伤害（输出伤害）。
	// inflictor: Actor, 实际造成伤害的实体（例如发射物）。
	// source: Actor, 伤害来源实体（例如开火的玩家或怪物）。
	// flags: int, 伤害标志位。
	override void ModifyDamage(int damage, Name damagetype, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		// 根据是承受伤害还是造成伤害，选择不同的伤害修正系数 (CVAR)。
		// sv_indamagemod: 服务器控制的承受伤害修正。
		// sv_outdamagemod: 服务器控制的造成伤害修正。
		float dmg_mod = passive ? sv_indamagemod : sv_outdamagemod;
		
		// 只有当光荣击杀MOD启用 (sv_ggk_enabled 为 true) 时，才执行硬直相关逻辑。
		if (sv_ggk_enabled) 
		{
			/*
				Do all the stagger logic, random chance an otherwise gibbed enemy to stagger instead
				Invuln is set because this function gets called multiple times per tic.
				Invuln should be inactive after 2 tics of stagger, if it isn't forcefully disable it.
				(注释原意：执行所有硬直逻辑，有几率让本应被击碎的敌人进入硬直状态。
				 设置无敌是因为此函数每帧可能被多次调用。
				 硬直2帧后应解除无敌，如果未解除则强制解除。)
			*/
			
			// Prevtic is used so that weapons that make multiple damage calls per-tic do not have a MUCH higher
			// chance to stagger enemies.
			// (注释原意：prevtic 用于确保那些每帧多次调用伤害计算的武器不会因此有更高的几率使敌人硬直。)
			
			// 条件检查：
			// !passive: 必须是主动造成的伤害。
			// source: 伤害来源必须存在。
			// source.bISMONSTER: 伤害来源必须是怪物类型 (这里似乎应该是伤害目标是怪物，如果这是玩家持有的物品，那么 source 可能是玩家，目标是怪物。如果是怪物攻击玩家，source 是怪物。结合上下文，这里的 source 指的是被攻击者）。
			//                  如果这个 GGKDamageScaler 是给玩家的，那么 !passive 意味着玩家攻击，source 指的是被攻击的敌人。
			// !source.FindInventory("IStagger"): 目标当前未处于硬直状态。
			// GetAge() != prevtic: 确保同一帧内对同一目标的多次伤害调用只判定一次硬直。GetAge() 返回Actor的存活tick数。
			//                     对于GGKDamageScaler这个物品来说，GetAge()是物品的存活时间，可能不是最佳选择，如果这个物品一直存在于玩家身上，
			//                     更合适的可能是level.maptime (当前关卡时间) 或者针对特定攻击事件的唯一ID。但这里用了GetAge()。
			if(!passive && source && source.bISMONSTER && !source.FindInventory("IStagger") && GetAge() != prevtic) // 确保source有效且是怪物 (被攻击者)
			{	
				prevtic = GetAge(); // 更新 prevtic 为当前物品年龄/帧。
				// 硬直判定条件：
				// 1. lk_GGKHandler.CheckStagger(...) 返回 true：目标在承受此次伤害（已乘以dmg_mod）后，生命值低于其最大生命值的一定比例 (sv_staggerhealth)，并且通过了随机硬直检定。
				// 或者
				// 2. (source.health-(damage*dmg_mod) <= 0 && lk_GGKHandler.DoStagger()): 此次伤害（已乘以dmg_mod）足以致死目标，并且通过了随机硬直检定（即“死亡豁免硬直”）。
				if( lk_GGKHandler.CheckStagger(source, damage*dmg_mod) || 
					(source.health-(damage*dmg_mod) <= 0 && lk_GGKHandler.DoStagger()) ) 
				{
					newdamage = source.health/2; // 如果触发硬直，本次伤害值被修改为目标当前生命值的一半。
					source.A_GiveInventory("IStagger",1); // 给予目标 "IStagger" 物品，使其进入硬直状态。
					source.bInvulnerable = true; // 使目标在硬直瞬间暂时无敌，防止被后续伤害立即杀死。
					// 应用伤害缩放后再返回，因为硬直也应该受到伤害修正的影响
					// newdamage = max(1, ApplyDamageFactors(GetClass(), damageType, newdamage, float(newdamage) * dmg_mod)); // (注释掉的代码) 如果希望硬直伤害也应用dmg_mod
					// 或者，如果硬直伤害就是 source.health/2，不应用 dmg_mod，则直接 return
					// 当前的逻辑是硬直时，伤害就是 source.health/2，并且后续的伤害缩放也不会再执行，直接返回
					// 同时，硬直后的敌人血量也会是 source.health - source.health/2 = source.health/2
					return; // 直接返回，不执行后续的默认伤害缩放逻辑。
				}
			}
			// 仅当MOD启用，且是主动攻击，且目标（source）无敌，但目标身上没有IStagger时，才解除无敌。
			// 这是为了处理非硬直攻击时，目标可能因其他原因（或之前的硬直逻辑bug）处于无敌状态的情况。
			// 并且确保不会错误地解除真正硬直状态下的无敌。
			else if(!passive && source && source.bInvulnerable && !source.FindInventory("IStagger"))  
				source.bInvulnerable = false; // 解除目标的无敌状态。
		}
		// 即使MOD被禁用，或者硬直逻辑未触发，仍然应用基础的伤害缩放。
		// ApplyDamageFactors 是GZDoom内置函数，用于应用护甲、伤害类型抗性等修正。
		// float(damage) * dmg_mod 是应用了本MOD定义的输出/输入伤害修正后的值。
		// 如果希望MOD禁用时完全不应用任何来自此物品的伤害修改，可以将这行也包在 if(sv_ggk_enabled) 里，并在else中设置 newdamage = damage;
		// 但通常dmg_mod是独立的伤害调整，可能希望保留。
		newdamage = max(1, ApplyDamageFactors(GetClass(), damageType, damage, float(damage) * dmg_mod)); // 计算最终伤害，确保至少为1。
	}
}

class lk_GGKHandler : StaticEventHandler // 定义一个名为 lk_GGKHandler 的类，继承自 StaticEventHandler。这类处理器用于响应全局游戏事件。
{
	Actor pendingkill; // Actor类型的变量，指向等待被光荣击杀的目标。
	GloryFist pfist; // GloryFist类型的变量，指向玩家当前持有的光荣击杀拳套武器。
	// IStagger estagger; // (原注释) estagger 在 WorldTick 中赋值但未被有效使用，可以考虑移除或明确其用途。

	// 静态方法，判定是否触发随机硬直（例如，死亡豁免硬直）。
	static bool DoStagger()
	{
		// 只有当 sv_ggk_enabled 为 true 时，才有可能触发硬直。
		if (!sv_ggk_enabled) return false; // 如果MOD未启用，直接返回false。
		// sv_glorystunchance: 服务器控制的硬直几率 (0-100)。
		// random[StaggerRNG](0,100): 从名为 "StaggerRNG" 的随机数生成器取一个0到100之间的随机数。
		// (100 - sv_glorystunchance) 是不触发硬直的阈值。如果随机数大于等于这个阈值，则硬直成功。
		// 例如，如果 sv_glorystunchance = 70, 阈值是 30。随机数 [30, 100] 则成功。概率为 (100-30+1)/101 ~= 70/100。
		// 简单来说，就是有 sv_glorystunchance / 100 的概率返回 true。
		return ( (100-sv_glorystunchance)-random[StaggerRNG](0,100) <= 0 );
	}
	
	// 静态方法，检查一个 Actor (thing) 在受到一定伤害 (dmgtaken) 后是否应该进入硬直状态。
	static bool CheckStagger(Actor thing, float dmgtaken)
	{
		// 只有当 sv_ggk_enabled 为 true 时，才有可能触发硬直。
		if (!sv_ggk_enabled) return false; // 如果MOD未启用，返回false。
		if (!thing) return false; // 添加空指针检查，确保目标存在。

		bool randstagger = DoStagger(); // 调用 DoStagger 获取随机硬直检定结果。DoStagger 内部已检查 sv_ggk_enabled。
		// 硬直条件：
		// 1. thing.health > 0: 目标当前必须存活。
		// 2. (thing.health - dmgtaken <= thing.SpawnHealth() * sv_staggerhealth): 目标在承受伤害后，生命值将低于其初始生命值乘以 sv_staggerhealth (硬直生命值百分比阈值)。
		// 3. randstagger: 随机硬直检定通过。
		return ( thing.health > 0 && (thing.health-dmgtaken <= thing.SpawnHealth()*sv_staggerhealth) && randstagger );
	}

	// 覆写 WorldTick 方法，此方法在游戏世界的每个逻辑帧都会被调用。
	override void WorldTick()
	{
		PlayerPawn plr = PlayerPawn(players[consoleplayer].mo); // 获取当前控制台玩家的 PlayerPawn 对象。
		if(!plr) return; // 如果获取不到玩家，则不执行后续逻辑。
		
		// 确保玩家始终拥有伤害调整器（GGKDamageScaler）。
		// 即使MOD关闭，伤害调整器的其他效果（如dmg_mod，如果独立于sv_ggk_enabled）可能仍需保留。
		if(!plr.FindInventory("GGKDamageScaler")) plr.GiveInventory("GGKDamageScaler", 1);

		// 如果MOD被禁用 (sv_ggk_enabled 为 false)
		if (!sv_ggk_enabled)
		{
			// 如果之前有待处理的击杀目标 (pendingkill)，清除它。
			if (pendingkill)
			{
				// 尝试移除可能残留在 pendingkill 目标身上的 IStagger 物品和无敌状态。
				if (pendingkill.FindInventory("IStagger")) pendingkill.TakeInventory("IStagger", 1);
				if (pendingkill.bInvulnerable) pendingkill.bInvulnerable = false;
				pendingkill = null; // 清除待处理目标。
			}
			// 如果玩家持有GloryFist武器，也移除它，并尝试切换回上一个武器。
			GloryFist currentFist = GloryFist(plr.FindInventory("GloryFist")); // 查找玩家是否拥有 GloryFist。
			if (currentFist)
			{
				// 如果 GloryFist 是当前装备的武器，尝试切换到上一个武器。
				if (plr.player && plr.player.ReadyWeapon == currentFist)
				{
					Weapon prevWeapon = plr.player.PendingWeapon; // PendingWeapon 通常是切换前的武器。
					// 如果 PendingWeapon 还是 GloryFist 或无效，或者为基础拳头，则尝试寻找一个更合适的武器。
					if (prevWeapon == currentFist || prevWeapon == null || prevWeapon.GetClass() == Name("Fist")) 
					{
						// 尝试找到一个非Fist, 非GloryFist的武器。
						for (Inventory inv = plr.Inv; inv != null; inv = inv.Inv)
						{
							Weapon w = Weapon(inv);
							if (w && w != currentFist && w.GetClass() != Name("Fist") && w.GetClass() != Name("GloryFist"))
							{
								prevWeapon = w;
								break;
							}
						}
						// 如果找不到其他武器，或者找到的还是GloryFist (逻辑上不应发生)，则最后手段是切换到基础拳头 ("Fist")。
						if(prevWeapon == null || prevWeapon == currentFist) prevWeapon = Weapon(plr.FindInventory("Fist")); 
					}
					if (prevWeapon) plr.A_SelectWeapon(prevWeapon.GetClass()); // 切换到找到的先前武器。
				}
				plr.TakeInventory("GloryFist", 1); // 从玩家物品栏中移除 GloryFist。
			}
			pfist = null; // 清除 GloryFist 实例的引用。
			return; // MOD禁用，不执行后续的GGK逻辑。
		}

		// --- 以下是 MOD 启用时的逻辑 ---

		bool dokill = pendingkill && pendingkill.health >  0; // 标志：是否有存活的待光荣击杀目标。
		bool isdead = pendingkill && pendingkill.health <= 0; // 标志：待光荣击杀目标是否已死亡。
		
		pfist = GloryFist(plr.FindInventory("GloryFist")); // 更新玩家持有的 GloryFist 引用。
		// if(dokill) estagger = IStagger(pendingkill.FindInventory("IStagger")); // (原注释) estagger 仍未被使用

		// 如果玩家持有 GloryFist 且其 ptarget (拳套的目标) 未设置，则将其设置为当前的 pendingkill 目标。
		if(pfist && !pfist.ptarget) pfist.ptarget = pendingkill;
			
		// 如果目标已死亡 (isdead)，且玩家持有 GloryFist (pfist)，并且 pendingkill 目标存在。
		if(isdead && pfist && pendingkill) // 添加pendingkill检查
		{
			pendingkill.TakeInventory("IStagger",1); // 移除死亡目标身上的 IStagger 物品。
			// 当目标死亡时，重置 pendingkill，允许玩家寻找新目标。
			pendingkill = null; 
		}
		
		// 如果有存活的待击杀目标 (dokill)，玩家与目标的距离小于等于64个单位，且玩家当前未持有 GloryFist。
		if(dokill && plr.Distance3D(pendingkill) <= 64 && !pfist) 
		{	
			plr.A_GiveInventory("GloryFist",1); // 给予玩家 GloryFist 武器。
			plr.A_SelectWeapon("GloryFist"); // 自动切换到 GloryFist 武器。
		}
		// 如果 pendingkill 目标跑远了或者玩家取消了（比如切换武器），也应该重置 pendingkill。
		// 或者如果 pendingkill 上的 IStagger 超时消失了。
		if (pendingkill && pendingkill.health > 0) // 如果存在存活的待击杀目标
		{
			// 条件：目标不再拥有 IStagger (硬直状态结束)，或者玩家与目标的距离超过了光荣击杀范围 (sv_glorykillrange) 加一点缓冲。
			if (!pendingkill.FindInventory("IStagger") || plr.Distance3D(pendingkill) > sv_glorykillrange + 10) 
			{
				// 如果目标不再硬直，或者跑太远，清除它。
				if (pendingkill.bInvulnerable) pendingkill.bInvulnerable = false; // 解除可能残留的无敌状态。
				pendingkill = null; // 清除待击杀目标。
				// 如果玩家正拿着GloryFist但没有目标了，可以考虑切换回之前的武器。
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
                    if (prevWeapon) plr.A_SelectWeapon(prevWeapon.GetClass()); // 切换武器。
				}
			}
		}
	}

	// 覆写 NetworkProcess 方法，用于处理网络同步的控制台事件 (如按键)。
	// ev: ConsoleEvent 对象，包含事件信息 (如玩家编号、事件名)。
	override void NetworkProcess(ConsoleEvent ev)
	{
		// 只有当 sv_ggk_enabled 为 true 时，才处理光荣击杀按键事件。
		if (!sv_ggk_enabled) return;

		PlayerPawn plr = PlayerPawn(players[ev.Player].mo); // 获取触发事件的玩家。
		if(!plr) return; // 如果玩家无效，则返回。
		
		// 如果当前已经有一个存活的待处理光荣击杀目标 (pendingkill)，则不寻找新的目标。
		// 除非玩家再次按下 glory_kill 是为了取消当前目标或强制寻找（这需要更复杂的逻辑）。
		// 当前逻辑是：如果已有pendingkill (且存活)，则不处理新的按键。
		if(pendingkill && pendingkill.health > 0) return; 
		
		// 如果事件名为 "glory_kill" (通常是光荣击杀的绑定按键)。
		if(ev.Name == "glory_kill")
		{
			FLineTraceData lt_data; // 用于存储 LineTrace (射线检测) 的结果。
			// 从玩家视角进行射线检测，检测范围为 sv_glorykillrange。
			// plr.angle: 玩家水平朝向。
			// sv_glorykillrange: 光荣击杀的最大有效距离 (CVAR)。
			// plr.pitch: 玩家垂直朝向。
			// 0: Z偏移量。
			// plr.viewheight: 射线起始高度 (玩家视线高度)。
			// 0, 0: 未使用的参数 (通常是 forcenossboxtrace, trace σημαίας)。
			// lt_data: 输出参数，存储检测结果。
			plr.LineTrace(plr.angle,sv_glorykillrange,plr.pitch,0,plr.viewheight,0,0,lt_data);
			
			// 如果射线击中了 Actor (实体)。
			if(lt_data.HitType == TRACE_HitActor)
			{
				Actor thinghit = lt_data.HitActor; // 获取被击中的 Actor。
				if (!thinghit || !thinghit.bISMONSTER) return; // 确保击中的是有效 Actor 且是怪物类型。

				let staggered = IStagger(thinghit.FindInventory("IStagger")); // 检查被击中的怪物是否拥有 "IStagger" 物品 (即是否处于硬直状态)。
				if(!staggered) return; // 如果怪物未硬直，则不进行后续操作。			
				
				pendingkill = thinghit; // 将被击中的硬直怪物设置为待光荣击杀目标。
				// 如果目标没有ObjectMover物品 (用于将怪物拉向玩家)，才给予它一个。
				if (!pendingkill.FindInventory("ObjectMover")) pendingkill.GiveInventory("ObjectMover",1);
				
				let omover = ObjectMover(pendingkill.FindInventory("ObjectMover")); // 获取目标身上的 ObjectMover 实例。
				if(omover) 
				{
					omover.to = plr; // 设置 ObjectMover 的目标为玩家。
					omover.dist = 64; // 设置怪物被拉到距离玩家多近时停止 (可以考虑使用一个CVAR来控制这个距离)。
				}
			}
		}
	}
}