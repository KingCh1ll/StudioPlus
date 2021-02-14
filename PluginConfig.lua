return {	
	-- Toolbar --
	Toolbar = {
		Name = "Studio Plus",
		PluginID = 5699907726,
		PluginVersion = "0.1.31"
	},

	-- Plugin Buttons --
	Plugins = {
		StudioPlus = {
			Name = "Studio+",
			Description = "Improve your studio experience! This tool displays your FPS.",
			Icon = "http://www.roblox.com/asset/?id=6126294112",
			UILocation = script.Parent.Ui.FPSCounterGui,
			ScriptView = false,
			Active = false,
			Connections = {}
		},
		
		BuildingPlus = {
			Name = "Studio Building+",
			Description = "Improve your building! This tool displayes a widget that allows you to load a character/catalog Item from the Roblox website, Weld an object, & more!",
			Icon = "http://www.roblox.com/asset/?id=6126294112",
			UILocation = script.Parent.Ui.StudioBuildingGui,
			ScriptView = false,
			Active = false,
			Connections = {},

			IsWidget = true,
			DockTitle = "Studio Building+",
			WidgetInfo = DockWidgetPluginGuiInfo.new(
				Enum.InitialDockState.Float,
				true,
				false,
				300,
				200,
				300,
				200
			),
		},
	
		ScriptingPlus = {
			Name = "Studio Scripting+",
			Description = "Improve your scripting! Everytime you create a script, your name and the current date will be formatted.",
			Icon = "http://www.roblox.com/asset/?id=6126294112",
			UILocation = nil,
			ScriptView = true,
			Active = false,
			Connections = {}
		},
		
		StudioFeedback = {
			Name = "Studio Feedback",
			Description = "Want to provide feedback to KingCh1ll? Want a tool to be added to Studio Plus? Than this tool is for you!",
			Icon = "http://www.roblox.com/asset/?id=6126294112",
			UILocation = script.Parent.Ui.StudioFeedbackUi,
			ScriptView = false,
			Active = false,
			Connections = {},

			IsWidget = true,
			DockTitle = "Studio Feedback",
			WidgetInfo = DockWidgetPluginGuiInfo.new(
				Enum.InitialDockState.Float,
				true,
				false,
				300,
				200,
				300,
				200
			),
		},
	}
}
