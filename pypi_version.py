#!/usr/bin/env python
"""Based on answers to this SO question: https://stackoverflow.com/q/28774852/15592055"""
import json
from argparse import ArgumentParser
from urllib.request import urlopen

from packaging.version import parse as parse_version


def get_latest_pypi_version(package_name, include_prereleases=False):
    """Get the latest version of a package on PyPI, optionally including pre-releases"""
    response = urlopen(f'https://pypi.python.org/pypi/{package_name}/json')
    data = json.loads(response.read())
    versions = [parse_version(v) for v in data['releases']]

    if not include_prereleases:
        versions = [v for v in versions if not v.is_prerelease]
    return max(versions)


if __name__ == '__main__':
    parser = ArgumentParser(description='Get the latest version of a package on PyPI')
    parser.add_argument('package', help='Name of PyPI package to look up')
    parser.add_argument('-d', '--dev', help='Include dev (pre-release) versions', action='store_true')
    args = parser.parse_args()
    latest = get_latest_pypi_version(args.package, include_prereleases=args.dev)
    print(latest)
