import argparse
import difflib
import errno
import os
import os.path
import typing

import rich
import rich.prompt
import rich.columns


HOME_DIR = os.path.expanduser("~")
DOTFILES_DIR = os.path.join(HOME_DIR, "dotfiles")


def clone(repo: str):
    try:
        os.rmdir(DOTFILES_DIR)
    except FileNotFoundError:
        pass
    except OSError as e:
        if e.errno != errno.ENOTEMPTY:
            raise e
        rich.print(DOTFILES_DIR)
        rich.print(
            rich.columns.Columns(os.listdir(DOTFILES_DIR), expand=True, equal=True)
        )
        if rich.prompt.Confirm.ask("Skip clone?", default=True):
            return
        else:
            raise e
    cmd = [
        "git",
        "clone",
        "--depth=1",
        "--recurse-submodules",
        "--shallow-submodules",
        repo,
        DOTFILES_DIR,
    ]
    rich.print("$", cmd := " ".join(cmd))
    assert not os.system(cmd)


IGNORE_RELPATHS = [".git", ".gitignore", ".gitmodules", ".jj", ".ruff_cache", ".venv"]


def walk(path: str) -> typing.Iterator[str]:
    for entry in os.scandir(path):
        relpath = os.path.relpath(entry.path, DOTFILES_DIR)
        if not relpath.startswith(".") or relpath in IGNORE_RELPATHS:
            continue
        if entry.is_dir():
            yield from walk(entry.path)
        else:
            yield relpath


def unsafe_link(src: str, dst: str, force=True):
    if force:
        os.remove(dst)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    os.symlink(src, dst)
    rich.print("Overwrote" if force else "Created", f"{dst} as a symlink to {src}")


def readlines(path: str) -> list[str]:
    try:
        with open(path) as f:
            return f.read().splitlines()
    except FileNotFoundError:
        return []


def link(src: str, dst: str):
    try:
        unsafe_link(src, dst, force=False)
        return
    except FileExistsError:
        pass
    try:
        if os.readlink(dst) == src:
            return
    except OSError as e:
        if e.errno != errno.EINVAL:
            raise e
    diff = "\n".join(
        difflib.unified_diff(readlines(dst), readlines(src), dst, src, lineterm="")
    )
    if not diff:
        unsafe_link(src, dst)
        return
    rich.print()
    rich.print(diff)
    match rich.prompt.Prompt.ask(
        "Skip link? [prompt.choices][(y)es/(r)etry/(o)verwrite]",
        choices=["y", "r", "o"],
        show_choices=False,
        default="y",
    ):
        case "y":
            pass
        case "r":
            link(src, dst)
        case "o":
            unsafe_link(src, dst)


def setup(repo: str):
    clone(repo)
    for relpath in walk(DOTFILES_DIR):
        link(os.path.join(DOTFILES_DIR, relpath), os.path.join(HOME_DIR, relpath))


DEFAULT_REPO = "https://github.com/avamsi/dotfiles"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "repo", nargs="?", default=DEFAULT_REPO, help=f"(default: {DEFAULT_REPO})"
    )
    setup(parser.parse_args().repo)


if __name__ == "__main__":
    main()
