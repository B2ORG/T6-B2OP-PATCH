from traceback import print_exc
from copy import copy, deepcopy
import subprocess, sys, os, zipfile, re, binascii, shutil
from typing import Callable, Optional


# Config
CWD = os.path.dirname(os.path.abspath(__file__))
B2OP = "b2op.gsc"
B2OP_TOMB = "b2op_tomb.gsc"
GAME_PARSE = "t6"
GAME_COMP = "t6"
MODE_PARSE = "parse"
MODE_COMP = "comp"
COMPILER_GSCTOOL = "gsc-tool.exe"
PARSED_DIR = "parsed/" + GAME_PARSE
COMPILED_DIR = "compiled/" + GAME_COMP
ZMUTILITY_DIR = "maps/mp/zombies"
FORCE_SPACES = True
BAD_COMPILER_VERSIONS: set["Version"] = set()
COMPILE_TANK_PATCH = True
STRICT_FILE_RM_CHECK = int(os.environ.get("B2_STRICT_CHECK", True))

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


    def __hash__(self) -> int:
        return hash(f"{self._version[0]}|{self._version[1]}|{self._version[2]}")


    @staticmethod
    def parse(_version: str):
        version = Version()
        version._version = [int(v) for v in _version.split(".")]
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


class Chunk:
    def __init__(self, header: str | None = None) -> None:
        self.header = header


    def __enter__(self):
        if self.header is not None:
            print(self.header)
        print("-" * 100)


    def __exit__(self, *args):
        print("-" * 100, "\n")


class GscToolException(Exception):
    def __init__(self, *args):
        super().__init__(*args)


class CodeStyleException(Exception):
    def __init__(self, *args):
        super().__init__(*args)


class Gsc:
    REPLACEMENTS: dict[str, str] = {
        "#define RAW 1": "#define RAW 0",
        "#define ANCIENT 1": "#define ANCIENT 0",
        "#define REDACTED 1": "#define REDACTED 0",
        "#define PLUTO 1": "#define PLUTO 0"
    }
    def __init__(self, skip_changes: bool = False) -> None:
        self._code: str
        self._skip_changes: bool = skip_changes


    def load_file(self, path: str) -> "Gsc":
        with open(path, "r", encoding="utf-8") as gsc_io:
            self._code = gsc_io.read()
        return self


    def check_whitespace(self) -> "Gsc":
        tab: int = self._code.find("\t")
        if tab != -1:
            line: int = self._code.count("\n", 0, tab)
            print(f"TAB found in line {line + 1}. Make sure to use 4 spaces instead of a tab!")
            if FORCE_SPACES:
                raise CodeStyleException(f"Found TABs in line {line + 1}")
        return self


    def check_debug(self) -> "Gsc":
        self.debugger = self._code.find("#define DEBUG 1") != -1
        return self


    def save(self, path: str, local_changes: dict[str, str]) -> "Gsc":
        changes: dict[str, str] = deepcopy(Gsc.REPLACEMENTS) | local_changes
        changed: str = copy(self._code)
        if not self._skip_changes:
            for old, new in changes.items():
                changed = changed.replace(old, new)
        with open(path, "w", encoding="utf-8") as gsc_io:
            gsc_io.write(changed)
        return self


def edit_in_place(path: str, **replace_pairs) -> None:
    with open(path, "r", encoding="utf-8") as gsc_io:
        gsc_content = gsc_io.read()

    for old, new in replace_pairs.items():
        if old in gsc_content:
            print(f"Replacing '{old}' with '{new}'")
            gsc_content = gsc_content.replace(old, new)

    with open(path, "w", encoding="utf-8") as gsc_io:
        gsc_io.write(gsc_content)


def wrap_subprocess_call(*calls: str, timeout: int = 5, cli_output: bool = True, eval_callback: Optional[Callable[[subprocess.CompletedProcess, str], subprocess.CompletedProcess]] = None, **sbp_args) -> subprocess.CompletedProcess:
    call: str = " ".join(calls)
    try:
        print(f"Call: {call}")
        process: subprocess.CompletedProcess = subprocess.run(call, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True, timeout=timeout, **sbp_args)
    except Exception:
        print_exc()
        sys.exit(1)
    else:
        if callable(eval_callback):
            return eval_callback(process, call)
        print("Output:")
        print(process.stdout.strip() if cli_output else "suppressed")
        return process


def check_gsc_error(process: subprocess.CompletedProcess, cmd: str) -> subprocess.CompletedProcess:
    if "[ERROR]" in process.stdout:
        raise GscToolException(f"Command: '{cmd}'\n{process.stdout.strip()}")
    return process


def arg_path(*paths: str) -> str:
    return f'"{os.path.join(*paths)}"'


def file_rename(old: str, new: str) -> None:
    if os.path.isfile(new):
        os.remove(new)
    if os.path.isfile(old):
        if not os.path.isdir(os.path.dirname(new)):
            os.makedirs(os.path.dirname(new))
        os.rename(old, new)


def clear_files(dir: str, pattern: str) -> None:
    if not os.path.isdir(dir):
        return
    file_list: list[str] = os.listdir(dir)
    if STRICT_FILE_RM_CHECK or len(file_list) >= 16:
        input(f"You're about to remove {len(file_list)} files. Press ENTER to continue, or abord the program\n\t{"\n\t".join([os.path.basename(f) for f in file_list])}")

    for file in file_list:
        if re.match(pattern, file):
            path_to_file = os.path.join(dir, file)
            os.remove(path_to_file) if os.path.isfile(path_to_file) else shutil.rmtree(path_to_file)


def flash_hash(file_path: str) -> str:
    with open(file_path, "rb") as file_io:
        # Convert to uINT and represent as uppercase hex
        hash: str = format(binascii.crc32(file_io.read()) & 0xFFFFFFFF, "08X")
    print(f"Hash of {os.path.basename(file_path)}: '0x{hash}'")
    return hash


def create_zipfile(zip_target: str, file_to_zip: str, file_in_zip: str) -> None:
    try:
        with zipfile.ZipFile(zip_target, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zip:
            zip.write(file_to_zip, file_in_zip)
    except FileNotFoundError:
        print("WARNING! Failed to create zip file due to missing compiled file")


def verify_compiler() -> Version | bool:
    return verify_compiler_version() if os.path.isfile(os.path.join(CWD, COMPILER_GSCTOOL)) else False


def verify_compiler_version() -> Version:
    compiler: subprocess.CompletedProcess = wrap_subprocess_call(COMPILER_GSCTOOL, cli_output=False)
    lines: list[str] = compiler.stdout.split("\n")
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


def main() -> None:
    os.chdir(CWD)
    print(f"\nSet CWD to: {os.getcwd()}\n")

    # Util
    compiler: Version | bool = verify_compiler()
    if compiler is False:
        print(f"'{COMPILER_GSCTOOL}' compiler executable not found in '{CWD}'")
        sys.exit(1)
    print()

    # Clear up all previous files
    clear_files(os.path.join(CWD, PARSED_DIR), r".*")
    clear_files(os.path.join(CWD, COMPILED_DIR), r".*")

    gsc: Gsc = (Gsc()
        .load_file(os.path.join(CWD, B2OP))
        .check_whitespace()
        .check_debug()
    )

    # New pluto
    with Chunk("PLUTONIUM:"):
        gsc.save(
            os.path.join(CWD, B2OP), {"#define PLUTO 0": "#define PLUTO 1"}
        )
        wrap_subprocess_call(
            COMPILER_GSCTOOL, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP, eval_callback=check_gsc_error
        )
        wrap_subprocess_call(
            COMPILER_GSCTOOL, "-m", MODE_COMP, "-g", GAME_COMP, "-s", "pc", arg_path(CWD, PARSED_DIR, B2OP), eval_callback=check_gsc_error
        )
        file_rename(
            os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, "b2op_precompiled_pluto.gsc")
        )
        file_rename(
            os.path.join(CWD, COMPILED_DIR, B2OP), os.path.join(CWD, COMPILED_DIR, "b2op-plutonium.gsc")
        )

        flash_hash(os.path.join(CWD, COMPILED_DIR, "b2op-plutonium.gsc"))

        if COMPILE_TANK_PATCH:
            gsc_origins: Gsc = Gsc().load_file(os.path.join(CWD, B2OP_TOMB)).check_whitespace()

            gsc_origins.save(
                os.path.join(CWD, B2OP_TOMB), {}
            )
            wrap_subprocess_call(
                COMPILER_GSCTOOL, "-m", MODE_COMP, "-g", GAME_COMP, "-s", "pc", B2OP_TOMB, eval_callback=check_gsc_error
            )
            file_rename(
                os.path.join(CWD, COMPILED_DIR, B2OP_TOMB), os.path.join(CWD, COMPILED_DIR, "b2op-tomb.gsc")
            )
            create_zipfile(
                os.path.join(CWD, COMPILED_DIR, "b2op-tomb.zip"), 
                os.path.join(CWD, COMPILED_DIR, "b2op-tomb.gsc"),
                os.path.join("zm_tomb", "b2op-tomb-plutonium.gsc")
            )

            flash_hash(os.path.join(CWD, COMPILED_DIR, "b2op-tomb.gsc"))

    # Redacted
    with Chunk("REDACTED:"):
        gsc.save(
            os.path.join(CWD, B2OP), {"#define REDACTED 0": "#define REDACTED 1"}
        )
        wrap_subprocess_call(
            COMPILER_GSCTOOL, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP, eval_callback=check_gsc_error
        )
        file_rename(
            os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, COMPILED_DIR, "b2op-redacted.gsc")
        )

        flash_hash(os.path.join(CWD, COMPILED_DIR, "b2op-redacted.gsc"))

    # Ancient
    with Chunk("ANCIENT:"):
        gsc.save(
            os.path.join(CWD, B2OP), {"#define ANCIENT 0": "#define ANCIENT 1"}
        )
        wrap_subprocess_call(
            COMPILER_GSCTOOL, "-m", MODE_PARSE, "-g", GAME_PARSE, "-s", "pc", B2OP, eval_callback=check_gsc_error
        )
        wrap_subprocess_call(
            COMPILER_GSCTOOL, "-m", MODE_COMP, "-g", GAME_COMP, "-s", "pc", arg_path(CWD, PARSED_DIR, B2OP), eval_callback=check_gsc_error
        )
        file_rename(
            os.path.join(CWD, PARSED_DIR, B2OP), os.path.join(CWD, PARSED_DIR, "b2op_precompiled_ancient.gsc")
        )
        file_rename(
            os.path.join(CWD, COMPILED_DIR, B2OP), os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc")
        )
        create_zipfile(
            os.path.join(CWD, COMPILED_DIR, "b2op-ancient.zip"), 
            os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"),
            os.path.join(ZMUTILITY_DIR, "_zm_utility.gsc")
        )

        flash_hash(os.path.join(CWD, COMPILED_DIR, "b2op-ancient.gsc"))

    # Warn if release has debugger enabled
    if gsc.debugger:
        print(f"WARNING!!! Debugger is enabled")

    # Reset file
    gsc.save(os.path.join(CWD, B2OP), {"#define RAW 0": "#define RAW 1"})


if __name__ == "__main__":
    main()
