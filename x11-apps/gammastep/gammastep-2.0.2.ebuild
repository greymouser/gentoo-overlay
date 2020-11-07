# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Adjust the color temperature of your screen according to your surroundings."
HOMEPAGE="https://gitlab.com/chinstrap/${PN}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/chinstrap/${PN}.git"
else
	SRC_URI="https://gitlab.com/chinstrap/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+drm +wayland xrandr vidmode geoclue gui"

DEPEND="
	drm? ( x11-libs/libdrm )
	wayland? ( dev-libs/wayland )
	xrandr? ( x11-libs/libxcb )
	dev-libs/glib
	dev-libs/libffi
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	./bootstrap
	econf \
		$(use_enable drm ) \
		$(use_enable wayland ) \
		$(use_enable xrandr randr ) \
		$(use_enable vidmode ) \
		$(use_enable geoclue geoclue2 ) \
		$(use_enable gui ) \
		--disable-apparmor
	sed -i -e 's/$(MAKE) $(AM_MAKEFLAGS) install-data-hook/$(MAKE) $(AM_MAKEFLAGS)/' \
		Makefile || die
}

pkg_postinst() {
        xdg_icon_cache_update
}
