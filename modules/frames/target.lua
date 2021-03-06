--[[
    modules\frames\target.lua
    Styles, Scales and Repositions the Target Unit Frame.
]]
ImpUI_Target = ImpUI:NewModule('ImpUI_Target', 'AceEvent-3.0', 'AceHook-3.0');

-- Get Locale
local L = LibStub('AceLocale-3.0'):GetLocale('ImprovedBlizzardUI_Classic');

-- Local Variables
local dragFrame;

-- Local Functions
local UnitClassification = UnitClassification;

--[[
	When the ToT health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_Target:TargetofTargetHealthCheck(self)
    if (ImpUI.db.profile.targetOfTargetClassColours) then
        Helpers.ApplyClassColours(self.healthbar, self.healthbar.unit);
    end
end

--[[
	When the health bar changes in any way, reapply class colours.
	
    @ return void
]]
function ImpUI_Target:HealthBarChanged(bar)
    if (ImpUI.db.profile.targetClassColours and bar.unit == 'target') then
        Helpers.ApplyClassColours(bar, bar.unit);
    end
end

--[[
	Applies the actual styling.
	
    @ return void
]]
function ImpUI_Target:StyleFrame()
    if (ImpUI.db.profile.styleUnitFrames == false) then return; end

    local unitClassification = UnitClassification(TargetFrame.unit);

    -- Figure out what texture we need.
    local frameTexture;
    if ( unitClassification == 'worldboss' or unitClassification == 'elite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI_Classic\\media\\UI-TargetingFrame-Elite';
	elseif ( unitClassification == 'rareelite' ) then
		frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI_Classic\\media\\UI-TargetingFrame-Rare-Elite';
	elseif ( unitClassification == 'rare' ) then
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI_Classic\\media\\UI-TargetingFrame-Rare';
    else
        frameTexture = 'Interface\\Addons\\ImprovedBlizzardUI_Classic\\media\\UI-TargetingFrame';
	end

    -- Apply It
    TargetFrame.borderTexture:SetTexture(frameTexture);

    -- Update Health Bar Size
    TargetFrame.healthbar:SetHeight(29);
    TargetFrame.healthbar:SetPoint('TOPLEFT',7,-22);
    -- TargetFrame.healthbar.TextString:SetPoint('CENTER',-50,6);
    TargetFrame.deadText:SetPoint('CENTER',-50,6);
    TargetFrame.nameBackground:Hide();
    TargetFrame.Background:SetPoint('TOPLEFT',7,-22);
    TargetFrame.healthbar:SetWidth(119);

    -- Class Colours
    if (ImpUI.db.profile.targetClassColours) then
        Helpers.ApplyClassColours(TargetFrame.healthbar, TargetFrame.healthbar.unit);
    end

    TargetFrame.healthbar.lockColor = true;

    -- Buffs on Top.
    if (ImpUI.db.profile.targetBuffsOnTop) then
        TargetFrame.buffsOnTop = true;
    else
        TargetFrame.buffsOnTop = false;
    end

    -- Fonts
    local font = Helpers.get_styled_font(ImpUI.db.profile.primaryInterfaceFont);

    TargetFrameTextureFrameName:SetTextColor(font.r, font.g, font.b, font.a);

    TargetFrameTextureFrameName:SetFont(font.font, 11, font.flags);

    TargetFrameTextureFrameLevelText:SetFont(font.font, 10, font.flags);
    TargetFrameTextureFrameLevelText:SetTextColor(font.r, font.g, font.b, font.a);
    TargetFrameTextureFrameLevelText:ClearAllPoints();
    TargetFrameTextureFrameLevelText:SetPoint('RIGHT', -45, -16);

    if ( TargetFrame.totFrame ) then
        TargetFrameToTTextureFrameName:SetFont(font.font, 11, font.flags);
        TargetFrameToTTextureFrameName:SetTextColor(font.r, font.g, font.b, font.a);
    end
end

--[[
	Fires when the Player Logs In.
	
    @ return void
]]
function ImpUI_Target:PLAYER_LOGIN()
    ImpUI_Target:LoadPosition();
end

--[[
	Called when unlocking the UI.
]]
function ImpUI_Target:Unlock()
    dragFrame:Show();
end

--[[
	Called when locking the UI.
]]
function ImpUI_Target:Lock()
    local point, relativeTo, relativePoint, xOfs, yOfs = dragFrame:GetPoint();

    ImpUI.db.profile.targetFramePosition = Helpers.pack_position(point, relativeTo, relativePoint, xOfs, yOfs);

    dragFrame:Hide();
end

--[[
	Loads the position of the Target Frame from SavedVariables.
]]
function ImpUI_Target:LoadPosition()
    local pos = ImpUI.db.profile.targetFramePosition;
    local scale = ImpUI.db.profile.targetFrameScale;
    
    -- Set Drag Frame Position
    dragFrame:SetPoint(pos.point, pos.relativeTo, pos.relativePoint, pos.x, pos.y);

    -- Parent Target Frame to the Drag Frame.
    TargetFrame:SetMovable(true);
    TargetFrame:ClearAllPoints();
    TargetFrame:SetPoint('CENTER', dragFrame, 'CENTER', 15, -5);
    TargetFrame:SetScale(scale);
    TargetFrame:SetUserPlaced(true);
    TargetFrame:SetMovable(false);
end

--[[
	Fires when the module is Initialised.
	
    @ return void
]]
function ImpUI_Target:OnInitialize()
end

--[[
	Fires when the module is Enabled. Set up frames, events etc here.
	
    @ return void
]]
function ImpUI_Target:OnEnable()
    -- Create Drag Frame and load position.
    dragFrame = Helpers.create_drag_frame('ImpUI_Target_DragFrame', 205, 90, L['Target Frame']);

    ImpUI_Target:LoadPosition();

    ImpUI_Target:StyleFrame();

    -- Register Events
    self:RegisterEvent('PLAYER_LOGIN');

    -- Register Hooks
    self:SecureHook('TargetFrame_CheckDead', 'StyleFrame');
    self:SecureHook('TargetFrame_Update', 'StyleFrame');
    self:SecureHook('TargetFrame_CheckFaction', 'StyleFrame');
    self:SecureHook('TargetFrame_CheckClassification', 'StyleFrame');
    self:SecureHook('TargetofTarget_Update', 'StyleFrame');
    self:SecureHook('TargetofTargetHealthCheck', 'TargetofTargetHealthCheck');
    self:SecureHook('UnitFrameHealthBar_Update', 'HealthBarChanged');
    self:SecureHook('HealthBar_OnValueChanged', 'HealthBarChanged');
end

--[[
	Clean up behind ourselves if needed.
	
    @ return void
]]
function ImpUI_Target:OnDisable()
end