from traceback import print_exc
import subprocess, sys, os, zipfile, re


class Version:
    UNKNOWN = [-1, -1, -1]
    """Signature of an unknown version"""


    def __init__(self) -> None:
        self._version: list[int]


    def __eq__(self, __object) -> bool:
        return self._version == __object._version
    

    def __ne__(self, __object) -> bool:
        return self._version != __object._version


    def __lt__(self, __object) -> bool:
        if self._version[0] < __object._version[0]:
            return True
        if self._version[0] <= __object._version[0] and self._version[1] < __object._version[1]:
            return True
        if self._version[0] <= __object._version[0] and self._version[1] <= __object._version[1] and self._version[2] < __object._version[2]:
            return True
        return False


    def __gt__(self, __object) -> bool:
        if self._version[0] > __object._version[0]:
            return True
        if self._version[0] >= __object._version[0] and self._version[1] > __object._version[1]:
            return True
        if self._version[0] >= __object._version[0] and self._version[1] >= __object._version[1] and self._version[2] > __object._version[2]:
            return True
        return False


    def __le__(self, __object) -> bool:
        return self == __object or self < __object


    def __ge__(self, __object) -> bool:
        return self == __object or self > __object


    def __str__(self) -> str:
        return ".".join([str(v) for v in self._version])


    @staticmethod
    def parse(_version: str):
        version = Version()
        version._version: list[int] = [int(v) for v in _version.split(".")]
        version.trim()
        return version


    def trim(self):
        if len(self._version) > 3:
            self._version = self._version[:3]
        return self


class UnknownVersion(Version):
    def __init__(self) -> None:
        super().__init__()
        self._version = self.UNKNOWN


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
BAD_COMPILER_VERSIONS = [Version.parse("1.2.0")]


def edit_in_place(path: str, **replace_pairs) -> None:
    with open(path, "r", encoding="utf-8") as gsc_io:
        gsc_content = gsc_io.read()

    for old, new in replace_pairs.items():
        if old in gsc_content:
            print(f"Replacing '{old}' with '{new}'")
            gsc_content = gsc_content.replace(old, new)

    with open(path, "w", encoding="utf-8") as gsc_io:
        gsc_io.write(gsc_content)


def wrap_subprocess_call(*calls: str, timeout: int = 5, cli_output: bool = True, **sbp_args) -> subprocess.CompletedProcess:
    call: str = " ".join(calls)
    try:
        print(f"Call: {call}")
        process: subprocess.CompletedProcess = subprocess.run(call, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout, **sbp_args)
    except Exception:
        print_exc()
        sys.exit()
    else:
        if cli_output:
            print(process.stdout.decode())
        return process


def arg_path(*paths: str) -> str:
    return f'"{os.path.join(*paths)}"'


def file_rename(old: str, new: str) -> None:
    if os.path.isfile(new):
        os.remove(new)
    if os.path.isfile(old):
        os.rename(old, new)


def create_zipfile() -> None:
    try:
        with zipfile.ZipFile(os.path.join(CWD, COMPILED_DIR, "b2op-ancient.zip"), "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zip:
            zip.write(os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"), os.path.join(ZMUTILITY_DIR, "_zm_utility.gsc"))
    except FileNotFoundError:
        print("WARNING! Failed to create zip file due to missing compiled file")


def verify_compiler_version() -> Version:
    compiler: subprocess.CompletedProcess = wrap_subprocess_call(COMPILER_XENSIK, cli_output=False)
    lines: list[str] = compiler.stdout.decode().split("\n")
    if not lines:
        print("Could not verify compiler version")
        return UnknownVersion()

    version: list[str] = re.compile(r"([\d.]+)").findall(lines[0])
    if len(version) != 1:
        print("Could not verify compiler version")
        return UnknownVersion()

    ver: Version = Version.parse(version[0])
    if ver < Version.parse("1.4.0") or ver in BAD_COMPILER_VERSIONS:
        input(f"WARNING! Potentially incompatibile version of the compiler ({str(ver)}) was found. Press ENTER to continue")
    return ver


def main(cfg: list) -> None:
    os.chdir(CWD)

    # Util
    version: Version = verify_compiler_version()

    # New pluto
    pluto_update = dict(REPLACE_DEFAULT)
    pluto_update.update({"#define PLUTO 0": "#define PLUTO 1"})
    edit_in_place(os.path.join(CWD, B2OP), **pluto_update)
    wrap_subprocess_call(COMPILER_XENSIK, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP)
    wrap_subprocess_call(COMPILER_XENSIK, "-m", MODE_COMP, "-g", GAME_COMP, "-s", "pc", arg_path(CWD, PARSED_DIR, B2OP))
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["pluto"]))
    file_rename(os.path.join(CWD, COMPILED_DIR, B2OP), os.path.join(CWD, COMPILED_DIR, "b2op-plutonium.gsc"))

    # Redacted
    redacted_update = dict(REPLACE_DEFAULT)
    redacted_update.update({"#define REDACTED 0": "#define REDACTED 1"})
    edit_in_place(os.path.join(CWD, B2OP), **redacted_update)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP))
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["redacted"]))
    file_rename(os.path.join(CWD, B2OP_COMPILED), os.path.join(CWD, COMPILED_DIR, "b2op-redacted.gsc"))
    wrap_subprocess_call(COMPILER_XENSIK, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP)

    # Ancient
    ancient_update = dict(REPLACE_DEFAULT)
    ancient_update.update({"#define ANCIENT 0": "#define ANCIENT 1"})
    edit_in_place(os.path.join(CWD, B2OP), **ancient_update)
    wrap_subprocess_call(COMPILER_IRONY, arg_path(CWD, PARSED_DIR, B2OP), timeout=30)
    wrap_subprocess_call(COMPILER_XENSIK, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP)
    wrap_subprocess_call(COMPILER_XENSIK, "-m", MODE_COMP, "-g", GAME_COMP, "-s", "pc", arg_path(CWD, PARSED_DIR, B2OP))
    file_rename(os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, PRECOMPILED["ancient"]))
    file_rename(os.path.join(CWD, B2OP_COMPILED), os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"))
    create_zipfile()


if __name__ == "__main__":
    main(sys.argv)
