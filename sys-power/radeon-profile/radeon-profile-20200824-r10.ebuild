# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Read current clocks of ATi/AMD Radeon cards"
HOMEPAGE="https://github.com/marazmista/radeon-profile"
if [[ "${PV}" == 99999999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/marazmista/radeon-profile.git"
else
	SRC_URI="https://github.com/marazmista/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE=""

S="${WORKDIR}/${P}/${PN}"

RDEPEND="
	dev-qt/qtcharts:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
	x11-libs/libXrandr
"

DEPEND="
	${RDEPEND}
	dev-qt/qtconcurrent:5
	media-libs/mesa[X(+)]
	x11-libs/libdrm
"

PATCHES=(
	"${FILESDIR}/${PN}-20200504-run_subdir.patch"
)

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user
	sed 's@TrayIcon;@@' -i extra/${PN}.desktop || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dobin ${FILESDIR}/${PN}-pkexec
	dodir usr/share/polkit-1/actions
	insinto usr/share/polkit-1/actions
	doins ${FILESDIR}/org.redcorelinux.radeon-profile.policy

	sed -i "s/Exec=radeon-profile/Exec=radeon-profile-pkexec/g" "${D}"/usr/share/applications/${PN}.desktop
	sed -i "s/Monitor;HardwareSettings;/Settings;/g" "${D}"/usr/share/applications/${PN}.desktop
}
