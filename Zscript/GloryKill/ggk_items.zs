// ggk_items.zs - 定义了荣耀击杀MOD相关的物品和效果。

class ChainsawCooldownTimer: Inventory
{
	int cooldown;

	override void DoEffect()
	{
		if(cooldown>0){cooldown--; return;}	
	}

	bool isReady()
	{
		return cooldown <= 0;
	}

	void resetCooldown(){
		cooldown = sv_ggs_cooldown*60; // 重置冷却时间
	}
}

// ObjectMover: 一个Inventory物品，用于将持有它的Actor (Owner) 移动到目标Actor (to) 的附近。
class ObjectMover : Inventory
{
	Actor to; // 移动的目标Actor (通常是玩家)。
	int dist; // 当Owner与to的距离小于等于此值时，移动停止。
	
	// 覆写 DoEffect 方法，该方法在物品存在于Actor身上时每帧调用。
	override void DoEffect()
	{
		if(!Owner) return; // 如果物品没有所有者 (Owner)，则不执行。
		
		double spd = 20.; // 移动速度。
		// 计算从Owner到to的向量差 (delta)。
		vector3 delta = ( to.pos.x - Owner.pos.x, to.pos.y - Owner.pos.y, to.pos.z - Owner.pos.z );
		// 计算Owner指向to的水平角度。
		double angleto = Owner.AngleTo(to);
		// 计算Owner指向to的垂直角度 (俯仰角)。
		double pitchto = VectorAngle( sqrt(delta.y * delta.y + delta.x * delta.x), delta.z );
		
		// 让目标 'to' (玩家) 调整其视角以朝向 'Owner' (被拉过来的敌人)。
		// A_SetPitch 使玩家的垂直视角对准敌人。
		to.A_SetPitch(pitchto,SPF_INTERPOLATE); // SPF_INTERPOLATE 使变化平滑。
		// A_SetAngle 使玩家的水平视角对准敌人 (angleto 是 Owner 指向 to 的角度，+180度使其反向，即 to 指向 Owner)。
		to.A_SetAngle(angleto+180,SPF_INTERPOLATE); 

		// 如果Owner与to的距离大于设定的dist值。
		if (to.Distance3D(Owner) > dist)
		{
			// 计算Owner在指向to的方向上的位移向量。
			vector3 neworigin = Owner.Vec3Offset(cos(angleto) * spd,  sin(angleto) * spd, sin(pitchto) * spd);
			// 设置Owner的新位置，true表示进行碰撞检测。
			Owner.SetOrigin(neworigin,true);
		}
		else // 如果距离已足够近。
		{
			RemoveInventory(self); // 从Owner身上移除此ObjectMover物品，停止移动。
		}
		super.DoEffect(); // 调用父类的DoEffect。
	}
}

// ShadedActor: 一个Inventory物品，用于在另一个Actor (act) 身上显示一个着色（通常是高亮）的视觉效果。
class ShadedActor : Inventory
{
	Actor act; // 指向需要显示着色效果的目标Actor。
	
	Default
	{
		+NOINTERACTION // 此Actor不可交互。
	}
	// 覆写 BeginPlay 方法，在Actor生成时调用。
	override void BeginPlay()
	{
		A_SetRenderStyle(1.0,STYLE_Shaded); // 设置渲染风格为 STYLE_Shaded，这允许使用 SetShade 来改变颜色。
		Color gloryshade = Color(242,60,14); // 定义荣耀击杀的着色颜色 (橙红色)。
		SetShade(gloryshade); // 应用该颜色。
		super.BeginPlay(); // 调用父类的BeginPlay。
	}
	// 覆写 Tick 方法，每帧调用。
	override void Tick(void)
	{
		if(!act || act.health <= 0) GoAwayAndDie(); // 如果目标Actor不存在或已死亡，则销毁自身。
		if(act) // 如果目标Actor有效。
		{
			// 同步自身的尺寸、缩放、精灵、帧和角度与目标Actor一致。
			if(radius != act.radius || height != act.height) A_SetSize(act.radius, act.height);
			if(scale.x != act.scale.x || scale.y != act.scale.y) A_SetScale(act.scale.x,act.scale.y);
			Sprite = act.sprite; // 设置精灵ID。
			frame = act.frame; // 设置当前帧。
			angle = act.angle; // 设置角度。
			// 计算校正后的位置，使其稍微偏离目标Actor的位置 (沿着目标Actor朝向偏移5个单位)。
			vector3 correctedpos = (act.pos.x+cos(act.angle)*5,act.pos.y+sin(act.angle)*5,act.pos.z);
			SetOrigin(correctedpos,true); // 设置自身位置。
			Spawn("ShadedActor_Light",act.pos); // 在目标Actor的位置生成一个 ShadedActor_Light 粒子效果。
		}
		super.Tick(); // 调用父类的Tick。
	}
}

// ShadedActor_Light: 一个简单的Actor，可能用于配合ShadedActor产生一些光效或粒子。
class ShadedActor_Light : Actor
{
	Default
	{
		+NOINTERACTION // 不可交互。
		+MOVEWITHSECTOR // 随扇区移动 (如果扇区移动的话)。
	}
	States
	{
		Spawn: // 生成状态
			TNT1 A 1; // 显示一个透明的精灵 (TNT1 A) 持续1帧。
		SpawnDie: // 死亡状态 (或者紧接着生成后)
			TNT1 A 1; // 再显示1帧。
		stop; // 停止，Actor会自动移除。
	}
}

// IStagger: 一个Inventory物品，代表敌人进入的硬直状态。
class IStagger : Inventory
{
	int ptics; // 存储Owner (硬直的敌人) 在进入硬直前的原始tics值。
	int livetics; // 此IStagger物品已激活的帧数。
	ShadedActor ashader; // 指向用于显示硬直视觉效果的ShadedActor实例。
	
    Default
    {
        Inventory.MaxAmount 1; // 敌人身上最多只能有一个IStagger物品。
    }
	
	// 切换硬直着色效果的显示/隐藏。
	void ToggleShade()
	{
		if(!Owner) return; // 如果没有所有者，则返回。
		if(!ashader) // 如果当前没有着色效果实例。
		{
			// 生成一个新的ShadedActor在Owner的位置，并将其act指向Owner。
			ashader = ShadedActor(Spawn("ShadedActor",Owner.pos));
			ashader.act = Owner;
		} 
		else if(ashader) // 如果已有著色效果实例。
		{
			ashader.GoAwayAndDie(); // 销毁当前的着色效果。
			ashader = null; // 清除引用。
		}
	}

    // 覆写 DoEffect 方法。
    override void DoEffect()
    {
		if(!Owner || Owner.Health <= 0) // 如果Owner不存在或已死亡。
		{
			DepleteOrDestroy(); // 清理并销毁此IStagger物品。
			return;
		}

		if(!ptics) ptics = Owner.tics; // 如果尚未存储Owner的原始tics，则存储它。
		Owner.tics = -1; // 将Owner的tics设置为-1，通常这会使Actor的AI和动画暂停 (冻结)。
		
		if(!livetics) // 如果是此物品激活的第一帧 (livetics为0)。
		{
			ToggleShade(); // 开启着色效果。
			Owner.bInvulnerable = true; // 使Owner暂时无敌。
		}
		
		if( livetics > 2) Owner.bInvulnerable = false; // 在激活2帧后，解除Owner的无敌状态。
		// 当硬直持续时间达到 sv_staggerlength 的60%后，并且当前游戏时间 (level.maptime) 是10的倍数时，
		// 切换一次着色效果 (实现闪烁提示硬直即将结束)。
		if( livetics >= sv_staggerlength*0.6 && !(level.maptime%10) ) ToggleShade(); 
		livetics ++; // 增加已激活帧数。
		
		if(livetics > sv_staggerlength) DepleteOrDestroy(); // 如果激活时间超过设定的硬直总时长 (sv_staggerlength)，则清理并销毁。
        super.DoEffect(); // 调用父类的DoEffect。
    }
    
    // 覆写 DepleteOrDestroy 方法，用于在物品被移除或销毁前进行清理。
    override void DepleteOrDestroy()
    {
		if(ashader) ashader.GoAwayAndDie(); // 如果存在着色效果实例，销毁它。
        if(Owner) // 如果Owner有效。
        {
			// 为Owner回复少量生命值。计算方式为：当前生命值 + (1 - (当前生命值 * sv_staggerhealth)) / 2。
			// sv_staggerhealth 是进入硬直的生命阈值比例。这个公式的目的是在硬直结束后给怪物一点点血量，避免刚恢复就被秒。
			if(Owner.health > 0) Owner.A_SetHealth(Owner.health + (1.0-(Owner.health*sv_staggerhealth))/2 );
            Owner.tics = ptics; // 恢复Owner的原始tics值，使其行为恢复正常。
            Owner.RemoveInventory(self); // 从Owner身上移除此IStagger物品。
        }
    }
}