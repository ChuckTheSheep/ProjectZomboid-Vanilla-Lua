--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

--[[
    Default panel for CraftLogic component.
--]]

require "Entity/ISUI/Components/ISBaseComponentPanel";

ISMashingLogicPanel = ISBaseComponentPanel:derive("ISMashingLogicPanel");

function ISMashingLogicPanel.CanCreatePanelFor(_player, _entity, _component, _componentUiScript)
    if _player and _entity and _component then
        return _component:getComponentType()==ComponentType.MashingLogic;
    end
end

--************************************************************************--
--** ISMashingLogicPanel:initialise
--**
--************************************************************************--

function ISMashingLogicPanel:initialise()
	ISBaseComponentPanel.initialise(self);
end

function ISMashingLogicPanel:createChildren()
    ISBaseComponentPanel.createChildren(self);

    self:createComponentHeader(self.xuiSkin, "S_WidgetComponentHeader_Std", false, nil, nil);

    if self.resourcesComponent and self.inputsGroupName then -- and self.resourceContainer then
        local column, row;
        self.tableLayout = ISXuiSkin.build(self.xuiSkin, "S_TableLayout_Main", ISTableLayout, 0, 0, 10, 10);
        self.tableLayout:addRowFill(nil);
        self.tableLayout:initialise();
        self.tableLayout:instantiate();
        self:addChild(self.tableLayout);

        local resources = ArrayList.new();

        --[[
            LEFT SIDE PANELS
        --]]

        -- Energy Inputs

        --[[
        resources = self.resourcesComponent:getResourcesFromGroup(self.inputsGroupName, resources, ResourceIO.Input, ResourceType.Energy);

        if resources:size()>0 then
            self.energyInputs = self:createEnergySlotPanel("S_EnergySlotPanel_Inputs");
            self.energyInputs:addResources(resources, nil, nil, nil);

            column = self.tableLayout:addColumn(nil);
            self.tableLayout:setElement(column:index(), 0, self.energyInputs);
        end
        --]]

        -- Fluid Inputs

        --resources = self.resourcesComponent:getResourcesFromGroup(self.inputsGroupName, resources, ResourceIO.Input, ResourceType.Fluid);
        local fluidBarrel = self.resourcesComponent:getResource(self.resourceFluidID);

        if fluidBarrel then
            self.fluidInputs = self:createFluidSlotPanel("S_FluidSlotPanel_Inputs");
            --self.fluidInputs:addResources(resourcesAux, "S_FluidSlot_Locked", nil, nil, nil);
            -- TODO resources need variable to define if player can manually edit
            self.fluidInputs:addResource(fluidBarrel, "S_FluidSlot_Editable", nil, nil, nil);

            column = self.tableLayout:addColumn(nil);
            self.tableLayout:setElement(column:index(), 0, self.fluidInputs);
        end

        --[[
            MIDDLE PANELS
        --]]

        local middleLayout = ISXuiSkin.build(self.xuiSkin, "S_TableLayout_Middle", ISTableLayout, 0, 0, 10, 10); --, columns, rows);
        middleLayout:addColumnFill(nil);
        middleLayout:initialise();
        middleLayout:instantiate();

        column = self.tableLayout:addColumnFill(nil);
        self.tableLayout:setElement(column:index(), 0, middleLayout);

        local addedPanels = false;

        -- Inputs

        if self.inputsGroupName then
            resources = self.resourcesComponent:getResourcesFromGroup(self.inputsGroupName, resources, ResourceIO.Input, ResourceType.Item);

            if resources:size()>0 then
                self.itemInputs = self:createItemSlotPanel("S_ItemSlotPanel_Inputs");
                self.itemInputs:addResources(resources, "S_ItemSlot_Input");

                row = middleLayout:addRowFill(nil);
                middleLayout:setElement(0, row:index(), self.itemInputs);
                addedPanels = true;
            end
        end

        if not addedPanels then
            --top filler to center middle panel
            middleLayout:addRowFill(nil);
        end

        -- Progress

        self.craftProgress = ISXuiSkin.build(self.xuiSkin, "S_WidgetCraftProgress_Std", ISWidgetCraftProgress, 0, 0, 10, 10, self.player, self.entity, self, nil);
        self.craftProgress.callbackTarget = self;
        self.craftProgress.onGetProgress = function(_self)
            return _self.component:getProgress();
        end
        self.craftProgress:initialise();
        self.craftProgress:instantiate();

        row = middleLayout:addRow(nil);
        middleLayout:setElement(0, row:index(), self.craftProgress);

        -- Craft Control

        --if self.component:getStartMode()==StartMode.Manual then
        self.craftControl = ISXuiSkin.build(self.xuiSkin, "S_WidgetCraftControl_Std", ISWidgetCraftControl,0, 0, 10, 10, self.player, self.entity, self.component, self, nil);
        self.craftControl.callbackTarget = self;
        self.craftControl.onGetIsStartEnabled = function(_self)
            return _self.component:canStart(_self.player);
        end
        self.craftControl.onStart = function(_self)
            local funcCanStart = function(_player, _entity, _component)
                --if not _component:getStartMode()==StartMode.Manual then
                --    return false;
                --end
                return _component:canStart(_player);
            end
            local funcStart = function(_player, _entity, _component)
                _component:start(_player);
            end
            ISEntityUI.GenericCraftStart( _self.player, _self.entity, _self.component, funcCanStart, funcStart);
        end
        self.craftControl:initialise();
        self.craftControl:instantiate();

        row = middleLayout:addRow(nil);
        middleLayout:setElement(0, row:index(), self.craftControl);
        --end

        -- Craft Control Debug

        if getDebug() and getDebugOptions():getBoolean("Entity.DebugUI") then
            self.craftControlDebug = ISXuiSkin.build(self.xuiSkin, "S_WidgetCraftDebug_Std", ISWidgetCraftDebug,0, 0, 10, 10, self.player, self.entity, self.component, self, nil);
            self.craftControlDebug.callbackTarget = self;
            self.craftControlDebug.onStartDebug = function(_self)
                if _self.component then
                    local monitor = _self.component:debugCanStart(_self.player);
                    if monitor then
                        ISCraftRecipeMonitor.OnOpenPanel(monitor);
                    else
                        print("No craft recipe monitor returned!");
                    end
                end
            end
            self.craftControlDebug:initialise();
            self.craftControlDebug:instantiate();

            row = middleLayout:addRow(nil);
            middleLayout:setElement(0, row:index(), self.craftControlDebug);
        end

        --addedPanels = false;
        -- Outputs

        --[[
        if self.outputsGroupName then
            resources = self.resourcesComponent:getResourcesFromGroup(self.outputsGroupName, resources, ResourceIO.Output, ResourceType.Item);

            if resources:size()>0 then
                self.itemOutputs = self:createItemSlotPanel("S_ItemSlotPanel_Outputs");
                self.itemOutputs:addResources(resources, "S_ItemSlot_Output");

                row = middleLayout:addRowFill(nil);
                middleLayout:setElement(0, row:index(), self.itemOutputs);
                addedPanels = true;
            end
        end
        --]]

        if not addedPanels then
            --bottom filler to center middle panel
            middleLayout:addRowFill(nil);
        end

        --[[
            RIGHT SIDE PANELS
        --]]

        --[[
        if self.outputsGroupName then
            -- Fluid Outputs

            resources = self.resourcesComponent:getResourcesFromGroup(self.outputsGroupName, resources, ResourceIO.Output, ResourceType.Fluid);

            if resources:size()>0 then
                self.fluidOutputs = self:createFluidSlotPanel("S_FluidSlotPanel_Outputs");
                --_styleFluidSlot, _styleBtnTransfer, _styleBtnClear, _styleBar
                -- TODO resources need variable to define if player can manually edit
                self.fluidOutputs:addResources(resources, "S_FluidSlot_Editable", nil, nil, nil);
                --self.fluidOutputs:addResources(resourcesAux, "S_FluidSlot_Locked", nil, nil, nil);

                column = self.tableLayout:addColumn(nil);
                self.tableLayout:setElement(column:index(), 0, self.fluidOutputs);
            end

            -- Energy Outputs

            resources = self.resourcesComponent:getResourcesFromGroup(self.outputsGroupName, resources, ResourceIO.Output, ResourceType.Energy);

            if resources:size()>0 then
                self.energyOutputs = self:createEnergySlotPanel("S_EnergySlotPanel_Outputs");
                self.energyOutputs:addResources(resources, nil, nil, nil);

                column = self.tableLayout:addColumn(nil);
                self.tableLayout:setElement(column:index(), 0, self.energyOutputs);
            end
        end
        --]]
    end
end

--handle is resource:size()==0
function ISMashingLogicPanel:createItemSlotPanel(_style)
    local panel = ISXuiSkin.build(self.xuiSkin, _style, ISItemSlotPanel, 0,0,20,20, self.player, self.entity, nil, nil);
    --panel.borderText = _title;
    panel:initialise();
    panel:instantiate();

    return panel;
end

function ISMashingLogicPanel:createFluidSlotPanel(_style)
    local panel = ISXuiSkin.build(self.xuiSkin, _style, ISFluidSlotPanel, 0,0,20,20, self.player, self.entity, nil);
    --panel.borderText = _title;
    panel:initialise();
    panel:instantiate();

    return panel;
end

function ISMashingLogicPanel:createEnergySlotPanel(_style)
    local panel = ISXuiSkin.build(self.xuiSkin, _style, ISEnergySlotPanel, 0,0,20,20, self.player, self.entity, nil);
    --panel.borderText = _title;
    panel:initialise();
    panel:instantiate();

    return panel;
end

function ISMashingLogicPanel:calculateLayout(_preferredWidth, _preferredHeight)
    local width = math.max(self.minimumWidth, _preferredWidth or 0);
    local height = math.max(self.minimumHeight, _preferredHeight or 0);

    local headerHeight = 0;
    if self.componentHeader then
        self.componentHeader:setX(0);
        self.componentHeader:setY(0);

        self.componentHeader:calculateLayout(0, 0);

        headerHeight = self.componentHeader:getHeight();

        width = math.max(width, self.componentHeader:getWidth());
    end

    --local x,y = 0,headerHeight;
    if self.tableLayout then
        self.tableLayout:setX(0);
        self.tableLayout:setY(headerHeight);
        self.tableLayout:calculateLayout(width, math.max(0, height-headerHeight));

        width = math.max(width, self.tableLayout:getWidth());
        height = math.max(height, self.tableLayout:getHeight()+headerHeight);

        if self.componentHeader then
            self.componentHeader:calculateLayout(width, 0);
        end
    end

    self:setWidth(width);
    self:setHeight(height);
end

function ISMashingLogicPanel:onResize()
    ISUIElement.onResize(self)
end

function ISMashingLogicPanel:prerender()
    ISBaseComponentPanel.prerender(self);
end

function ISMashingLogicPanel:render()
    ISBaseComponentPanel.render(self);

    if ISEntityUI.drawDebugLines or self.drawDebugLines then
        self:drawRectBorderStatic(0, 0, self.width, self.height, 1.0, 0, 1, 0);
    end
end

function ISMashingLogicPanel:update()
    ISBaseComponentPanel.update(self);
end


--************************************************************************--
--** ISMashingLogicPanel:new
--**
--************************************************************************--
function ISMashingLogicPanel:new(x, y, width, height, player, entity, component, componentUiStyle)
	local o = ISBaseComponentPanel:new(x, y, width, height, player, entity, component, componentUiStyle);
    setmetatable(o, self);
    self.__index = self;

    o.inputsGroupName = component:getInputsGroupName();
    o.resourceFluidID = component:getResourceFluidID();
    o.resourcesComponent = entity and entity:getComponent(ComponentType.Resources);

    return o;
end