--
-- Created by IntelliJ IDEA.
-- User: RJ
-- Date: 23/03/2017
-- Time: 11:18
-- To change this template use File | Settings | File Templates.
--


--***********************************************************
--**              	  ROBERT JOHNSON                       **
--***********************************************************

ISPlayerStatsManageInvUI = ISPanel:derive("ISPlayerStatsManageInvUI");
ISPlayerStatsManageInvUI.messages = {};

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function ISPlayerStatsManageInvUI.OnOpenPanel()
	if ISPlayerStatsManageInvUI.instance == nil then
		ISPlayerStatsManageInvUI:new(100, 100, 800, 800, getPlayer():getOnlineID(), getPlayer():getUsername())
		ISPlayerStatsManageInvUI.instance:initialise()
		ISPlayerStatsManageInvUI.instance:instantiate()
	end
	ISPlayerStatsManageInvUI.instance:addToUIManager()
	ISPlayerStatsManageInvUI.instance:setVisible(true)
	return ISPlayerStatsManageInvUI.instance;
end

function ISPlayerStatsManageInvUI.Close()
	ISPlayerStatsManageInvUI.instance:setVisible(false)
	ISPlayerStatsManageInvUI.instance:removeFromUIManager()
	ISPlayerStatsManageInvUI.instance = nil
end

--************************************************************************--
--** ISPlayerStatsManageInvUI:initialise
--**
--************************************************************************--

function ISPlayerStatsManageInvUI:initialise()
	ISPanel.initialise(self);
	local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
	local btnHgt2 = 18
	local padBottom = 10

	self.no = ISButton:new(10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_Cancel"), self, ISPlayerStatsManageInvUI.onClick);
	self.no.internal = "CANCEL";
	self.no.anchorTop = false
	self.no.anchorBottom = true
	self.no:initialise();
	self.no:instantiate();
	self.no.borderColor = self.borderColor;
	self:addChild(self.no);

	self.removeBtn = ISButton:new(self:getWidth() - 100 - 10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, "Remove Item", self, ISPlayerStatsManageInvUI.onClick);
	self.removeBtn.internal = "REMOVE";
	self.removeBtn.anchorTop = false
	self.removeBtn.anchorBottom = true
	self.removeBtn:initialise();
	self.removeBtn:instantiate();
	self.removeBtn.borderColor = self.borderColor;
	self.removeBtn:setWidthToTitle(100)
	self.removeBtn:setX(self.width - self.removeBtn.width - 10)
	self:addChild(self.removeBtn);
	if self.playerID == -1 then
		self.removeBtn:setVisible(false)
	end

	self.getItemBtn = ISButton:new(0, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, "Get Item", self, ISPlayerStatsManageInvUI.onClick);
	self.getItemBtn.internal = "GETITEM";
	self.getItemBtn.anchorTop = false
	self.getItemBtn.anchorBottom = true
	self.getItemBtn:initialise();
	self.getItemBtn:instantiate();
	self.getItemBtn.borderColor = self.borderColor;
	self.getItemBtn:setWidthToTitle(100)
	self.getItemBtn:setX(self.removeBtn.x - self.getItemBtn.width - 10)
	self:addChild(self.getItemBtn);
	if self.playerUsername == getPlayer():getUsername() then
		self.getItemBtn:setVisible(false);
	end
	if self.playerID == -1 then
		self.getItemBtn:setVisible(false)
	end

	self.addItemBtn = ISButton:new(0, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, "Add Item", self, ISPlayerStatsManageInvUI.onClick);
	self.addItemBtn.internal = "ADDITEM";
	self.addItemBtn.anchorTop = false
	self.addItemBtn.anchorBottom = true
	self.addItemBtn:initialise();
	self.addItemBtn:instantiate();
	self.addItemBtn.borderColor = self.borderColor;
	self.addItemBtn:setWidthToTitle(100)
	self.addItemBtn:setX(self.getItemBtn.x - self.addItemBtn.width - 10)
	self:addChild(self.addItemBtn);
	if self.playerUsername == getPlayer():getUsername() then
		self.addItemBtn:setVisible(false);
	end
	if self.playerID == -1 then
		self.addItemBtn:setVisible(false)
	end

	self.refreshBtn = ISButton:new(0, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, "Refresh", self, ISPlayerStatsManageInvUI.onClick);
	self.refreshBtn.internal = "REFRESH";
	self.refreshBtn.anchorTop = false
	self.refreshBtn.anchorBottom = true
	self.refreshBtn:initialise();
	self.refreshBtn:instantiate();
	self.refreshBtn.borderColor = self.borderColor;
	self.refreshBtn:setWidthToTitle(100)
	self.refreshBtn:setX(self.addItemBtn.x - self.refreshBtn.width - 10)
	self:addChild(self.refreshBtn);
	if self.playerID == -1 then
		self.refreshBtn:setVisible(false)
	end

	self.datas = ISScrollingListBox:new(10, 70, self.width - 20, self.height - 120);
	self.datas:initialise();
	self.datas:instantiate();
	self.datas.itemheight = FONT_HGT_SMALL + 2 * 2;
	self.datas.selected = 0;
	self.datas.joypadParent = self;
	self.datas.font = UIFont.NewSmall;
	self.datas.doDrawItem = self.drawDatas;
	self.datas.drawBorder = true;
	self.datas:addColumn("Name", 40);
	self.datas:addColumn("Count", 310);
	self.datas:addColumn("Type", 360);
	self.datas:addColumn("Variables", 440);
	self:addChild(self.datas);

--	self:populateList();
	self:requestDatas();
end

function ISPlayerStatsManageInvUI:requestDatas()
	sendRequestInventory(tonumber(self.playerID), tostring(self.playerUsername));
end

function ISPlayerStatsManageInvUI.ReceiveItems(itemtable)
	if ISPlayerStatsManageInvUI.instance == nil then return end
	ISPlayerStatsManageInvUI.instance.datas:clear();
	local items = {};
	local weapons = {};
	-- sort items, first basic items, then weapons
	for i,v in pairs(itemtable) do
		local item = getItem(tostring(v.fullType));
		if item then
			v.tex = getItemTex(v.fullType);
			v.name = getItemName(v.fullType);
			if v.cat == getText("IGUI_ItemCat_Drainable") then
				v.cat = "Drainable"
			else
				v.cat = getText("IGUI_ItemCat_" .. v.cat);
			end
			v.maxCondition = getItemConditionMax(v.fullType)
			if v.cat == getText("IGUI_ItemCat_Weapon") and not v.inInv and v.parrentId == -1 then
				table.insert(weapons, v);
			else
				table.insert(items, v);
			end
		end
	end
	for i,v in ipairs(weapons) do
		ISPlayerStatsManageInvUI.instance.datas:addItem(i, v);
	end
	for i,v in ipairs(items) do
		ISPlayerStatsManageInvUI.instance.datas:addItem(i, v);
	end
	ISPlayerStatsManageInvUI.instance.capacityWeight = (math.floor(itemtable.capacityWeight * 10.0))/10.0
	ISPlayerStatsManageInvUI.instance.maxWeight = itemtable.maxWeight
end

function ISPlayerStatsManageInvUI:populateList()
--	self.datas:clear();
--	for i=0,Faction.getFactions():size()-1 do
--		local fact = Faction.getFactions():get(i);
--		self.datas:addItem(fact:getName(), fact);
--	end
end

function ISPlayerStatsManageInvUI:drawDatas(y, item, alt)
	local a = 0.9;
	
	--    self.parent.selectedFaction = nil;
	self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

--	self:drawRect(190, y-1, 1, self.itemheight,1,self.borderColor.r, self.borderColor.g, self.borderColor.b);

	if self.selected == item.index then
		self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
		self.parent.removeBtn.enable = true;
		self.parent.selectedItem = item;
	end
--	if self.parent.selectedItem~= nil then
--		print(tostring(self.parent.selectedItem.item.itemId).." == "..tostring(item.item.parrentId));
--	end
	if (self.parent.selectedItem~= nil) and (tostring(self.parent.selectedItem.item.itemId) == tostring(item.item.parrentId)) then
		self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.5, 0.35, 0.15);
	end
	if (self.parent.selectedItem~= nil) and (tostring(self.parent.selectedItem.item.parrentId) == tostring(item.item.itemId)) then
		self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.35, 0.5, 0.15);
	end
	
	local column0Wid = 40
	local texSize = 16
	local texDY = (item.height - texSize) / 2
	if not item.item.inInv then
		self:drawTextureScaled(item.item.tex, (column0Wid - texSize) / 2, y + texDY, texSize, texSize, 1, 1, 1, 1)
		if item.item.isEquip then
			local texW = self.parent.equippedIcon:getWidthOrig()
			local texH = self.parent.equippedIcon:getHeightOrig()
			self:drawTexture(self.parent.equippedIcon, (column0Wid - texSize) / 2 + texSize - texW / 2, y + texDY + texSize - texH / 2, 1, 1, 1, 1)
		end
	else
		self:drawTextureScaled(item.item.tex, (column0Wid - texSize) / 2, y + texDY, texSize, texSize, 1, 1, 1, 1)
	end
	self:drawText(item.item.name, self.columns[1].size + 10, y + 2, 1, 1, 1, a, self.font);
	self:drawText(item.item.count, self.columns[2].size + 10, y + 2, 1, 1, 1, a, self.font);
	self:drawText(item.item.cat, self.columns[3].size + 10, y + 2, 1, 1, 1, a, self.font);
	local container = ""
	if item.item.hasParrent then
		container = "In container: "..item.item.container.." "
	end
	--self:drawText("container: " .. item.item.container, self.columns[4].size + 10, y + 2, 1, 1, 1, a, self.font);
	if item.item.cat == getText("IGUI_ItemCat_Weapon") then
		local condition = math.floor((item.item.var/item.item.maxCondition)*1000)/10.0
		self:drawText(container.."Condition: " .. condition .. "%", self.columns[4].size + 10, y + 2, 1, 1, 1, a, self.font);
	else
		self:drawText(container, self.columns[4].size + 10, y + 2, 1, 1, 1, a, self.font);
	end
	
	return y + self.itemheight;
end

function ISPlayerStatsManageInvUI:render()
	
end

function ISPlayerStatsManageInvUI:prerender()
	self.datas.doDrawItem = self.drawDatas -- to support reloading in lua debugger
	local z = 10;
	self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
	self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
	self:drawText(getText("IGUI_PlayerStats_ManageInventory", self.playerUsername), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_PlayerStats_ManageInventory", playerUsername)) / 2), z, 1,1,1,1, UIFont.Medium);
	local weightString = "Weight: " .. self.capacityWeight .. "/" .. self.maxWeight
	self:drawText(weightString, self.width - getTextManager():MeasureStringX(UIFont.Small, weightString) - 20, 20, 1,1,1,1, UIFont.Small)
end

function ISPlayerStatsManageInvUI:onClick(button)
	if button.internal == "CANCEL" then
		ISPlayerStatsManageInvUI.Close()
	end
	if self.selectedItem then
		if button.internal == "REMOVE" then
			InvMngRemoveItem(self.selectedItem.item.itemId, self.playerID, self.playerUsername);
			--self:removeSelectedItem();
			self:requestDatas();
		end
		if button.internal == "GETITEM" then
			if tonumber(self.selectedItem.item.count) > 1 then
				InvMngGetItem(0, self.selectedItem.item.fullType, self.playerID, self.playerUsername);
			else
				InvMngGetItem(self.selectedItem.item.itemId, nil, self.playerID, self.playerUsername);
			end
			--self:removeSelectedItem();
			self:requestDatas();
		end
	end
	if button.internal == "ADDITEM" then
		local modal = ISTextBox:new(self.x + 200, self.y + 200, 280, 180, getText("IGUI_PlayerStats_AddItem"), "", self, ISPlayerStatsManageInvUI.onAddItem);
		modal:initialise();
		modal:addToUIManager();
		modal.moveWithMouse = true;
	end
	if button.internal == "REFRESH" then
		self:requestDatas();
	end
end

function ISPlayerStatsManageInvUI:removeSelectedItem()
	if tonumber(self.selectedItem.item.count) > 1 then
		self.selectedItem.item.count = tonumber(self.selectedItem.item.count) - 1 .. "";
	else
		self.datas:removeItemByIndex(self.selectedItem.index);
	end
end

function ISPlayerStatsManageInvUI:onAddItem(button)
	if button.internal == "OK" then
		if button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
			SendCommandToServer("/additem \"" .. self.playerUsername .. "\" \"" .. luautils.trim(button.parent.entry:getText()) .. "\"")
			self:requestDatas();
		end
	end
end

--************************************************************************--
--** ISPlayerStatsManageInvUI:new
--**
--************************************************************************--
function ISPlayerStatsManageInvUI:new(x, y, width, height, playerID, playerUsername)
	local o = {}
	x = getCore():getScreenWidth() / 2 - (width / 2);
	y = getCore():getScreenHeight() / 2 - (height / 2);
	o = ISPanel:new(x, y, width, height);
	setmetatable(o, self)
	self.__index = self
	o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	o.backgroundColor = {r=0, g=0, b=0, a=0.8};
	o.listHeaderColor = {r=0.4, g=0.4, b=0.4, a=0.3};
	o.width = width;
	o.height = height;
	o.playerID = playerID;
	o.playerUsername = playerUsername;
	o.selectedItem = nil;
	o.moveWithMouse = true;
	o.equippedIcon = getTexture("media/ui/icon.png");
	o.capacityWeight = 0
	o.maxWeight = 0
	ISPlayerStatsManageInvUI.instance = o;
	return o;
end

Events.MngInvReceiveItems.Add(ISPlayerStatsManageInvUI.ReceiveItems)

