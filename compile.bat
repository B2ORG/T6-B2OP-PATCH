@rem New compiler
gsc-tool.exe comp t6 "b2op.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_characters.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_fridge.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_hud.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_splits.gsc"

@rem Old compiler
Compiler.exe "b2op.gsc"

@rem Network Frame fix
gsc-tool.exe comp t6 "network_frame_fix.gsc"

@rem Move files
MOVE /y "b2op-compiled.gsc" "compiled\t6\maps\mp\gametypes\_clientids.gsc"