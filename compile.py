from traceback import print_exc
import subprocess
import sys
import os
import zipfile


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
PRECOMPILED = {
    "pluto": "b2op_precompiled_pluto.gsc",
    "redacted": "b2op_precompiled_redacted.gsc",
    "ancient": "b2op_precompiled_ancient.gsc",
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


def file_rename(old: str, new: str) -> None:
    if os.path.isfile(new):
        os.remove(new)
    if os.path.isfile(old):
        os.rename(old, new)


def create_zipfile() -> None:
    with zipfile.ZipFile(os.path.join(CWD, COMPILED_DIR, "b2op-ancient.zip"), "w") as zip:
        zip.write(os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"), os.path.join(ZMUTILITY_DIR, "_zm_utility.gsc"))


def main(cfg: list) -> None:
    os.chdir(CWD)

    # New pluto
    pluto_update = dict(REPLACE_DEFAULT)
    pluto_update.update({"#define PLUTO 0": "#define PLUTO 1"})
    edit_in_place(os.path.join(CWD, B2OP), **pluto_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_COMP, GAME_COMP, "pc", arg_path(CWD, PARSED_DIR, B2OP))
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["pluto"]))
    file_rename(os.path.join(CWD, COMPILED_DIR, B2OP), os.path.join(CWD, COMPILED_DIR, "b2op-plutonium.gsc"))

    # Redacted
    redacted_update = dict(REPLACE_DEFAULT)
    redacted_update.update({"#define REDACTED 0": "#define REDACTED 1"})
    edit_in_place(os.path.join(CWD, B2OP), **redacted_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP))
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["redacted"]))
    file_rename(os.path.join(CWD, B2OP_COMPILED), os.path.join(CWD, COMPILED_DIR, "b2op-redacted.gsc"))

    # Ancient
    ancient_update = dict(REPLACE_DEFAULT)
    ancient_update.update({"#define ANCIENT 0": "#define ANCIENT 1"})
    edit_in_place(os.path.join(CWD, B2OP), **ancient_update)
    wrap_subprocess_call(COMPILER_XENSIK, MODE_PARSE, GAME_PARSE, "pc", B2OP)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP), timeout=30)
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["ancient"]))
    file_rename(os.path.join(CWD, B2OP_COMPILED), os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"))
    create_zipfile()


if __name__ == "__main__":
    main(sys.argv)
