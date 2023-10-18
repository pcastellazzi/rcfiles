#!/usr/bin/env python3

"""
You should probably use `brew uninstall` and `brew autoremove` now
"""

import argparse
import logging
import subprocess

LOGGER = logging.getLogger("brew-recursive-uninstall")


class UninstallError(Exception):
    pass


def sh(*args):
    return subprocess.check_output(args).decode().splitlines()


def uninstall(formula):
    dependees = sh("brew", "uses", "--installed", formula)
    if len(dependees) > 0:
        raise UninstallError(f"Package {formula} is neded by {', '.join(dependees)}")

    current_leaves = set(sh("brew", "leaves"))
    expected_leaves = current_leaves - set([formula])

    possible_unused = current_leaves - expected_leaves
    while len(possible_unused) > 0:
        for f in possible_unused:
            dependees = sh("brew", "uses", "--installed", formula)
            if len(dependees) > 0:
                LOGGER.info("Keeping %s, used by %s", f, ", ".join(dependees))
            else:
                LOGGER.info("Removing %s ...", f)
                sh("brew", "uninstall", f)
        possible_unused = set(sh("brew", "leaves")) - expected_leaves


def main(argv=None):
    parser = argparse.ArgumentParser(
        prog="brew-recursive-uninstall",
        description="Recursively uninstall a package with all its unused dependencies",
    )
    parser.add_argument(
        "packages", metavar="package", type=str, nargs="+", help="package to uninstall",
    )
    args = parser.parse_args(argv)

    try:
        for package in args.packages:
            uninstall(package)
        LOGGER.info("Done.")
        return 0
    except UninstallError as exc:
        LOGGER.error(exc)
        return 127
    except subprocess.CalledProcessError as exc:
        LOGGER.error(exc)
        return exc.returncode


if __name__ == "__main__":
    import sys

    logging.basicConfig(
        datefmt="%Y-%m-%d %H:%M:%S",
        format="%(asctime)s [%(levelname)s] %(message)s",
        level=logging.INFO,
    )

    sys.exit(main() or 0)

