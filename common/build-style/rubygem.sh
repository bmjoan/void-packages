#
# This helper is for templates installing ruby gems.
#

do_extract() {
	# Gem file need not be unpacked prior install phase
	mkdir -p "$wrksrc"
}

do_install() {
	local _gemdir=$(ruby -e 'puts Gem.default_dir')

	# `--ignore-dependencies' would require development dependencies
	# to be also installed before template generating
	# gem install --ignore-dependencies --no-user-install \
	gem install --minimal-deps --no-user-install \
	    -i "${PKGDESTDIR}/${_gemdir}" -n "${PKGDESTDIR}/usr/bin" \
	    "${XBPS_SRCDISTDIR}/${pkgname}-${version}/${_gemname}-${version}.gem"
	for distfile in ${distfiles}; do
	    rm -f "${PKGDESTDIR}/${_gemdir}/cache/${distfile##*/}"
	done
}

post_install() {
	if [ -n "$_gemlicfile" ]; then
	    local _gemdir=$(ruby -e 'puts Gem.default_dir')

	    vlicense "${PKGDESTDIR}/${_gemdir}/gems/${_gemname}-${version}/${_gemlicfile}"
	fi
}
