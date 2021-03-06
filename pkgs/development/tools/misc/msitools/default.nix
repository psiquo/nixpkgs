{ lib, stdenv, fetchurl, intltool, glib, pkg-config, libgsf, libuuid, gcab, bzip2, gnome3 }:

stdenv.mkDerivation rec {
  pname = "msitools";
  version = "0.98";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19wb3n3nwkpc6bjr0q3f1znaxsfaqgjbdxxnbx8ic8bb5b49hwac";
  };

  nativeBuildInputs = [ intltool pkg-config ];
  buildInputs = [ glib libgsf libuuid gcab bzip2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = "https://wiki.gnome.org/msitools";
    license = [ licenses.gpl2 licenses.lgpl21 ];
    platforms = platforms.unix;
  };
}
