#!/usr/bin/env bash
# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only

# This script installs vxworks libs and toolchain.

set -ex

# shellcheck source=../unix/InstallFromCompressedFileFromURL.sh
source "${BASH_SOURCE%/*}/../unix/InstallFromCompressedFileFromURL.sh"
# shellcheck source=../unix/SetEnvVar.sh
source "${BASH_SOURCE%/*}/../unix/SetEnvVar.sh"

VXWORKS_VER="23_09"
######### VXworks libs #########
# Installs to /opt/vxworks
PrimaryUrl="http://ci-files01-hki.ci.qt.io/input/vxworks/vxworks_no_source_patched_$VXWORKS_VER.tar.gz"
AltUrl=""
sha1="35a457999b310a6128e3bd7de3103c2235063071"
targetFolder="/opt/"
InstallFromCompressedFileFromURL "$PrimaryUrl" "$AltUrl" "$sha1" "$targetFolder" ""
SetEnvVar "VXWORKS_HOME" "/opt/vxworks"

VXWORKS_BUILD_VER="final_20231123"
######### VXworks toolchain #########
# Installs to /opt/fsl_imx6_2_0_6_2_VSB
PrimaryUrl="http://ci-files01-hki.ci.qt.io/input/vxworks/vxworks_vsb_$VXWORKS_BUILD_VER.tar.gz"
AltUrl=""
sha1="2d52eeae4699668edffba541fde54cd2ba8ecc9b"
targetFolder="/opt/"
InstallFromCompressedFileFromURL "$PrimaryUrl" "$AltUrl" "$sha1" "$targetFolder" ""
SetEnvVar "WIND_CC_SYSROOT" "/opt/fsl_imx6_2_0_6_2_VSB"

######### VXworks VIP kernel #########
# Installs to /opt/fsl_imx6_2_0_6_2_VIP_QEMU
PrimaryUrl="http://ci-files01-hki.ci.qt.io/input/vxworks/vxworks_vip_kernel_${VXWORKS_BUILD_VER}_3.tar.gz"
AltUrl=""
sha1="7a55dc7ba13d26a11d3c614f104aa7382c00b601"
targetFolder="/opt/"
InstallFromCompressedFileFromURL "$PrimaryUrl" "$AltUrl" "$sha1" "$targetFolder" ""

SetEnvVar "VXWORKS_SSH" "WindRiver@10.0.2.4"

# Setup NFS exports that are needed by VxWorks qemu
sudo bash -c "echo '/home/qt/work 10.0.2.4/24(rw,sync,root_squash,no_subtree_check,anonuid=1000,anongid=1000)' >> /etc/exports"
sudo bash -c "echo '/opt/fsl_imx6_2_0_6_2_VSB 10.0.2.4/24(rw,sync,root_squash,no_subtree_check,anonuid=1000,anongid=1000)' >> /etc/exports"
sudo exportfs -a

# Copy start script in place
cp "${BASH_SOURCE%/*}/../linux/vxworks_qemu_launcher.sh" "${HOME}"
SetEnvVar "VXWORKS_EMULATOR" "${HOME}/vxworks_qemu_launcher.sh"
