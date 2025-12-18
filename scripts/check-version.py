#!/usr/bin/env python3
"""
Check for the latest Fiduswriter version in the 4.0.x series from PyPI.

This script queries the PyPI JSON API to find the latest version in the 4.0.x
series and compares it with the current version in the Dockerfile.
"""

import json
import re
import sys
import urllib.request
from typing import List, Optional, Tuple


def get_latest_version_from_pypi(series: str = "4.0") -> Optional[str]:
    """
    Get the latest Fiduswriter version from PyPI for a specific series.
    
    Args:
        series: Version series to check (e.g., "4.0")
        
    Returns:
        Latest version string or None if not found
    """
    try:
        url = "https://pypi.org/pypi/fiduswriter/json"
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read())
            versions = list(data['releases'].keys())
            
            # Filter for versions in the specified series
            pattern = re.compile(rf'^{re.escape(series)}\.\d+$')
            series_versions = [v for v in versions if pattern.match(v)]
            
            # Sort versions by converting to tuples of integers
            series_versions.sort(key=lambda s: [int(u) for u in s.split('.')])
            
            if series_versions:
                return series_versions[-1]
            return None
    except Exception as e:
        print(f"Error fetching version from PyPI: {e}", file=sys.stderr)
        return None


def get_current_version_from_dockerfile(dockerfile_path: str = "Dockerfile") -> Optional[str]:
    """
    Extract the current Fiduswriter version from the Dockerfile.
    
    Args:
        dockerfile_path: Path to the Dockerfile
        
    Returns:
        Current version string or None if not found
    """
    try:
        with open(dockerfile_path, 'r') as f:
            content = f.read()
            match = re.search(r'ARG FIDUSWRITER_VERSION=([0-9.]+)', content)
            if match:
                return match.group(1)
            return None
    except FileNotFoundError:
        print(f"Error: Dockerfile not found at {dockerfile_path}", file=sys.stderr)
        return None
    except Exception as e:
        print(f"Error reading Dockerfile: {e}", file=sys.stderr)
        return None


def parse_version(version: str) -> Tuple[int, ...]:
    """
    Parse a version string into a tuple of integers.
    
    Args:
        version: Version string (e.g., "4.0.17")
        
    Returns:
        Tuple of integers (e.g., (4, 0, 17))
    """
    return tuple(int(x) for x in version.split('.'))


def compare_versions(v1: str, v2: str) -> int:
    """
    Compare two version strings.
    
    Args:
        v1: First version string
        v2: Second version string
        
    Returns:
        -1 if v1 < v2, 0 if v1 == v2, 1 if v1 > v2
    """
    parts1 = parse_version(v1)
    parts2 = parse_version(v2)
    
    if parts1 < parts2:
        return -1
    elif parts1 > parts2:
        return 1
    else:
        return 0


def get_all_versions_in_series(series: str = "4.0") -> List[str]:
    """
    Get all available versions in a series from PyPI.
    
    Args:
        series: Version series to check (e.g., "4.0")
        
    Returns:
        List of version strings
    """
    try:
        url = "https://pypi.org/pypi/fiduswriter/json"
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read())
            versions = list(data['releases'].keys())
            
            # Filter for versions in the specified series
            pattern = re.compile(rf'^{re.escape(series)}\.\d+$')
            series_versions = [v for v in versions if pattern.match(v)]
            
            # Sort versions
            series_versions.sort(key=lambda s: [int(u) for u in s.split('.')])
            
            return series_versions
    except Exception as e:
        print(f"Error fetching versions from PyPI: {e}", file=sys.stderr)
        return []


def main():
    """Main function to check and report version information."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Check for the latest Fiduswriter version from PyPI"
    )
    parser.add_argument(
        "--series",
        default="4.0",
        help="Version series to check (default: 4.0)"
    )
    parser.add_argument(
        "--dockerfile",
        default="Dockerfile",
        help="Path to Dockerfile (default: Dockerfile)"
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List all available versions in the series"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output results in JSON format"
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Only output version numbers"
    )
    
    args = parser.parse_args()
    
    if args.list:
        versions = get_all_versions_in_series(args.series)
        if args.json:
            print(json.dumps({"series": args.series, "versions": versions}, indent=2))
        else:
            if not args.quiet:
                print(f"Available versions in {args.series}.x series:")
            for version in versions:
                print(version)
        return 0
    
    # Get current version from Dockerfile
    current_version = get_current_version_from_dockerfile(args.dockerfile)
    
    # Get latest version from PyPI
    latest_version = get_latest_version_from_pypi(args.series)
    
    if args.json:
        result = {
            "current_version": current_version,
            "latest_version": latest_version,
            "update_available": False,
            "series": args.series
        }
        
        if current_version and latest_version:
            comparison = compare_versions(current_version, latest_version)
            result["update_available"] = comparison < 0
            result["is_current"] = comparison == 0
            result["is_ahead"] = comparison > 0
        
        print(json.dumps(result, indent=2))
        return 0
    
    if args.quiet:
        if latest_version:
            print(latest_version)
        return 0
    
    # Display results
    print("=" * 60)
    print("Fiduswriter Version Check")
    print("=" * 60)
    
    if current_version:
        print(f"Current version (Dockerfile): {current_version}")
    else:
        print("Current version: Not found in Dockerfile")
    
    if latest_version:
        print(f"Latest version (PyPI):        {latest_version}")
    else:
        print(f"Latest version: Not found on PyPI (series {args.series}.x)")
        return 1
    
    print("=" * 60)
    
    # Compare versions
    if current_version and latest_version:
        comparison = compare_versions(current_version, latest_version)
        
        if comparison < 0:
            print(f"⚠️  UPDATE AVAILABLE: {current_version} → {latest_version}")
            print("\nTo update, run:")
            print(f"  sed -i 's/ARG FIDUSWRITER_VERSION=.*/ARG FIDUSWRITER_VERSION={latest_version}/' Dockerfile")
            print("  make build")
            return 1
        elif comparison == 0:
            print(f"✅ You are using the latest version ({current_version})")
            return 0
        else:
            print(f"ℹ️  You are ahead of the latest PyPI version")
            print(f"   (Current: {current_version}, PyPI: {latest_version})")
            return 0
    
    return 1


if __name__ == "__main__":
    sys.exit(main())