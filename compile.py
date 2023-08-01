from traceback import print_exc
import subprocess
import sys
import os
import os.path


# Config
CWD = os.path.dirname(os.path.abspath(__file__))
B2OP = "b2op.gsc"
B2OP_COMPILED = "b2op-compiled.gsc"
GAME_PARSE = "iw5"      # Change later once it's actually implemented for t6
GAME_COMP = "t6"
MODE_PARSE = "parse"
MODE_COMP = "comp"
COMPILER_XENSIK = "gsc-tool.exe"
COMPILER_IRONY = "Compiler.exe"
BINARY_IRONY = "irony.dll"
PARSED_DIR = os.path.join("parsed", GAME_PARSE)
COMPILED_DIR = os.path.join("compiled", GAME_COMP)
ZMUTILITY_DIR = os.path.join("maps", "mp", "zombies")
PLUGIN_DIR = "plugin_templates"
REPLACE_DEFAULT = {
    "#define ANCIENT 1": "#define ANCIENT 0",
    "#define REDACTED 1": "#define REDACTED 0",
    "#define PLUTO 1": "#define PLUTO 0"
}


def edit_in_place(path: str, **replace_pairs) -> None:
    with open(path, "r", encoding="utf-8") as gsc_io:
        gsc_content = gsc_io.read()

    for old, new in replace_pairs.items():
        if old in gsc_content:
            print(f"Replacing '{old}' with '{new}'")
            gsc_content = gsc_content.replace(old, new)

    with open(path, "w", encoding="utf-8") as gsc_io:
        gsc_io.write(gsc_content)


def wrap_subprocess_call(*calls: str, timeout: int = 5, **sbp_args) -> subprocess.CompletedProcess:
    call = " ".join(calls)
    try:
        print(f"Call: {call}")
        process = subprocess.run(call, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout, **sbp_args)
    except Exception:
        print_exc()
        sys.exit()
    else:
        print(process.stdout.decode())


def arg_path(*paths: str) -> str:
    return f'"{os.path.join(*paths)}"'


def verify_ancient_dir() -> None:
    base_path = os.path.join(CWD, COMPILED_DIR)
    if not os.path.isdir(os.path.join(CWD, COMPILED_DIR, ZMUTILITY_DIR)):
        print("Recursively generating _zm_utility folder structure for injection")

    for elem in str(ZMUTILITY_DIR).split(os.path.sep):
        if not os.path.isdir((make := os.path.join(base_path, elem))):
            os.mkdir(make)
        base_path = os.path.join(base_path, elem)


def main(cfg: list) -> None:

    # New pluto
    pluto_update = dict(REPLACE_DEFAULT)
    pluto_update.update({"#define PLUTO 0": "#define PLUTO 1"})
    edit_in_place(os.path.join(CWD, B2OP), **pluto_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PARSED_DIR, B2OP))
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, PARSED_DIR, B2OP), arg_path(CWD, PARSED_DIR, "b2op_precompiled_pluto.gsc"), shell=True)
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, COMPILED_DIR, B2OP), arg_path(CWD, COMPILED_DIR, "b2op-plutonium.gsc"), shell=True)

    # Redacted
    redacted_update = dict(REPLACE_DEFAULT)
    redacted_update.update({"#define REDACTED 0": "#define REDACTED 1"})
    edit_in_place(os.path.join(CWD, B2OP), **redacted_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP))
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, PARSED_DIR, B2OP), arg_path(CWD, PARSED_DIR, "b2op_precompiled_redacted.gsc"), shell=True)
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, B2OP_COMPILED), arg_path(CWD, COMPILED_DIR, "b2op-redacted.gsc"), shell=True)

    # Ancient
    verify_ancient_dir()
    ancient_update = dict(REPLACE_DEFAULT)
    ancient_update.update({"#define ANCIENT 0": "#define ANCIENT 1"})
    edit_in_place(os.path.join(CWD, B2OP), **ancient_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP), timeout=30)
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, PARSED_DIR, B2OP), arg_path(CWD, PARSED_DIR, "b2op_precompiled_ancient.gsc"), shell=True)
    wrap_subprocess_call("COPY", "/y", arg_path(CWD, B2OP_COMPILED), arg_path(CWD, COMPILED_DIR, ZMUTILITY_DIR, "_zm_utility.gsc"), shell=True)

    # Plugins
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PLUGIN_DIR, "b2op_plugin_characters.gsc"))
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PLUGIN_DIR, "b2op_plugin_fridge.gsc"))
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PLUGIN_DIR, "b2op_plugin_hud.gsc"))
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PLUGIN_DIR, "b2op_plugin_splits.gsc"))

    # Cleanup
    wrap_subprocess_call("del", "/q", arg_path(CWD, PARSED_DIR, B2OP), shell=True)
    wrap_subprocess_call("del", "/q", arg_path(CWD, COMPILED_DIR, B2OP), shell=True)
    wrap_subprocess_call("del", "/q", arg_path(CWD, "_zm_utility.gsc"), shell=True)
    wrap_subprocess_call("del", "/q", arg_path(CWD, "b2op-redacted.gsc"), shell=True)
    wrap_subprocess_call("del", "/q", arg_path(CWD, B2OP_COMPILED), shell=True)


if __name__ == "__main__":
    main(sys.argv)
