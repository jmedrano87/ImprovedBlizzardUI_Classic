--[[
    ImpBlizzardUI/config.lua
    Handles the various config settings within ImpBlizzardUI and builds the config panes.

    Notes: LoadConfig & ApplyChanges are called for all panels no matter which is in focus at that time.
           SetDefaults is called individually or globally depending on player input
]]

local _, ImpBlizz = ...;

local Config = {};

-- Load Fonts and set the sizes etc
local Font = "Interface\\Addons\\ImpBlizzardUI\\media\\impfont.ttf";
local CheckBoxFontSize = 14;
local CheckBoxOffset = -30;
local HeaderFontSize = 16;

-- Simply checks if any of the options have changed. This is basically a huge if statement
local function ConfigChanged()
    if(Conf_AutoRepair ~= Config.panel.autoRepair:GetChecked() or Conf_GuildBankRepair ~= Config.panel.guildRepair:GetChecked() or Conf_SellGreys ~= Config.panel.sellGreys:GetChecked() or Conf_AFKCamera ~= Config.panel.afkCamera:GetChecked() or Conf_ShowCoords ~= Config.panel.playerCoords:GetChecked() or Conf_ShowStats ~= Config.panel.systemStats:GetChecked() or Conf_MinifyGlobals ~= Config.panel.minifyStrings:GetChecked() or Conf_StyleChat ~= Config.panel.styleChat:GetChecked()) then
        return true;
    else
        return false;
    end
end

--[[
    Primary Window Config Stuff Begins
]]
-- Reset all options to the default settings
local function SetDefaults_Primary()
    Config.panel.autoRepair:SetChecked(true);
    Config.panel.guildRepair:SetChecked(true);
    Config.panel.sellGreys:SetChecked(true);
    Config.panel.afkCamera:SetChecked(true);
    Config.panel.playerCoords:SetChecked(true);
    Config.panel.systemStats:SetChecked(true);
    Config.panel.minifyStrings:SetChecked(true);
    Config.panel.styleChat:SetChecked(true);
end

-- Loads the already set config options for the Primary window
local function LoadConfig_Primary()
    Config.panel.autoRepair:SetChecked(Conf_AutoRepair);
    Config.panel.guildRepair:SetChecked(Conf_GuildBankRepair);
    Config.panel.sellGreys:SetChecked(Conf_SellGreys);
    Config.panel.afkCamera:SetChecked(Conf_AFKCamera);
    Config.panel.playerCoords:SetChecked(Conf_ShowCoords);
    Config.panel.systemStats:SetChecked(Conf_ShowStats);
    Config.panel.minifyStrings:SetChecked(Conf_MinifyGlobals);
    Config.panel.styleChat:SetChecked(Conf_StyleChat);
end

-- Applies any changes
local function ApplyChanges_Primary()
    if(ConfigChanged()) then
        Conf_AutoRepair = Config.panel.autoRepair:GetChecked();
        Conf_GuildBankRepair = Config.panel.guildRepair:GetChecked();
        Conf_SellGreys = Config.panel.sellGreys:GetChecked();
        Conf_AFKCamera = Config.panel.afkCamera:GetChecked();
        Conf_ShowCoords = Config.panel.playerCoords:GetChecked();
        Conf_ShowStats = Config.panel.systemStats:GetChecked();
        Conf_MinifyGlobals = Config.panel.minifyStrings:GetChecked();
        Conf_StyleChat = Config.panel.styleChat:GetChecked();
        ReloadUI();
    end
end

-- Checks to see if any of the values are nil. If they are it must be a first load. Set to defaults.
local function CheckFirstLoad()
    if (Conf_AutoRepair == nil) then Conf_AutoRepair = true end
    if (Conf_GuildBankRepair == nil) then Conf_GuildBankRepair = true end
    if (Conf_SellGreys == nil) then Conf_SellGreys = true end
    if (Conf_AFKCamera == nil) then Conf_AFKCamera = true end
    if (Conf_ShowCoords == nil) then Conf_ShowCoords = true end
    if (Conf_ShowStats == nil) then Conf_ShowStats = true end
    if (Conf_MinifyGlobals == nil) then Conf_MinifyGlobals = true end
    if (Conf_StyleChat == nil) then Conf_StyleChat = true end
end

-- Event Handler, Only used for detecting when the addon has finished initialising and trigger config loading
local function HandleEvents(self, event, ...)
    if(event == "ADDON_LOADED" and ... == "ImpBlizzardUI") then
        CheckFirstLoad();
        LoadConfig_Primary();
    end
end

-- Builds the Primary (Misc Settings) Config Panel - Parent to all other panels
local function BuildWindow_Primary()
    Config.panel = CreateFrame("Frame", "ImpBlizzardUI_Misc", UIParent);
    Config.panel.name = "Improved Blizzard UI";
    Config.panel.okay = ApplyChanges_Primary;
    Config.panel.cancel = LoadConfig_Primary;
    Config.panel.default = SetDefaults_Primary;

    -- Register the event handler and addon loaded event
    Config.panel:SetScript("OnEvent", HandleEvents);
    Config.panel:RegisterEvent("ADDON_LOADED");

    -- Title
    Config.panel.titleText = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.titleText:SetFont(Font, 18, "OUTLINE");
    Config.panel.titleText:SetPoint("TOPLEFT", 160, -10);
    Config.panel.titleText:SetText("|cffffff00 Improved Blizzard UI - v"..GetAddOnMetadata("ImpBlizzardUI", "Version"));

    --[[
        Misc Config Begins
    ]]
    -- Misc Header
    Config.panel.miscHeader = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.miscHeader:SetFont(Font, HeaderFontSize, "OUTLINE");
    Config.panel.miscHeader:SetPoint( "TOPLEFT", 15, -50 );
    Config.panel.miscHeader:SetText("|cffffff00 - "..ImpBlizz["Miscellaneous"].." - ");

    -- Auto Repair Checkbox
    Config.panel.autoRepair = CreateFrame("CheckButton", "RepairCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.autoRepair:ClearAllPoints();
    Config.panel.autoRepair:SetPoint("TOPLEFT", 15, -80);
    _G[Config.panel.autoRepair:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.autoRepair:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Auto Repair"]);

    -- Guild Bank Repair Checkbox
    Config.panel.guildRepair = CreateFrame("CheckButton", "GuildRepairCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.guildRepair:ClearAllPoints();
    Config.panel.guildRepair:SetPoint("TOPLEFT", 15, -110);
    _G[Config.panel.guildRepair:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.guildRepair:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Use Guild Bank For Repairs"]);

    -- Sell Greys Checkbox
    Config.panel.sellGreys = CreateFrame("CheckButton", "SellGreysCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.sellGreys:ClearAllPoints();
    Config.panel.sellGreys:SetPoint("TOPLEFT", 15, -140);
    _G[Config.panel.sellGreys:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.sellGreys:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Auto Sell Trash"]);

    -- AFKCamera Spin Checkbox
    Config.panel.afkCamera = CreateFrame("CheckButton", "AFKCameraCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.afkCamera:ClearAllPoints();
    Config.panel.afkCamera:SetPoint("TOPLEFT", 15, -170);
    _G[Config.panel.afkCamera:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.afkCamera:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["AFK Mode"]);
    --[[
        Misc Config Ends
    ]]

    --[[
        User Interface Config Begins
    ]]
    -- Misc Header
    Config.panel.miscHeader = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.miscHeader:SetFont(Font, HeaderFontSize, "OUTLINE");
    Config.panel.miscHeader:SetPoint( "TOPLEFT", 15, -220 );
    Config.panel.miscHeader:SetText("|cffffff00 - "..ImpBlizz["User Interface"].." - ");

    -- Player Co-ordinates Checkbox
    Config.panel.playerCoords = CreateFrame("CheckButton", "CoordsCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.playerCoords:ClearAllPoints();
    Config.panel.playerCoords:SetPoint("TOPLEFT", 15, -250);
    _G[Config.panel.playerCoords:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.playerCoords:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Display Player Co-Ordinates"]);

    -- Performance Counter
    Config.panel.systemStats = CreateFrame("CheckButton", "StatsCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.systemStats:ClearAllPoints();
    Config.panel.systemStats:SetPoint("TOPLEFT", 15, -280);
    _G[Config.panel.systemStats:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.systemStats:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Display System Statistics"]);
    --[[
        User Interface Config Ends
    ]]

    --[[
        Chat Config Begins
    ]]
    -- Chat Header
    Config.panel.chatHeader = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.chatHeader:SetFont(Font, HeaderFontSize, "OUTLINE");
    Config.panel.chatHeader:SetPoint( "TOPLEFT", 400, -50 );
    Config.panel.chatHeader:SetText("|cffffff00 - "..ImpBlizz["Chat"].." - ");

    -- Minify Blizzard Strings Checkbox
    Config.panel.minifyStrings = CreateFrame("CheckButton", "MinifyCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.minifyStrings:ClearAllPoints();
    Config.panel.minifyStrings:SetPoint("TOPLEFT", 330, -80);
    _G[Config.panel.minifyStrings:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.minifyStrings:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Minify Blizzard Strings"]);

    -- Style Chat Checkbox
    Config.panel.styleChat = CreateFrame("CheckButton", "StyleChatCheckBox", Config.panel, "UICheckButtonTemplate");
    Config.panel.styleChat:ClearAllPoints();
    Config.panel.styleChat:SetPoint("TOPLEFT", 330, -110);
    _G[Config.panel.styleChat:GetName().."Text"]:SetFont(Font, CheckBoxFontSize, "OUTLINE");
    _G[Config.panel.styleChat:GetName().."Text"]:SetText("|cffFFFFFF - "..ImpBlizz["Style Chat"]);
    --[[
        Chat Config Ends
    ]]

    --[[
        Action Bar Config Begins
    ]]
    -- Action Bars Header
    Config.panel.actionBarsHeader = Config.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    Config.panel.actionBarsHeader:SetFont(Font, HeaderFontSize, "OUTLINE");
    Config.panel.actionBarsHeader:SetPoint( "TOPLEFT", 375, -220 );
    Config.panel.actionBarsHeader:SetText("|cffffff00 - "..ImpBlizz["Action Bars"].." - ");
    --[[
        Action Bar Config Ends
    ]]
end
--[[
    Primary Window Config Stuff Ends
]]

-- Initialise the Config System
local function Init()
    BuildWindow_Primary();
end

-- End of File, Call Init and then add the config to the Blizzard Interface Options window
Init();
InterfaceOptions_AddCategory(Config.panel);
