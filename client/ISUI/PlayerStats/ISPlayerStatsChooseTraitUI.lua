--
-- Created by IntelliJ IDEA.
-- User: RJ
-- Date: 21/09/16
-- Time: 10:19
-- To change this template use File | Settings | File Templates.
--

--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "ISUI/ISPanel"

ISPlayerStatsChooseTraitUI = ISPanel:derive("ISPlayerStatsChooseTraitUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function ISPlayerStatsChooseTraitUI:initialise()
    ISPanel.initialise(self);
    self:create();
end


function ISPlayerStatsChooseTraitUI:setVisible(visible)
    --    self.parent:setVisible(visible);
    self.javaObject:setVisible(visible);
end

function ISPlayerStatsChooseTraitUI:render()
    self:drawText(getText("IGUI_PlayerStats_AddTraitTitle"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_PlayerStats_AddTraitTitle")) / 2), UI_BORDER_SPACING+1, 1,1,1,1, UIFont.Medium);
end

function ISPlayerStatsChooseTraitUI:create()
    for i=0,TraitFactory.getTraits():size()-1 do
        local trait = TraitFactory.getTraits():get(i);
        if not self.chr:getTraits():contains(trait:getType()) then
            if trait:getCost() >= 0 then
                table.insert(self.goodTraits, trait)
            else
                table.insert(self.badTraits, trait)
            end
        end
    end

    self.combo = ISComboBox:new(UI_BORDER_SPACING+1, FONT_HGT_MEDIUM+UI_BORDER_SPACING*2+1, self.width - (UI_BORDER_SPACING+1)*2, BUTTON_HGT, nil,nil);
    self.combo:initialise();
    self.goodTrait = {};
    self:addChild(self.combo);

    self.traitsSelector = ISTickBox:new(self.combo.x, self.combo.y + self.combo.height + UI_BORDER_SPACING, 100, BUTTON_HGT, "", self, ISPlayerStatsChooseTraitUI.onChangeList);
    self.traitsSelector:initialise();
    self.traitsSelector:instantiate();
    self.traitsSelector:setAnchorLeft(true);
    self.traitsSelector:setAnchorRight(false);
    self.traitsSelector:setAnchorTop(true);
    self.traitsSelector:setAnchorBottom(false);
    self.traitsSelector.selected[1] = true;
    self.traitsSelector:addOption("Good Trait");
    self:addChild(self.traitsSelector);

    self:populateComboList();

    local btnWid = 100

    self.ok = ISButton:new((self:getWidth() - UI_BORDER_SPACING) / 2 - btnWid, self.traitsSelector:getBottom() + UI_BORDER_SPACING, btnWid, BUTTON_HGT, getText("UI_Ok"), self, ISPlayerStatsChooseTraitUI.onOptionMouseDown);
    self.ok.internal = "OK";
    self.ok:initialise();
    self.ok:instantiate();
    self.ok.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.ok);

    self.cancel = ISButton:new((self:getWidth() + UI_BORDER_SPACING) / 2, self.ok:getY(), btnWid, BUTTON_HGT, getText("UI_Cancel"), self, ISPlayerStatsChooseTraitUI.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = {r=1, g=1, b=1, a=0.1};
    self:addChild(self.cancel);

    self:setHeight(self.cancel:getBottom() + UI_BORDER_SPACING+1)
end


function ISPlayerStatsChooseTraitUI:onChangeList()
    self:populateComboList();
end

function ISPlayerStatsChooseTraitUI:populateComboList()
    self.combo:clear();
    local list = self.badTraits;
    if self.traitsSelector.selected[1] then
        list = self.goodTraits;
    end
    local tooltipMap = {};
    for _,v in ipairs(list) do
        self.combo:addOption(v:getLabel());
        tooltipMap[v:getLabel()] = v:getDescription();
    end
    self.combo:setToolTipMap(tooltipMap);

    if self.traitsSelector.selected[1] then
        local hc = getCore():getGoodHighlitedColor()
        self.combo.textColor = {r=hc:getR(), g=hc:getG(), b=hc:getB(),a=0.9};
    else
        local hc = getCore():getBadHighlitedColor()
        self.combo.textColor = {r=hc:getR(), g=hc:getG(), b=hc:getB(),a=0.9};
    end
end

function ISPlayerStatsChooseTraitUI:onOptionMouseDown(button, x, y)
    if button.internal == "OK" then
        self:setVisible(false);
        self:removeFromUIManager();
        if self.onclick ~= nil then
            local list = self.badTraits;
            if self.traitsSelector.selected[1] then
                list = self.goodTraits;
            end
            self.onclick(self.target, button, list[self.combo.selected]);
        end
    end
    if button.internal == "CANCEL" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
end

function ISPlayerStatsChooseTraitUI:new(x, y, width, height, target, onclick, player)
    local o = {};
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.target = target;
    o.onclick = onclick;
    o.chr = player;
    o.comboList = {};
    o.zOffsetSmallFont = 25;
    o.goodTraits = {};
    o.badTraits = {};
    o.moveWithMouse = true;
    return o;
end
