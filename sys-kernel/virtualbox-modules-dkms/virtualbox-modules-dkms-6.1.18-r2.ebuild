# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit eutils unpacker

MY_PN=virtualbox-dkms
DESCRIPTION="Kernel Modules source for Virtualbox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/multiverse/v/virtualbox/${MY_PN}_${PV}-dfsg-2_amd64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	sys-apps/ethtool
	sys-kernel/dkms
"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/kernel-5.11.patch
)

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default
	grep -lR linux/autoconf.h *  | xargs sed -i -e 's:<linux/autoconf.h>:<generated/autoconf.h>:'
	sed -i "s/virtualbox/${PN}/g" usr/src/virtualbox-${PV}/dkms.conf
	sed -i "s/updates/extra\/dkms/g" usr/src/virtualbox-${PV}/dkms.conf
}

src_compile() {
	:
}

src_install() {
	dodir usr/src/${P}
	insinto usr/src/${P}
	doins -r ${S}/usr/src/virtualbox-${PV}/*
}

pkg_postinst() {
	dkms add ${PN}/${PV}
}

pkg_prerm() {
	dkms remove ${PN}/${PV} --all
}
