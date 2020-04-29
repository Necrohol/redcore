# Copyright 2016 Redcore Linux
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils

DESCRIPTION="Offical Redcore Linux Core Artwork"
HOMEPAGE="https://redcorelinux.org"
SRC_URI="http://mirror.math.princeton.edu/pub/redcorelinux/distfiles/${PN}.tar.xz"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+splash"
RDEPEND="sys-apps/findutils
	sys-boot/plymouth
	>=x11-themes/hicolor-icon-theme-0.10
	splash? (
		sys-kernel/dracut[splash]
	)"

S="${WORKDIR}"/"${PN}"

src_install() {
	# Cursors
	insinto usr/share/cursors/xorg-x11/
	doins -r mouse/Hacked-Red
	dosym ../../../../usr/share/cursors/xorg-x11/Hacked-Red usr/share/cursors/xorg-x11/default

	# Wallpapers
	insinto usr/share/backgrounds/
	doins -r background/nature

	# Logos
	insinto usr/share/pixmaps/
	doins logo/*.png

	# Plymouth theme
	if use splash; then
		insinto usr/share/plymouth
		doins plymouth/bizcom.png
		insinto usr/share/plymouth/themes
		doins -r plymouth/themes/redcore
	fi
}

_dracut_initramfs_regen() {
	if [ -x $(which dracut) ]; then
		dracut -N -f --no-hostonly-cmdline
	fi
}

pkg_postinst() {
	# regenerate initramfs to include plymouth theme changes
	if [ $(stat -c %d:%i /) == $(stat -c %d:%i /proc/1/root/.) ]; then
		_dracut_initramfs_regen
	fi
}
