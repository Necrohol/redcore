# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils bash-completion-r1

DESCRIPTION="Dynamic Kernel Module Support"
SRC_URI="https://github.com/dell/dkms/archive/2.3.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/dell/dkms"
LICENSE="GPL-2"
DEPEND=""
RDEPEND="sys-apps/gentoo-functions"
KEYWORDS="amd64"
SLOT="0"

src_prepare() {
	epatch ${FILESDIR}/${P}-dont-touch-configs.patch
	epatch ${FILESDIR}/${P}-gentoo-functions.patch
	epatch ${FILESDIR}/${P}-systemd-service-fix.patch
	epatch ${FILESDIR}/${P}-redcore-makefile.patch
}

src_install() {
	emake DESTDIR=${D} install
	newinitd "${FILESDIR}"/dkms.initd dkms
}
