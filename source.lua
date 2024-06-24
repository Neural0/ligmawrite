local generate_guid
generate_guid = function()
  return game:GetService("HttpService"):GenerateGUID(false)
end

local library
do
  local _class_0
  local window
  local _base_0 = {
    new_window = function(self, title, position, size)
      if title == nil then
        title = "ars.red"
      end
      if position == nil then
        position = UDim2.new(0.5, -250, 0.5, -300)
      end
      if size == nil then
        size = UDim2.new(0, 500, 0, 600)
      end
      if (getgenv().window) then
        getgenv().window:destroy()
      end
      getgenv().window = window(title, position, size)
      return getgenv().window
    end,
    apply_settings = function(self, tab)
      local menu_group = tab:new_group("Menu", false)
      local config_group = tab:new_group("Config", true)
      menu_group:new_label({
        text = "Menu Key"
      }):add_keybind("menu_key", {
        default = Enum.KeyCode.End,
        mode = "Toggle",
        state = true,
        ignore = true,
        callback = function(state)
          getgenv().window.window.Enabled = state
        end
      })
      menu_group:new_button({
        text = "Copy JobId",
        callback = function()
          return setclipboard("Roblox.GameLauncher.joinGameInstance(" .. tostring(game.PlaceId) .. ", \"" .. tostring(game.JobId) .. "\")")
        end
      })
      menu_group:new_button({
        text = "Unload",
        callback = function()
          getgenv().window:destroy()
          getgenv().library = nil
          getgenv().window = nil
        end
      })
      config_group:new_textbox("config_name", {
        text = "Config Name",
        default = "",
        ignore = true
      })
      config_group:new_button({
        text = "Save",
        callback = function()
          local config_name = "ars/" .. tostring(getgenv().window.flags["config_name"]) .. ".json"
          if (not isfolder("ars")) then
            makefolder("ars")
          end
          local fixed_config = { }
          for key, value in next,getgenv().window.flags do
            if (not getgenv().window.ignore[key]) then
              local fixed_value = value
              if (typeof(value) == "table" and value.color) then
                fixed_value = {
                  color = value.color:ToHex(),
                  transparency = value.transparency
                }
              end
              fixed_config[key] = fixed_value
            end
          end
          return writefile(config_name, game:GetService("HttpService"):JSONEncode(fixed_config))
        end
      })
      return config_group:new_button({
        text = "Load",
        callback = function()
          local config_name = "ars/" .. tostring(getgenv().window.flags["config_name"]) .. ".json"
          if (not isfolder("ars")) then
            makefolder("ars")
          end
          if (isfile(config_name)) then
            for flag, value in next,game:GetService("HttpService"):JSONDecode(readfile(config_name)) do
              if (getgenv().window.options[flag] and not getgenv().window.ignore[flag]) then
                local fixed_value = value
                if (typeof(value) == "table" and value.color) then
                  fixed_value = {
                    color = Color3.fromHex(value.color),
                    transparency = value.transparency
                  }
                end
                getgenv().window.options[flag]:set_value(fixed_value)
              end
            end
          end
        end
      })
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "library"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  do
    local _class_1
    local _base_1 = {
      update = function(self)
        self.background_objects[1].Size = self.size
        self.background_objects[1].Position = self.position
        self.background_objects[2].Size = self.size - UDim2.new(0, 2, 0, 2)
        self.background_objects[2].Position = self.position + UDim2.new(0, 1, 0, 1)
        self.background_objects[3].Size = self.size - UDim2.new(0, 4, 0, 4)
        self.background_objects[3].Position = self.position + UDim2.new(0, 2, 0, 2)
      end,
      new_tab = function(self, name)
        if name == nil then
          name = ""
        end
        if not (self.active_tab) then
          self.active_tab = #self.tab_objects + 1
        end
        if self.tabs[name] then
          return self.tabs[name]
        end
        self.tab_objects[#self.tab_objects + 1] = self:add_object("TextButton", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          TextColor3 = Color3.fromRGB(255, 255, 255),
          TextSize = 12,
          Text = name,
          Font = Enum.Font.GothamSemibold,
          Size = UDim2.new(0, 100, 0, 18),
          Parent = self.tab_bar_objects[2],
          ZIndex = 8
        })
        local current_tab_index = #self.tab_objects
        local mouse_button_click
        mouse_button_click = function()
          return self:set_active_tab(current_tab_index)
        end
        self.connections[#self.connections + 1] = self.tab_objects[current_tab_index].MouseButton1Click:Connect(mouse_button_click)
        self.tab_groups[current_tab_index] = self:add_object("Frame", {
          Name = generate_guid(),
          BackgroundColor3 = Color3.fromRGB(12, 12, 12),
          BorderSizePixel = 0,
          Size = UDim2.new(1, 0, 1, 0),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.group_objects[1],
          Visible = self.active_tab == current_tab_index,
          ZIndex = 9
        })
        local distance_per_column = self.tab_bar_objects[2].AbsoluteSize.X / current_tab_index
        for idx, tab in next,self.tab_objects do
          local column_center = distance_per_column * idx - distance_per_column
          tab.Position = UDim2.new(0, column_center, 0, 0)
          tab.Size = UDim2.new(0, distance_per_column, 0, 18)
          if idx == self.active_tab then
            tab.TextColor3 = Color3.fromRGB(255, 0, 0)
          end
        end
        local tab
        do
          local _class_2
          local _base_2 = {
            new_group = function(self, name, right)
              if right == nil then
                right = false
              end
              local current_group = right and self.right_group_objects or self.left_group_objects
              local current_group_index = #current_group + 1
              current_group[current_group_index] = self.parent:add_object("Frame", {
                Name = generate_guid(),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BorderSizePixel = 1,
                BorderColor3 = Color3.fromRGB(30, 30, 30),
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Parent = right and self.right_group or self.left_group,
                AutomaticSize = Enum.AutomaticSize.XY,
                ClipsDescendants = true,
                ZIndex = 11
              })
              self.parent:add_object("TextLabel", {
                Name = generate_guid(),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Position = UDim2.new(0, 0, 0, 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Text = name,
                Font = Enum.Font.GothamSemibold,
                Parent = current_group[current_group_index],
                ZIndex = 12
              })
              current_group[current_group_index + 1] = self.parent:add_object("Frame", {
                Name = generate_guid(),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 18),
                Parent = current_group[current_group_index],
                AutomaticSize = Enum.AutomaticSize.XY,
                ClipsDescendants = true,
                ZIndex = 12
              })
              current_group[current_group_index + 2] = self.parent:add_object("UIListLayout", {
                Name = generate_guid(),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 4),
                Parent = current_group[current_group_index + 1]
              })
              local group
              do
                local _class_3
                local item
                local _base_3 = {
                  new_checkbox = function(self, flag, options)
                    if options == nil then
                      options = { }
                    end
                    local checkbox
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = {
                        set_value = function(self, value)
                          if value == nil then
                            value = false
                          end
                          self.window.flags[self.flag] = value
                          self.check.Visible = value
                          return options.callback(value)
                        end
                      }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, flag, options)
                          if options == nil then
                            options = { }
                          end
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          self.flag = flag
                          options.callback = options.callback or function() end
                          self.window.flags[flag] = options.default or false
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 18),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            AutomaticSize = Enum.AutomaticSize.XY,
                            ClipsDescendants = true,
                            ZIndex = 13
                          })
                          self.window:add_object("TextLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, -65, 0, 18),
                            Position = UDim2.new(0, 25, 0, 0),
                            TextColor3 = options.unsafe and Color3.fromRGB(182, 182, 101) or Color3.fromRGB(255, 255, 255),
                            TextSize = 12,
                            Text = options.text,
                            Font = Enum.Font.Gotham,
                            Parent = self.group_objects[#self.group_objects],
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 14
                          })
                          local button = self.window:add_object("TextButton", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            BorderSizePixel = 1,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(0, 3, 0, 1),
                            Text = "",
                            Parent = self.group_objects[#self.group_objects],
                            AutoButtonColor = false,
                            ZIndex = 14
                          })
                          self.check = self.window:add_object("ImageLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(0, 0, 0, 0),
                            ImageColor3 = Color3.fromRGB(255, 0, 0),
                            ScaleType = Enum.ScaleType.Fit,
                            Visible = self.window.flags[flag],
                            Parent = button,
                            ZIndex = 15
                          })
                          mouse_button_click = function()
                            self.window.flags[flag] = not self.window.flags[flag]
                            self.check.Visible = self.window.flags[flag]
                            return options.callback(self.window.flags[flag])
                          end
                          self.window.connections[#self.window.connections + 1] = button.MouseButton1Click:Connect(mouse_button_click)
                        end,
                        __base = _base_4,
                        __name = "checkbox",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      checkbox = _class_4
                    end
                    self.parent.parent.options[flag] = checkbox(self, flag, options)
                    if (options.ignore) then
                      self.parent.parent.ignore[flag] = true
                    end
                    return self.parent.parent.options[flag]
                  end,
                  new_list = function(self, flag, options)
                    if options == nil then
                      options = { }
                    end
                    local list
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = {
                        set_values = function(self, values)
                          if values == nil then
                            values = { }
                          end
                          self.values = values
                          if self.window.drop_flag == self.flag then
                            for _, object in next,self.window.drop_container:GetChildren() do
                              if object:IsA("TextButton") then
                                object:Destroy()
                              end
                            end
                            local _list_0 = self.values
                            for _index_0 = 1, #_list_0 do
                              local value = _list_0[_index_0]
                              local is_active = options.multi and table.find(self.window.flags[flag], value) or self.window.flags[flag] == value
                              local drop = self.window:add_object("TextButton", {
                                Name = generate_guid(),
                                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                                BackgroundTransparency = 0,
                                BorderSizePixel = 1,
                                BorderColor3 = Color3.fromRGB(30, 30, 30),
                                Size = UDim2.new(1, 1, 0, 20),
                                Position = UDim2.new(0, 0, 0, 0),
                                Text = tostring(value),
                                Parent = self.window.drop_container,
                                AutoButtonColor = false,
                                Font = Enum.Font.Gotham,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                TextColor3 = is_active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255),
                                Visible = true,
                                ZIndex = 10000
                              })
                              mouse_button_click = function()
                                self.window.flags[flag] = (function()
                                  if options.multi then
                                    if table.find(self.window.flags[flag], value) then
                                      table.remove(self.window.flags[flag], table.find(self.window.flags[flag], value))
                                    else
                                      table.insert(self.window.flags[flag], value)
                                    end
                                    return self.window.flags[flag]
                                  else
                                    return value
                                  end
                                end)()
                                for _, object in next,self.window.drop_container:GetChildren() do
                                  if object:IsA("TextButton") then
                                    is_active = options.multi and table.find(self.window.flags[flag], object.Text) or self.window.flags[flag] == object.Text
                                    object.TextColor3 = is_active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                                    if not options.multi then
                                      object.Visible = false
                                    end
                                  end
                                end
                                self.button.Text = (function()
                                  local buffer = ""
                                  if options.multi then
                                    local _list_1 = self.window.flags[flag]
                                    for _index_1 = 1, #_list_1 do
                                      local value = _list_1[_index_1]
                                      buffer = tostring(buffer) .. " " .. tostring(value) .. ","
                                    end
                                  else
                                    buffer = tostring(self.window.flags[flag])
                                  end
                                  return buffer
                                end)()
                                if not options.multi then
                                  self.window.drop_container.Visible = false
                                  self.arrow.Rotation = -90
                                end
                                return options.callback(self.window.flags[flag])
                              end
                              self.window.connections[#self.window.connections + 1] = drop.MouseButton1Click:Connect(mouse_button_click)
                            end
                          end
                        end,
                        set_value = function(self, value)
                          if value == nil then
                            value = { }
                          end
                          self.window.flags[self.flag] = value
                          if self.window.drop_flag == self.flag then
                            for _, object in next,self.window.drop_container:GetChildren() do
                              if object:IsA("TextButton") then
                                local is_active = options.multi and table.find(self.window.flags[self.flag], object.Text) or self.window.flags[self.flag] == object.Text
                                object.TextColor3 = is_active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                                if not options.multi then
                                  object.Visible = false
                                end
                              end
                            end
                            self.button.Text = (function()
                              local buffer = ""
                              if options.multi then
                                local _list_0 = self.window.flags[self.flag]
                                for _index_0 = 1, #_list_0 do
                                  local value = _list_0[_index_0]
                                  buffer = tostring(buffer) .. " " .. tostring(value) .. ","
                                end
                              else
                                buffer = tostring(self.window.flags[self.flag])
                              end
                              return buffer
                            end)()
                            return options.callback(self.window.flags[self.flag])
                          end
                        end
                      }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, flag, options)
                          if options == nil then
                            options = { }
                          end
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          self.flag = flag
                          self.values = options.values or { }
                          options.callback = options.callback or function() end
                          self.window.flags[flag] = options.default or { }
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 39),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            AutomaticSize = Enum.AutomaticSize.XY,
                            ClipsDescendants = true,
                            ZIndex = 13
                          })
                          self.window:add_object("TextLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, -65, 0, 16),
                            Position = UDim2.new(0, 2, 0, 0),
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 12,
                            Text = options.text,
                            Font = Enum.Font.Gotham,
                            Parent = self.group_objects[#self.group_objects],
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 14
                          })
                          self.button = self.window:add_object("TextButton", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            BorderSizePixel = 1,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, -65, 0, 20),
                            Position = UDim2.new(0, 3, 0, 16),
                            Text = tostring((function()
                              local buffer = ""
                              if options.multi then
                                local _list_0 = options.default
                                for _index_0 = 1, #_list_0 do
                                  local value = _list_0[_index_0]
                                  buffer = tostring(buffer) .. " " .. tostring(value) .. ","
                                end
                              else
                                buffer = tostring(options.default)
                              end
                              return buffer
                            end)()) or " None",
                            Parent = self.group_objects[#self.group_objects],
                            AutoButtonColor = false,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            ZIndex = 14
                          })
                          self.arrow = self.window:add_object("ImageLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 10, 0, 10),
                            Position = UDim2.new(1, -13, 0, 5),
                            ImageColor3 = Color3.fromRGB(255, 255, 255),
                            ScaleType = Enum.ScaleType.Fit,
                            Parent = self.button,
                            Rotation = -90,
                            ZIndex = 15
                          })
                          mouse_button_click = function()
                            self.window.drop_container.Visible = not self.window.drop_container.Visible
                            self.window.drop_container.Position = UDim2.new(0, self.button.AbsolutePosition.X, 0, self.button.AbsolutePosition.Y + self.button.AbsoluteSize.Y)
                            self.arrow.Rotation = self.window.drop_container.Visible and -180 or -90
                            if (self.window.drop_container.Visible) then
                              self.window.drop_flag = self.flag
                              for _, object in next,self.window.drop_container:GetChildren() do
                                if object:IsA("TextButton") then
                                  object:Destroy()
                                end
                              end
                              local _list_0 = self.values
                              for _index_0 = 1, #_list_0 do
                                local value = _list_0[_index_0]
                                local is_active = options.multi and table.find(self.window.flags[flag], value) or self.window.flags[flag] == value
                                local drop = self.window:add_object("TextButton", {
                                  Name = generate_guid(),
                                  BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                                  BackgroundTransparency = 0,
                                  BorderSizePixel = 1,
                                  BorderColor3 = Color3.fromRGB(30, 30, 30),
                                  Size = UDim2.new(1, 1, 0, 20),
                                  Position = UDim2.new(0, 0, 0, 0),
                                  Text = tostring(value),
                                  Parent = self.window.drop_container,
                                  AutoButtonColor = false,
                                  Font = Enum.Font.Gotham,
                                  TextSize = 12,
                                  TextXAlignment = Enum.TextXAlignment.Left,
                                  TextColor3 = is_active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255),
                                  Visible = true,
                                  ZIndex = 10000
                                })
                                mouse_button_click = function()
                                  self.window.flags[flag] = (function()
                                    if options.multi then
                                      if table.find(self.window.flags[flag], value) then
                                        table.remove(self.window.flags[flag], table.find(self.window.flags[flag], value))
                                      else
                                        table.insert(self.window.flags[flag], value)
                                      end
                                      return self.window.flags[flag]
                                    else
                                      return value
                                    end
                                  end)()
                                  for _, object in next,self.window.drop_container:GetChildren() do
                                    if object:IsA("TextButton") then
                                      is_active = options.multi and table.find(self.window.flags[flag], object.Text) or self.window.flags[flag] == object.Text
                                      object.TextColor3 = is_active and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                                      if not options.multi then
                                        object.Visible = false
                                      end
                                    end
                                  end
                                  self.button.Text = (function()
                                    local buffer = ""
                                    if options.multi then
                                      local _list_1 = self.window.flags[flag]
                                      for _index_1 = 1, #_list_1 do
                                        local value = _list_1[_index_1]
                                        buffer = tostring(buffer) .. " " .. tostring(value) .. ","
                                      end
                                    else
                                      buffer = tostring(self.window.flags[flag])
                                    end
                                    return buffer
                                  end)()
                                  if not options.multi then
                                    self.window.drop_container.Visible = false
                                    self.arrow.Rotation = -90
                                  end
                                  return options.callback(self.window.flags[flag])
                                end
                                self.window.connections[#self.window.connections + 1] = drop.MouseButton1Click:Connect(mouse_button_click)
                              end
                            end
                          end
                          local input_began
                          input_began = function(input)
                            if not self.window.drop_container.Visible then
                              return 
                            end
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                              local fix_position = self.window.drop_container.AbsolutePosition - Vector2.new(0, self.button.AbsoluteSize.Y)
                              local fix_size = self.window.drop_container.AbsoluteSize + Vector2.new(0, self.button.AbsoluteSize.Y)
                              if fix_position.X > input.Position.X or fix_position.Y > input.Position.Y or fix_position.X + fix_size.X < input.Position.X or fix_position.Y + fix_size.Y < input.Position.Y then
                                self.window.drop_container.Visible = false
                                self.arrow.Rotation = -90
                              end
                            end
                          end
                          self.window.connections[#self.window.connections + 1] = self.button.MouseButton1Click:Connect(mouse_button_click)
                          self.window.connections[#self.window.connections + 1] = game:GetService("UserInputService").InputBegan:Connect(input_began)
                        end,
                        __base = _base_4,
                        __name = "list",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      list = _class_4
                    end
                    self.parent.parent.options[flag] = list(self, flag, options)
                    if (options.ignore) then
                      self.parent.parent.ignore[flag] = true
                    end
                    return self.parent.parent.options[flag]
                  end,
                  new_button = function(self, options)
                    if options == nil then
                      options = { }
                    end
                    local button
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = { }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, options)
                          if options == nil then
                            options = { }
                          end
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 20),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            ClipsDescendants = true,
                            ZIndex = 13
                          })
                          self.button = self.window:add_object("TextButton", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 1,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, -65, 1, -5),
                            Position = UDim2.new(0, 3, 0, 2),
                            Text = options.text,
                            Parent = self.group_objects[#self.group_objects],
                            AutoButtonColor = false,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextColor3 = options.unsafe and Color3.fromRGB(182, 182, 101) or Color3.fromRGB(255, 255, 255),
                            ZIndex = 14
                          })
                          mouse_button_click = function()
                            return options.callback()
                          end
                          self.window.connections[#self.window.connections + 1] = self.button.MouseButton1Click:Connect(mouse_button_click)
                        end,
                        __base = _base_4,
                        __name = "button",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      button = _class_4
                    end
                    return button(self, options)
                  end,
                  new_slider = function(self, flag, options)
                    if options == nil then
                      options = { }
                    end
                    local slider
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = {
                        set_value = function(self, value)
                          self.window.flags[flag] = math.clamp(value, options.min, options.max)
                          self.entry.Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or "")
                          value = self.window.flags[flag] / (options.max - options.min)
                          self.slider_value.Size = UDim2.new(value, 0, 1, 0)
                          self.slider_value.Position = UDim2.new(0, 0, 0, 0)
                          if (self.window.flags[flag] ~= self.last_value) then
                            self.last_value = self.window.flags[flag]
                            return options.callback(self.window.flags[flag])
                          end
                        end
                      }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, flag, options)
                          if options == nil then
                            options = { }
                          end
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          self.window.flags[flag] = options.default or 0
                          options.callback = options.callback or function() end
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 34),
                            Position = UDim2.new(0, 3, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            AutomaticSize = Enum.AutomaticSize.XY,
                            ClipsDescendants = true,
                            ZIndex = 13
                          })
                          name = self.window:add_object("TextLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, -65, 0, 20),
                            Position = UDim2.new(0, 2, 0, 0),
                            Text = tostring(options.text) .. ": ",
                            Parent = self.group_objects[#self.group_objects],
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextColor3 = options.unsafe and Color3.fromRGB(182, 182, 101) or Color3.fromRGB(255, 255, 255),
                            ZIndex = 14
                          })
                          local text_size = game:GetService("TextService"):GetTextSize(name.ContentText, name.TextSize, name.Font, name.AbsoluteSize)
                          self.entry = self.window:add_object("TextBox", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, -65 - text_size.X, 0, 20),
                            Position = UDim2.new(0, 0 + text_size.X, 0, 0),
                            Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or ""),
                            Parent = self.group_objects[#self.group_objects],
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            ZIndex = 14
                          })
                          slider = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 1,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, -65, 0, 12),
                            Position = UDim2.new(0, 3, 0, 20),
                            Parent = self.group_objects[#self.group_objects],
                            ZIndex = 14
                          })
                          self.button = self.window:add_object("TextButton", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 0, 0, 0),
                            Text = "",
                            Parent = slider,
                            AutoButtonColor = false,
                            ZIndex = 15
                          })
                          local value = (self.window.flags[flag] / (options.max - options.min)) - (options.min / (options.max - options.min))
                          self.slider_value = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = UDim2.new(value, 0, 1, 0),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = self.button,
                            ZIndex = 16
                          })
                          local is_mouse_down = false
                          self.last_value = self.window.flags[flag]
                          local mouse_down
                          mouse_down = function(x)
                            is_mouse_down = true
                            local distance = self.button.AbsoluteSize.X
                            local decimals = options.decimals > 0 and 10 * options.decimals or 1
                            local mouse_distance = math.clamp((x - self.button.AbsolutePosition.X) / distance, 0, 1)
                            value = math.round(((options.max - options.min) * mouse_distance + options.min) * decimals) / decimals
                            self.window.flags[flag] = value
                            self.entry.Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or "")
                            self.slider_value.Size = UDim2.new((value / (options.max - options.min)) - (options.min / (options.max - options.min)), 0, 1, 0)
                          end
                          local mouse_move
                          mouse_move = function(x)
                            if is_mouse_down then
                              return mouse_down(x)
                            end
                          end
                          local mouse_button_up
                          mouse_button_up = function()
                            is_mouse_down = false
                            if (self.window.flags[flag] ~= self.last_value) then
                              self.last_value = self.window.flags[flag]
                              return options.callback(self.window.flags[flag])
                            end
                          end
                          local mouse_leave
                          mouse_leave = function()
                            is_mouse_down = false
                            if (self.window.flags[flag] ~= self.last_value) then
                              self.last_value = self.window.flags[flag]
                              return options.callback(self.window.flags[flag])
                            end
                          end
                          local on_focus_lost
                          on_focus_lost = function(enter_pressed)
                            if enter_pressed then
                              value = tonumber(self.entry.Text)
                              if value then
                                self.window.flags[flag] = math.clamp(value, options.min, options.max)
                                self.entry.Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or "")
                                value = self.window.flags[flag] / (options.max - options.min)
                                self.slider_value.Size = UDim2.new(value, 0, 1, 0)
                                self.slider_value.Position = UDim2.new(0, 0, 0, 0)
                                if (self.window.flags[flag] ~= self.last_value) then
                                  self.last_value = self.window.flags[flag]
                                  return options.callback(self.window.flags[flag])
                                end
                              else
                                self.entry.Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or "")
                              end
                            else
                              self.entry.Text = tostring(self.window.flags[flag]) .. tostring(options.suffix or "")
                            end
                          end
                          self.window.connections[#self.window.connections + 1] = self.button.MouseButton1Down:Connect(mouse_down)
                          self.window.connections[#self.window.connections + 1] = self.button.MouseMoved:Connect(mouse_move)
                          self.window.connections[#self.window.connections + 1] = self.button.MouseButton1Up:Connect(mouse_button_up)
                          self.window.connections[#self.window.connections + 1] = self.button.MouseLeave:Connect(mouse_leave)
                          self.window.connections[#self.window.connections + 1] = self.entry.FocusLost:Connect(on_focus_lost)
                        end,
                        __base = _base_4,
                        __name = "slider",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      slider = _class_4
                    end
                    self.parent.parent.options[flag] = slider(self, flag, options)
                    if (options.ignore) then
                      self.parent.parent.ignore[flag] = true
                    end
                    return self.parent.parent.options[flag]
                  end,
                  new_textbox = function(self, flag, options)
                    if options == nil then
                      options = { }
                    end
                    local textbox
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = {
                        set_value = function(self, value)
                          self.window.flags[flag] = value
                          self.entry.Text = self.window.flags[flag]
                          if (self.window.flags[flag] ~= self.last_value) then
                            self.last_value = self.window.flags[flag]
                            return options.callback(self.window.flags[flag])
                          end
                        end
                      }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, flag, options)
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          options.callback = options.callback or function() end
                          self.window.flags[flag] = options.default or ""
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 30),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            ZIndex = 13
                          })
                          self.label = self.window:add_object("TextLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, -65, 0, 10),
                            Position = UDim2.new(0, 2, 0, 1),
                            Text = options.text or flag,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = self.group_objects[#self.group_objects],
                            ZIndex = 14
                          })
                          self.entry = self.window:add_object("TextBox", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 1,
                            BorderColor3 = Color3.fromRGB(30, 30, 30),
                            Size = UDim2.new(1, -65, 0, 14),
                            Position = UDim2.new(0, 3, 0, 13),
                            Text = self.window.flags[flag],
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = self.group_objects[#self.group_objects],
                            ClipsDescendants = true,
                            ClearTextOnFocus = false,
                            ZIndex = 14
                          })
                          local on_focus_lost
                          on_focus_lost = function(enter_pressed)
                            if enter_pressed then
                              self.window.flags[flag] = self.entry.Text
                              if (self.window.flags[flag] ~= self.last_value) then
                                self.last_value = self.window.flags[flag]
                                return options.callback(self.window.flags[flag])
                              end
                            else
                              self.entry.Text = self.window.flags[flag]
                            end
                          end
                          self.window.connections[#self.window.connections + 1] = self.entry.FocusLost:Connect(on_focus_lost)
                        end,
                        __base = _base_4,
                        __name = "textbox",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      textbox = _class_4
                    end
                    self.parent.parent.options[flag] = textbox(self, flag, options)
                    if (options.ignore) then
                      self.parent.parent.ignore[flag] = true
                    end
                    return self.parent.parent.options[flag]
                  end,
                  new_label = function(self, options)
                    if options == nil then
                      options = { }
                    end
                    local label
                    do
                      local _class_4
                      local _parent_0 = item
                      local _base_4 = { }
                      _base_4.__index = _base_4
                      setmetatable(_base_4, _parent_0.__base)
                      _class_4 = setmetatable({
                        __init = function(self, parent, options)
                          self.parent = parent
                          self.window = self.parent.parent.parent
                          self.group_objects = { }
                          self.group_objects[#self.group_objects + 1] = self.window:add_object("Frame", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 10),
                            Position = UDim2.new(0, 0, 0, 0),
                            Parent = current_group[current_group_index + 1],
                            ZIndex = 13
                          })
                          self.label = self.window:add_object("TextLabel", {
                            Name = generate_guid(),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, -65, 0, 10),
                            Position = UDim2.new(0, 2, 0, 1),
                            Text = options.text,
                            TextColor3 = options.unsafe and Color3.fromRGB(182, 182, 101) or Color3.fromRGB(255, 255, 255),
                            TextSize = 12,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = self.group_objects[#self.group_objects],
                            ZIndex = 14
                          })
                        end,
                        __base = _base_4,
                        __name = "label",
                        __parent = _parent_0
                      }, {
                        __index = function(cls, name)
                          local val = rawget(_base_4, name)
                          if val == nil then
                            local parent = rawget(cls, "__parent")
                            if parent then
                              return parent[name]
                            end
                          else
                            return val
                          end
                        end,
                        __call = function(cls, ...)
                          local _self_0 = setmetatable({}, _base_4)
                          cls.__init(_self_0, ...)
                          return _self_0
                        end
                      })
                      _base_4.__class = _class_4
                      if _parent_0.__inherited then
                        _parent_0.__inherited(_parent_0, _class_4)
                      end
                      label = _class_4
                    end
                    self.parent.parent.options[options.text] = label(self, options)
                    return self.parent.parent.options[options.text]
                  end
                }
                _base_3.__index = _base_3
                _class_3 = setmetatable({
                  __init = function(self, parent)
                    self.parent = parent
                    self.group_objects = { }
                  end,
                  __base = _base_3,
                  __name = "group"
                }, {
                  __index = _base_3,
                  __call = function(cls, ...)
                    local _self_0 = setmetatable({}, _base_3)
                    cls.__init(_self_0, ...)
                    return _self_0
                  end
                })
                _base_3.__class = _class_3
                local self = _class_3
                do
                  local _class_4
                  local _base_4 = {
                    add_keybind = function(self, flag, options)
                      if options == nil then
                        options = { }
                      end
                      local keybind
                      do
                        local _class_5
                        local _base_5 = {
                          set_value = function(self, value)
                            if value == nil then
                              value = { }
                            end
                            if value.keycode then
                              self.window.flags[self.flag].keycode = value.keycode
                              self.window.flags[self.flag].mode = value.mode
                              if value.keycode == "MouseButton1" then
                                keybind.Text = "[MB1]"
                              else
                                if value.keycode == "MouseButton2" then
                                  keybind.Text = "[MB2]"
                                else
                                  keybind.Text = "[" .. tostring(value.keycode) .. "]"
                                end
                              end
                            else
                              self.window.flags[self.flag].keycode = nil
                              self.window.flags[self.flag].mode = "Hold"
                              keybind.Text = "[None]"
                            end
                          end
                        }
                        _base_5.__index = _base_5
                        _class_5 = setmetatable({
                          __init = function(self, parent, flag, options)
                            self.window = parent.window
                            self.flag = flag
                            self.awaiting_input = false
                            self.window.flags[flag] = {
                              state = options.state or false,
                              keycode = options.default and options.default.Name or nil,
                              mode = options.mode or "Hold"
                            }
                            options.callback = options.callback or function() end
                            keybind = self.window:add_object("TextButton", {
                              Name = generate_guid(),
                              BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                              BackgroundTransparency = 1,
                              BorderSizePixel = 0,
                              Size = UDim2.new(0, 60, 1, 0),
                              Position = UDim2.new(1, -62, 0, 0),
                              TextColor3 = Color3.fromRGB(100, 100, 100),
                              TextSize = 12,
                              Text = options.default == "MouseButton1" and "[MB1]" or options.default == "MouseButton2" and "[MB2]" or options.default and "[" .. tostring(options.default.Name) .. "]" or "[None]",
                              Font = Enum.Font.GothamSemibold,
                              Parent = parent.group_objects[#parent.group_objects],
                              ZIndex = 13
                            })
                            local mouse_button_right_click
                            mouse_button_right_click = function()
                              self.window.current_keybind = flag
                              self.window.keybind_objects[1].Visible = true
                              self.window.keybind_objects[1].Position = UDim2.new(0, keybind.AbsolutePosition.X + keybind.AbsoluteSize.X, 0, keybind.AbsolutePosition.Y)
                            end
                            mouse_button_click = function()
                              self.window.current_keybind = flag
                              self.awaiting_input = true
                              keybind.Text = "[...]"
                            end
                            local input_began
                            input_began = function(input)
                              if input.UserInputType == Enum.UserInputType.Keyboard then
                                if self.awaiting_input then
                                  if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                    self.awaiting_input = false
                                    keybind.Text = "[None]"
                                    self.window.flags[flag].keycode = nil
                                    self.window.flags[flag].state = false
                                    return 
                                  end
                                  keybind.Text = "[" .. tostring(input.KeyCode.Name) .. "]"
                                  self.window.flags[flag].keycode = input.KeyCode.Name
                                  self.awaiting_input = false
                                else
                                  if input.KeyCode.Name == self.window.flags[flag].keycode and self.window.flags[flag].mode == "Hold" then
                                    self.window.flags[flag].state = true
                                    return options.callback(self.window.flags[flag].state)
                                  else
                                    if input.KeyCode.Name == self.window.flags[flag].keycode and self.window.flags[flag].mode == "Toggle" then
                                      self.window.flags[flag].state = not self.window.flags[flag].state
                                      return options.callback(self.window.flags[flag].state)
                                    end
                                  end
                                end
                              else
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                  if self.awaiting_input then
                                    self.awaiting_input = false
                                    keybind.Text = "[MB1]"
                                    self.window.flags[flag].keycode = "MouseButton1"
                                    return 
                                  end
                                  if self.window.flags[flag].keycode == "MouseButton1" and self.window.flags[flag].mode == "Hold" then
                                    self.window.flags[flag].state = true
                                    return options.callback(self.window.flags[flag].state)
                                  else
                                    if self.window.flags[flag].keycode == "MouseButton1" and self.window.flags[flag].mode == "Toggle" then
                                      self.window.flags[flag].state = not self.window.flags[flag].state
                                      return options.callback(self.window.flags[flag].state)
                                    end
                                  end
                                else
                                  if input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    if self.awaiting_input then
                                      self.awaiting_input = false
                                      keybind.Text = "[MB2]"
                                      self.window.flags[flag].keycode = "MouseButton2"
                                      return 
                                    end
                                    if self.window.flags[flag].keycode == "MouseButton2" and self.window.flags[flag].mode == "Hold" then
                                      self.window.flags[flag].state = true
                                      return options.callback(self.window.flags[flag].state)
                                    else
                                      if self.window.flags[flag].keycode == "MouseButton2" and self.window.flags[flag].mode == "Toggle" then
                                        self.window.flags[flag].state = not self.window.flags[flag].state
                                        return options.callback(self.window.flags[flag].state)
                                      end
                                    end
                                  end
                                end
                              end
                            end
                            local input_ended
                            input_ended = function(input)
                              if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode.Name == self.window.flags[flag].keycode and self.window.flags[flag].mode == "Hold" then
                                  self.window.flags[flag].state = false
                                  options.callback(self.window.flags[flag].state)
                                end
                              end
                              if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                if self.window.keybind_objects[1].Visible then
                                  self.window.keybind_objects[1].Visible = false
                                end
                                if self.window.flags[flag].keycode == "MouseButton1" and self.window.flags[flag].mode == "Hold" then
                                  self.window.flags[flag].state = false
                                  options.callback(self.window.flags[flag].state)
                                end
                              end
                              if input.UserInputType == Enum.UserInputType.MouseButton2 then
                                if self.window.flags[flag].keycode == "MouseButton2" and self.window.flags[flag].mode == "Hold" then
                                  self.window.flags[flag].state = false
                                  return options.callback(self.window.flags[flag].state)
                                end
                              end
                            end
                            self.window.connections[#self.window.connections + 1] = keybind.MouseButton2Click:Connect(mouse_button_right_click)
                            self.window.connections[#self.window.connections + 1] = keybind.MouseButton1Click:Connect(mouse_button_click)
                            self.window.connections[#self.window.connections + 1] = game:GetService("UserInputService").InputBegan:Connect(input_began)
                            self.window.connections[#self.window.connections + 1] = game:GetService("UserInputService").InputEnded:Connect(input_ended)
                          end,
                          __base = _base_5,
                          __name = "keybind"
                        }, {
                          __index = _base_5,
                          __call = function(cls, ...)
                            local _self_0 = setmetatable({}, _base_5)
                            cls.__init(_self_0, ...)
                            return _self_0
                          end
                        })
                        _base_5.__class = _class_5
                        keybind = _class_5
                      end
                      self.window.options[flag] = keybind(self, flag, options)
                      if (options.ignore) then
                        self.window.ignore[flag] = true
                      end
                      return self.window.options[flag]
                    end,
                    add_colorpicker = function(self, flag, options)
                      if options == nil then
                        options = { }
                      end
                      local colorpicker
                      do
                        local _class_5
                        local _base_5 = {
                          set_value = function(self, value)
                            self.window.flags[self.flag] = {
                              color = value.color or Color3.fromRGB(255, 255, 255),
                              transparency = value.transparency or 0
                            }
                            self.container.BackgroundColor3 = value.color or Color3.fromRGB(255, 255, 255)
                          end
                        }
                        _base_5.__index = _base_5
                        _class_5 = setmetatable({
                          __init = function(self, parent, flag, options)
                            self.window = parent.window
                            self.flag = flag
                            self.options = options
                            options.default = options.default or { }
                            self.window.flags[flag] = {
                              color = options.default.color or Color3.fromRGB(255, 255, 255),
                              transparency = options.default.transparency or 0
                            }
                            self.container = self.window:add_object("TextButton", {
                              Name = generate_guid(),
                              Size = UDim2.new(0, 35, 0, 10),
                              Position = UDim2.new(1, -48, 0, 1),
                              BackgroundTransparency = 0,
                              Text = "",
                              BackgroundColor3 = self.window.flags[flag].color,
                              BorderSizePixel = 1,
                              BorderColor3 = Color3.fromRGB(80, 80, 80),
                              AutoButtonColor = false,
                              Parent = parent.group_objects[#parent.group_objects],
                              ZIndex = 14
                            })
                            mouse_button_click = function()
                              self.window.current_colorpicker = self.window.flags[flag]
                              self.window.current_colorbox = self.container
                              local hue, saturation, value = self.window.flags[flag].color:ToHSV()
                              self.window.colorpicker_objects[1].Position = UDim2.new(0, self.container.AbsolutePosition.X + self.container.AbsoluteSize.X + 15, 0, self.container.AbsolutePosition.Y)
                              self.window.colorpicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                              self.window.opacity_slider.BackgroundColor3 = self.window.flags[flag].color
                              self.window.location.Position = UDim2.new(0, math.clamp(saturation * self.window.colorpicker.AbsoluteSize.X, 0, 170), 0, math.clamp((-(value) + 1) * self.window.colorpicker.AbsoluteSize.Y, 0, 170))
                              self.window.hue_slider_location.Position = UDim2.new(0, 0, 0, math.clamp(hue * self.window.hue_slider.AbsoluteSize.Y, 0, 175))
                              self.window.opacity_slider_location.Position = UDim2.new(0, 0, 0, math.clamp(self.window.flags[flag].transparency * self.window.opacity_slider.AbsoluteSize.Y, 0, 175))
                              self.window.colorpicker_objects[1].Visible = true
                            end
                            local input_began
                            input_began = function(input)
                              if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                if self.window.colorpicker_objects[1].Visible and not self.inside then
                                  if input.Position.X <= self.window.colorpicker_objects[1].AbsolutePosition.X or input.Position.X >= self.window.colorpicker_objects[1].AbsolutePosition.X + self.window.colorpicker_objects[1].AbsoluteSize.X or input.Position.Y <= self.window.colorpicker_objects[1].AbsolutePosition.Y or input.Position.Y >= self.window.colorpicker_objects[1].AbsolutePosition.Y + self.window.colorpicker_objects[1].AbsoluteSize.Y then
                                    self.window.colorpicker_objects[1].Visible = false
                                  end
                                end
                              end
                            end
                            self.window.connections[#self.window.connections + 1] = self.container.MouseButton1Click:Connect(mouse_button_click)
                            self.window.connections[#self.window.connections + 1] = game:GetService("UserInputService").InputBegan:Connect(input_began)
                          end,
                          __base = _base_5,
                          __name = "colorpicker"
                        }, {
                          __index = _base_5,
                          __call = function(cls, ...)
                            local _self_0 = setmetatable({}, _base_5)
                            cls.__init(_self_0, ...)
                            return _self_0
                          end
                        })
                        _base_5.__class = _class_5
                        colorpicker = _class_5
                      end
                      self.window.options[flag] = colorpicker(self, flag, options)
                      if (options.ignore) then
                        self.window.ignore[flag] = true
                      end
                      return self.window.options[flag]
                    end
                  }
                  _base_4.__index = _base_4
                  _class_4 = setmetatable({
                    __init = function() end,
                    __base = _base_4,
                    __name = "item"
                  }, {
                    __index = _base_4,
                    __call = function(cls, ...)
                      local _self_0 = setmetatable({}, _base_4)
                      cls.__init(_self_0, ...)
                      return _self_0
                    end
                  })
                  _base_4.__class = _class_4
                  item = _class_4
                end
                group = _class_3
              end
              return group(self)
            end
          }
          _base_2.__index = _base_2
          _class_2 = setmetatable({
            __init = function(self, parent)
              self.parent = parent
              self.parent:add_object("UIListLayout", {
                Name = generate_guid(),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Parent = self.parent.tab_groups[current_tab_index]
              })
              self.left_group = self.parent:add_object("ScrollingFrame", {
                Name = generate_guid(),
                BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                BorderSizePixel = 0,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Parent = self.parent.tab_groups[current_tab_index],
                ClipsDescendants = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BottomImage = "rbxassetid://0",
                CanvasSize = UDim2.new(0, 0, 1, 0),
                ScrollBarThickness = 3,
                ScrollBarImageTransparency = 0,
                ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0),
                TopImage = "rbxassetid://0",
                VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                ZIndex = 10
              })
              self.right_group = self.parent:add_object("ScrollingFrame", {
                Name = generate_guid(),
                BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                BorderSizePixel = 0,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0, 0),
                Parent = self.parent.tab_groups[current_tab_index],
                ClipsDescendants = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BottomImage = "rbxassetid://0",
                CanvasSize = UDim2.new(0, 0, 1, 0),
                ScrollBarThickness = 3,
                ScrollBarImageTransparency = 0,
                ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0),
                TopImage = "rbxassetid://0",
                VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                ZIndex = 10
              })
              self.left_group_objects = {
                self.parent:add_object("UIListLayout", {
                  Name = generate_guid(),
                  FillDirection = Enum.FillDirection.Vertical,
                  HorizontalAlignment = Enum.HorizontalAlignment.Left,
                  SortOrder = Enum.SortOrder.LayoutOrder,
                  VerticalAlignment = Enum.VerticalAlignment.Top,
                  Padding = UDim.new(0, 4),
                  Parent = self.left_group
                }),
                self.parent:add_object("UIPadding", {
                  Name = generate_guid(),
                  PaddingBottom = UDim.new(0, 1),
                  PaddingLeft = UDim.new(0, 1),
                  PaddingRight = UDim.new(0, 2),
                  PaddingTop = UDim.new(0, 1),
                  Parent = self.left_group
                }),
                self.parent:add_object("Frame", {
                  Name = generate_guid(),
                  BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                  BorderSizePixel = 0,
                  Size = UDim2.new(0, 0, 0, 0),
                  Position = UDim2.new(0, 0, 1, 0),
                  Parent = self.left_group,
                  LayoutOrder = 9999
                })
              }
              self.right_group_objects = {
                self.parent:add_object("UIListLayout", {
                  Name = generate_guid(),
                  FillDirection = Enum.FillDirection.Vertical,
                  HorizontalAlignment = Enum.HorizontalAlignment.Left,
                  SortOrder = Enum.SortOrder.LayoutOrder,
                  VerticalAlignment = Enum.VerticalAlignment.Top,
                  Padding = UDim.new(0, 4),
                  Parent = self.right_group
                }),
                self.parent:add_object("UIPadding", {
                  Name = generate_guid(),
                  PaddingBottom = UDim.new(0, 1),
                  PaddingLeft = UDim.new(0, 2),
                  PaddingRight = UDim.new(0, 1),
                  PaddingTop = UDim.new(0, 1),
                  Parent = self.right_group
                }),
                self.parent:add_object("Frame", {
                  Name = generate_guid(),
                  BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                  BorderSizePixel = 0,
                  Size = UDim2.new(0, 0, 0, 0),
                  Position = UDim2.new(0, 0, 1, 0),
                  Parent = self.right_group,
                  LayoutOrder = 9999
                })
              }
            end,
            __base = _base_2,
            __name = "tab"
          }, {
            __index = _base_2,
            __call = function(cls, ...)
              local _self_0 = setmetatable({}, _base_2)
              cls.__init(_self_0, ...)
              return _self_0
            end
          })
          _base_2.__class = _class_2
          tab = _class_2
        end
        return tab(self)
      end,
      set_active_tab = function(self, idx)
        if idx == nil then
          idx = 1
        end
        self.active_tab = idx
        for idx, tab in next,self.tab_objects do
          tab.TextColor3 = Color3.fromRGB(255, 255, 255)
          if idx == self.active_tab then
            tab.TextColor3 = Color3.fromRGB(255, 0, 0)
          end
        end
        for idx, group in next,self.tab_groups do
          group.Visible = self.active_tab == idx
        end
      end,
      add_object = function(self, type, info)
        if type == nil then
          type = ""
        end
        if info == nil then
          info = { }
        end
        local buffer_instance = Instance.new(type)
        for key, value in next,info do
          buffer_instance[key] = value
        end
        self.objects[#self.objects + 1] = buffer_instance
        return buffer_instance
      end,
      destroy = function(self)
        for _, object in next,self.objects do
          object:Destroy()
        end
        for _, connection in next,self.connections do
          connection:Disconnect()
        end
      end
    }
    _base_1.__index = _base_1
    _class_1 = setmetatable({
      __init = function(self, title, position, size)
        if title == nil then
          title = "ars.red"
        end
        if position == nil then
          position = UDim2.new(0.5, -250, 0.5, -300)
        end
        if size == nil then
          size = UDim2.new(0, 500, 0, 600)
        end
        self.objects = { }
        self.dragging = false
        self.mouse_inside = false
        self.window_id = generate_guid()
        self.window = self:add_object("ScreenGui", {
          Name = self.window_id,
          ResetOnSpawn = false,
          DisplayOrder = 0,
          Parent = game:GetService("CoreGui")
        })
        local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
        local ScreenGui = cloneref(Instance.new("ScreenGui")) ProtectGui(ScreenGui)
        ProtectGui(self.window)
        self.position = position
        self.size = size
        self.title = title
        self.connections = { }
        self.current_keybind = { }
        self.current_colorpicker = { }
        self.current_colorbox = nil
        self.colorpicker_down = false
        self.colorpicker_hue_down = false
        self.colorpicker_opacity_down = false
        self.keybind_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 1,
            BorderColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0, 50, 0, 40),
            Position = UDim2.new(0, 0, 0, 0),
            Parent = self.window,
            Visible = false,
            ZIndex = 9999
          }),
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 1,
            BorderColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0, 50, 0, 40),
            Position = UDim2.new(0, 0, 0, 0)
          })
        }
        self:add_object("UIListLayout", {
          Name = generate_guid(),
          FillDirection = Enum.FillDirection.Vertical,
          SortOrder = Enum.SortOrder.LayoutOrder,
          Padding = UDim.new(0, 0),
          Parent = self.keybind_objects[1]
        })
        self.colorpicker_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 1,
            BorderColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0, 214, 0, 182),
            Position = UDim2.new(0, 10, 0, 10),
            Parent = self.window,
            Visible = false,
            ZIndex = 9999
          })
        }
        self.colorpicker = self:add_object("TextButton", {
          Name = generate_guid(),
          BackgroundTransparency = 0,
          BackgroundColor3 = Color3.fromRGB(255, 0, 0),
          BorderSizePixel = 0,
          Size = UDim2.new(0, 180, 0, 180),
          Position = UDim2.new(0, 1, 0, 1),
          Parent = self.colorpicker_objects[1],
          Text = "",
          Visible = true,
          AutoButtonColor = false,
          ZIndex = 9999
        })
        self:add_object("ImageLabel", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Size = UDim2.new(1, 0, 1, 0),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.colorpicker,
          Visible = true,
          ZIndex = 9999
        })
        self.location = self:add_object("Frame", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BackgroundColor3 = Color3.fromRGB(255, 255, 255),
          BorderSizePixel = 0,
          Size = UDim2.new(0, 10, 0, 10),
          Position = UDim2.new(1, -10, 0, 0),
          Parent = self.colorpicker,
          Visible = true,
          ZIndex = 9999
        })
        self:add_object("ImageLabel", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Size = UDim2.new(1, 0, 1, 0),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.location,
          Visible = true,
          ZIndex = 9999
        })
        self.drop_container = self:add_object("ScrollingFrame", {
          Name = generate_guid(),
          BackgroundColor3 = Color3.fromRGB(20, 20, 20),
          BackgroundTransparency = 0,
          BorderSizePixel = 1,
          BorderColor3 = Color3.fromRGB(30, 30, 30),
          Size = UDim2.new(0, 179, 0, 100),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.window,
          ClipsDescendants = true,
          Visible = false,
          ZIndex = 9999,
          CanvasSize = UDim2.new(0, 0, 0, 100),
          ScrollBarThickness = 3,
          ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0),
          ScrollBarImageTransparency = 0,
          AutomaticCanvasSize = Enum.AutomaticSize.Y,
          TopImage = "rbxassetid://0",
          BottomImage = "rbxassetid://0",
          VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        })
        self:add_object("UIPadding", {
          Name = generate_guid(),
          PaddingTop = UDim.new(0, 2),
          PaddingBottom = UDim.new(0, 2),
          PaddingLeft = UDim.new(0, 2),
          PaddingRight = UDim.new(0, 3),
          Parent = self.drop_container
        })
        self:add_object("UIListLayout", {
          Name = generate_guid(),
          Padding = UDim.new(0, 3),
          Parent = self.drop_container,
          SortOrder = Enum.SortOrder.LayoutOrder
        })
        local slider_group = self:add_object("Frame", {
          Name = generate_guid(),
          BackgroundTransparency = 0,
          BackgroundColor3 = Color3.fromRGB(20, 20, 20),
          BorderSizePixel = 0,
          BorderColor3 = Color3.fromRGB(30, 30, 30),
          Size = UDim2.new(0, 32, 0, 181),
          Position = UDim2.new(0, 181, 0, 0),
          Parent = self.colorpicker_objects[1],
          Visible = true,
          ZIndex = 9999
        })
        self.hue_slider = self:add_object("TextButton", {
          Name = generate_guid(),
          BackgroundTransparency = 0,
          BackgroundColor3 = Color3.fromRGB(255, 255, 255),
          BorderSizePixel = 0,
          BorderColor3 = Color3.fromRGB(30, 30, 30),
          Size = UDim2.new(0, 15, 0.994, 0),
          Position = UDim2.new(0, 1, 0, 1),
          Parent = slider_group,
          Visible = true,
          AutoButtonColor = false,
          Text = "",
          ZIndex = 9999
        })
        self:add_object("UIGradient", {
          Name = generate_guid(),
          Color = ColorSequence.new({
            unpack((function()
              local temp_values = { }
              for i = 0, 360, 360 / 10 do
                table.insert(temp_values, ColorSequenceKeypoint.new((1 / 360) * (i), Color3.fromHSV(i / 360, 1, 1)))
              end
              return temp_values
            end)())
          }),
          Rotation = 90,
          Parent = self.hue_slider
        })
        self.hue_slider_location = self:add_object("ImageLabel", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Size = UDim2.new(0, 15, 0, 5),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.hue_slider,
          Visible = true,
          ZIndex = 9999
        })
        self.opacity_slider = self:add_object("TextButton", {
          Name = generate_guid(),
          BackgroundTransparency = 0,
          BackgroundColor3 = Color3.fromRGB(255, 0, 0),
          BorderSizePixel = 0,
          BorderColor3 = Color3.fromRGB(30, 30, 30),
          Size = UDim2.new(0, 15, 0.994, 0),
          Position = UDim2.new(0, 17, 0, 1),
          Parent = slider_group,
          Visible = true,
          AutoButtonColor = false,
          Text = "",
          ZIndex = 10000
        })
        self:add_object("UIGradient", {
          Name = generate_guid(),
          Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
          }),
          Rotation = 90,
          Parent = self.opacity_slider
        })
        local transparent_pattern = self:add_object("ImageLabel", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Size = UDim2.new(0, 15, 0, 180),
          Position = UDim2.new(0, 17, 0, 1),
          Parent = slider_group,
          Visible = true,
          ScaleType = Enum.ScaleType.Tile,
          TileSize = UDim2.new(0, 15, 0, 18),
          ZIndex = 9999
        })
        self.opacity_slider_location = self:add_object("ImageLabel", {
          Name = generate_guid(),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Size = UDim2.new(0, 15, 0, 5),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.opacity_slider,
          ImageColor3 = Color3.fromRGB(255, 255, 255),
          Visible = true,
          ZIndex = 10000
        })
        local mouse_button_down
        mouse_button_down = function()
          self.colorpicker_down = true
        end
        local mouse_button_up
        mouse_button_up = function()
          self.colorpicker_down = false
        end
        local mouse_moved
        mouse_moved = function(x, y)
          y = y - game:GetService("GuiService"):GetGuiInset().Y
          if self.colorpicker_down then
            local saturation = math.clamp((x - self.colorpicker.AbsolutePosition.X) / self.colorpicker.AbsoluteSize.X, 0, 1)
            local value = -(math.clamp((y - self.colorpicker.AbsolutePosition.Y) / self.colorpicker.AbsoluteSize.Y, 0, 1)) + 1
            local hue = self.current_colorpicker.color:ToHSV()
            self.location.Position = UDim2.new(0, math.clamp(saturation * self.colorpicker.AbsoluteSize.X, 0, 170), 0, math.clamp((-(value) + 1) * self.colorpicker.AbsoluteSize.Y, 0, 170))
            self.opacity_slider.BackgroundColor3 = Color3.fromHSV(hue, saturation, value)
            self.current_colorpicker.color = Color3.fromHSV(hue, saturation, value)
            self.current_colorbox.BackgroundColor3 = self.current_colorpicker.color
          end
        end
        local mouse_leave
        mouse_leave = function()
          self.colorpicker_down = false
        end
        self.connections[#self.connections + 1] = self.colorpicker.MouseButton1Down:Connect(mouse_button_down)
        self.connections[#self.connections + 1] = self.colorpicker.MouseButton1Up:Connect(mouse_button_up)
        self.connections[#self.connections + 1] = self.colorpicker.MouseMoved:Connect(mouse_moved)
        self.connections[#self.connections + 1] = self.colorpicker.MouseLeave:Connect(mouse_leave)
        mouse_button_down = function()
          self.colorpicker_hue_down = true
        end
        mouse_button_up = function()
          self.colorpicker_hue_down = false
        end
        mouse_moved = function(x, y)
          y = y - game:GetService("GuiService"):GetGuiInset().Y
          if self.colorpicker_hue_down then
            local hue = math.clamp((y - self.hue_slider.AbsolutePosition.Y) / self.hue_slider.AbsoluteSize.Y, 0, 1)
            self.hue_slider_location.Position = UDim2.new(0, 0, 0, math.clamp(hue * self.hue_slider.AbsoluteSize.Y, 0, 175))
            local _, saturation, value = self.current_colorpicker.color:ToHSV()
            self.opacity_slider.BackgroundColor3 = Color3.fromHSV(hue, saturation, value)
            self.colorpicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            self.current_colorpicker.color = Color3.fromHSV(hue, saturation, value)
            self.current_colorbox.BackgroundColor3 = self.current_colorpicker.color
          end
        end
        mouse_leave = function()
          self.colorpicker_hue_down = false
        end
        self.connections[#self.connections + 1] = self.hue_slider.MouseButton1Down:Connect(mouse_button_down)
        self.connections[#self.connections + 1] = self.hue_slider.MouseButton1Up:Connect(mouse_button_up)
        self.connections[#self.connections + 1] = self.hue_slider.MouseMoved:Connect(mouse_moved)
        self.connections[#self.connections + 1] = self.hue_slider.MouseLeave:Connect(mouse_leave)
        mouse_button_down = function()
          self.colorpicker_opacity_down = true
        end
        mouse_button_up = function()
          self.colorpicker_opacity_down = false
        end
        mouse_moved = function(x, y)
          y = y - game:GetService("GuiService"):GetGuiInset().Y
          if self.colorpicker_opacity_down then
            local opacity = math.clamp((y - self.opacity_slider.AbsolutePosition.Y) / self.opacity_slider.AbsoluteSize.Y, 0, 1)
            self.opacity_slider_location.Position = UDim2.new(0, 0, 0, math.clamp(opacity * self.opacity_slider.AbsoluteSize.Y, 0, 175))
            self.current_colorpicker.transparency = opacity
          end
        end
        mouse_leave = function()
          self.colorpicker_opacity_down = false
        end
        self.connections[#self.connections + 1] = self.opacity_slider.MouseButton1Down:Connect(mouse_button_down)
        self.connections[#self.connections + 1] = self.opacity_slider.MouseButton1Up:Connect(mouse_button_up)
        self.connections[#self.connections + 1] = self.opacity_slider.MouseMoved:Connect(mouse_moved)
        self.connections[#self.connections + 1] = self.opacity_slider.MouseLeave:Connect(mouse_leave)
        local toggle_button = self:add_object("TextButton", {
          Name = generate_guid(),
          Text = "Toggle",
          TextColor3 = Color3.new(1, 1, 1),
          TextStrokeTransparency = 0,
          TextStrokeColor3 = Color3.new(0, 0, 0),
          Font = Enum.Font.Gotham,
          TextSize = 12,
          TextScaled = false,
          BackgroundTransparency = 1,
          Size = UDim2.new(1, 0, 0.5, 0),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.keybind_objects[1],
          ZIndex = 9999
        })
        local hold_button = self:add_object("TextButton", {
          Name = generate_guid(),
          Text = "Hold",
          TextColor3 = Color3.new(1, 1, 1),
          TextStrokeTransparency = 0,
          TextStrokeColor3 = Color3.new(0, 0, 0),
          Font = Enum.Font.Gotham,
          TextSize = 12,
          TextScaled = false,
          BackgroundTransparency = 1,
          Size = UDim2.new(1, 0, 0.5, 0),
          Position = UDim2.new(0, 0, 0, 0),
          Parent = self.keybind_objects[1],
          ZIndex = 9999
        })
        local mouse_button_click
        mouse_button_click = function()
          self.flags[self.current_keybind].mode = "Toggle"
        end
        self.connections[#self.connections + 1] = toggle_button.MouseButton1Click:Connect(mouse_button_click)
        mouse_button_click = function()
          self.flags[self.current_keybind].mode = "Hold"
        end
        self.connections[#self.connections + 1] = hold_button.MouseButton1Click:Connect(mouse_button_click)
        self.background_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            BorderSizePixel = 0,
            Size = self.size,
            Position = self.position,
            Parent = self.window,
            ZIndex = 0
          }),
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Size = self.size - UDim2.new(0, 2, 0, 2),
            Position = self.position + UDim2.new(0, 1, 0, 1),
            Parent = self.window,
            ZIndex = 1
          }),
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            BorderSizePixel = 0,
            Size = self.size - UDim2.new(0, 4, 0, 4),
            Position = self.position + UDim2.new(0, 2, 0, 2),
            Parent = self.window,
            ClipsDescendants = true,
            ZIndex = 2
          })
        }
        self.group_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -2, 1, -44),
            Position = UDim2.new(0, 1, 0, 43),
            Parent = self.background_objects[3],
            ClipsDescendants = true,
            ZIndex = 3
          })
        }
        self.title_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -2, 0, 20),
            Position = self.position + UDim2.new(0, 3, 0, 3),
            Parent = self.background_objects[3],
            ZIndex = 3
          }),
          self:add_object("TextLabel", {
            Name = generate_guid(),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Text = self.title,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -2, 0, 20),
            Position = self.position + UDim2.new(0, 3, 0, 3),
            Parent = self.background_objects[3],
            ZIndex = 4
          }),
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -2, 0, 1),
            Position = self.position + UDim2.new(0, 3, 0, 22),
            Parent = self.background_objects[3],
            ZIndex = 5
          })
        }
        self.tabs = { }
        self.tab_objects = { }
        self.tab_groups = { }
        self.flags = { }
        self.options = { }
        self.ignore = { }
        getgenv().flags = self.flags
        getgenv().options = self.options
        mouse_button_down = function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 and self.mouse_inside then
            self.dragging = true
            self.drag_start = input.Position
          end
        end
        mouse_button_up = function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = false
          end
        end
        mouse_moved = function(input)
          if self.dragging then
            self.position = self.position + UDim2.new(0, input.Position.X - self.drag_start.X, 0, input.Position.Y - self.drag_start.Y)
            self.drag_start = input.Position
            return self:update()
          end
        end
        local mouse_entered
        mouse_entered = function(x, y)
          self.mouse_inside = true
        end
        local mouse_left
        mouse_left = function(x, y)
          self.mouse_inside = false
        end
        self.connections = {
          self.background_objects[1].InputBegan:Connect(mouse_button_down),
          self.background_objects[1].InputEnded:Connect(mouse_button_up),
          self.background_objects[1].InputChanged:Connect(mouse_moved),
          self.background_objects[1].MouseEnter:Connect(mouse_entered),
          self.background_objects[1].MouseLeave:Connect(mouse_left)
        }
        self.title_objects[#self.title_objects + 1] = self:add_object("UIGradient", {
          Name = generate_guid(),
          Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)),
          Rotation = 0,
          Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
          }),
          Offset = Vector2.new(0, 0),
          Parent = self.title_objects[3]
        })
        self.tab_bar_objects = {
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -2, 0, 20),
            Position = self.position + UDim2.new(0, 3, 0, 24),
            Parent = self.background_objects[3],
            ZIndex = 6
          }),
          self:add_object("Frame", {
            Name = generate_guid(),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, 18),
            Position = self.position + UDim2.new(0, 4, 0, 25),
            Parent = self.background_objects[3],
            ZIndex = 7,
            ClipsDescendants = true
          })
        }
        self.tab_objects = { }
      end,
      __base = _base_1,
      __name = "window"
    }, {
      __index = _base_1,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_1)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_1.__class = _class_1
    window = _class_1
  end
  library = _class_0
end
local current_library = library()
return current_library
