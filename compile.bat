@rem New compiler
gsc-tool.exe comp t6 "b2op.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_characters.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_fridge.gsc"
gsc-tool.exe comp t6 "plugin_templates\b2op_plugin_hud.gsc"
@rem Old compiler
Compiler.exe "b2op.gsc"
Compiler.exe "plugin_templates\b2op_plugin_characters.gsc"
Compiler.exe "plugin_templates\b2op_plugin_fridge.gsc"
Compiler.exe "plugin_templates\b2op_plugin_hud.gsc"
@rem Move files
MOVE /y "b2op-compiled.gsc" "compiled\t6\_clientids.gsc"
MOVE /y "b2op_plugin_characters-compiled.gsc" "compiled\t6\_clientids-plugin-characters.gsc"
MOVE /y "b2op_plugin_fridge-compiled.gsc" "compiled\t6\_clientids-plugin-fridge.gsc"
MOVE /y "b2op_plugin_hud-compiled.gsc" "compiled\t6\_clientids-plugin-hud.gsc"