#!/bin/bash
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

set -Euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_ROOT="$SCRIPT_DIR/../.."
TARGET_LIB="$PROJECT_ROOT/install/local"
ARCHIVE_NAME="otobo-deps-11.0-rhel-9.7.tar.gz"
# Directory at /opt/otobo to compress to tar.gz
ARCHIVE_DIR="install"

SUDO=''
if [ "$EUID" -ne 0 ]; then
    echo "Führe Installationen mit sudo-Rechten aus..."
    SUDO='sudo'
fi

# 2. cpanm prüfen und ggf. installieren
if ! command -v cpanm &> /dev/null; then
    echo "cpanm not found. Installing using dnf..."
    $SUDO dnf install -y perl-App-cpanminus
else
    echo "cpanm is already present. Skipping installation."
fi

# 3. carton prüfen und ggf. installieren
if ! command -v carton &> /dev/null; then
    echo "carton not found. Installing using cpanm..."
    $SUDO cpanm Carton
else
    echo "carton is already present. Skipping installation."
fi

cd "$PROJECT_ROOT"

if [ -d "$TARGET_LIB" ]; then
   echo "$TARGET_LIB already exists. Skipping."
else
   echo "Creating $TARGET_LIB ..."
   mkdir -p "$TARGET_LIB/lib/perl5"
fi

PERL5LIB="$PROJECT_ROOT/install/local/lib/perl5"

if [ -f "cpanfile.plackup" ]; then
    echo "Installing dependencies to $TARGET_LIB..."
    carton install --path "$TARGET_LIB" --cpanfile cpanfile.plackup
else
    echo "Error: Couldn't find cpanfile.plackup in $PROJECT_ROOT!"
    exit 1
fi

# Make binaries executable
chmod +x ${TARGET_LIB}/bin/*

tar -zcf ${ARCHIVE_NAME} -C . ${ARCHIVE_DIR}
echo "Saved modules directory under ${PROJECT_ROOT}/${ARCHIVE_NAME}"
