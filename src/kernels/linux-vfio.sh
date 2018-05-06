# For build.sh
mode_name="vfio"
package_base="linux-vfio"
mode_desc="Select and use the packages for the linux-vfio kernel"

# Kernel versions for default ZFS packages
pkgrel="1"
kernel_version="4.16.5-1"

# Kernel version for GIT packages
pkgrel_git="${pkgrel}"
kernel_version_git="${kernel_version}"
zfs_git_commit=""
spl_git_commit=""
zfs_git_url="https://github.com/zfsonlinux/zfs.git"
spl_git_url="https://github.com/zfsonlinux/spl.git"

header="\
# Maintainer: Jesus Alvarez <jeezusjr at gmail dot com>
#
# This PKGBUILD was generated by the archzfs build scripts located at
#
# http://github.com/archzfs/archzfs
#
# ! WARNING !
#
# The archzfs packages are kernel modules, so these PKGBUILDS will only work with the kernel package they target. In this
# case, the archzfs-linux-vfio packages will only work with the default linux-vfio package! To have a single PKGBUILD target many
# kernels would make for a cluttered PKGBUILD!
#
# If you have a custom kernel, you will need to change things in the PKGBUILDS. If you would like to have AUR or archzfs repo
# packages for your favorite kernel package built using the archzfs build tools, submit a request in the Issue tracker on the
# archzfs github page.
#"

update_linux_pkgbuilds() {
    pkg_list=("spl-linux-vfio" "zfs-linux-vfio")
    kernel_version_full=$(kernel_version_full ${kernel_version})
    kernel_version_full_pkgver=$(kernel_version_full_no_hyphen ${kernel_version})
    kernel_version_major=${kernel_version%-*}
    kernel_mod_path="${kernel_version_full}-vfio"
    archzfs_package_group="archzfs-linux-vfio"
    spl_pkgver=${zol_version}.${kernel_version_full_pkgver}
    zfs_pkgver=${zol_version}.${kernel_version_full_pkgver}
    spl_pkgrel=${pkgrel}
    zfs_pkgrel=${pkgrel}
    spl_conflicts="'spl-linux-vfio-git'"
    zfs_conflicts="'zfs-linux-vfio-git'"
    spl_utils_pkgname="spl-utils-common=${zol_version}"
    spl_pkgname="spl-linux-vfio"
    zfs_utils_pkgname="zfs-utils-common=${zol_version}"
    zfs_pkgname="zfs-linux-vfio"
    # Paths are relative to build.sh
    spl_pkgbuild_path="packages/${kernel_name}/${spl_pkgname}"
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    spl_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-${zol_version}/spl-${zol_version}.tar.gz"
    zfs_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-${zol_version}/zfs-${zol_version}.tar.gz"
    spl_workdir="\${srcdir}/spl-${zol_version}"
    zfs_workdir="\${srcdir}/zfs-${zol_version}"
    linux_depends="\"linux-vfio=${kernel_version_full}\""
    linux_headers_depends="\"linux-vfio-headers=${kernel_version_full}\""
    zfs_makedepends="\"${spl_pkgname}-headers\""
}

update_linux_git_pkgbuilds() {
    pkg_list=("spl-linux-vfio-git" "zfs-linux-vfio-git")
    kernel_version=${kernel_version_git}
    kernel_version_full=$(kernel_version_full ${kernel_version})
    kernel_version_full_pkgver=$(kernel_version_full_no_hyphen ${kernel_version})
    kernel_version_major=${kernel_version%-*}
    kernel_mod_path="${kernel_version_full}-vfio"
    archzfs_package_group="archzfs-linux-vfio-git"
    spl_pkgver="" # Set later by call to git_calc_pkgver
    zfs_pkgver="" # Set later by call to git_calc_pkgver
    spl_pkgrel=${pkgrel_git}
    zfs_pkgrel=${pkgrel_git}
    spl_conflicts="'spl-linux-vfio'"
    zfs_conflicts="'zfs-linux-vfio'"
    spl_pkgname="spl-linux-vfio-git"
    zfs_pkgname="zfs-linux-vfio-git"
    spl_pkgbuild_path="packages/${kernel_name}/${spl_pkgname}"
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    spl_src_target="git+${spl_git_url}"
    if [[ ${spl_git_commit} != "" ]]; then
        spl_src_target="git+${spl_git_url}#commit=${spl_git_commit}"
    fi
    spl_src_hash="SKIP"
    linux_depends="\"linux-vfio=${kernel_version_full}\""
    linux_headers_depends="\"linux-vfio-headers=${kernel_version_full}\""
    spl_makedepends="\"git\""
    zfs_src_target="git+${zfs_git_url}"
    if [[ ${zfs_git_commit} != "" ]]; then
        zfs_src_target="git+${zfs_git_url}#commit=${zfs_git_commit}"
    fi
    zfs_src_hash="SKIP"
    zfs_makedepends="\"git\" \"${spl_pkgname}-headers\""
    spl_workdir="\${srcdir}/spl"
    zfs_workdir="\${srcdir}/zfs"
    if have_command "update"; then
        git_check_repo
        git_calc_pkgver
    fi
    spl_utils_pkgname="spl-utils-common-git>=${spl_git_ver}"
    zfs_utils_pkgname="zfs-utils-common-git>=${zfs_git_ver}"
}
