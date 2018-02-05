# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtwidgets-${PV}
	>=sys-libs/zlib-1.2.5
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtxml-${PV} )
"
