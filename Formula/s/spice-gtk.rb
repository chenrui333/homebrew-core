class SpiceGtk < Formula
  include Language::Python::Virtualenv

  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.43.tar.xz"
  sha256 "cee26e5b2d22909f35b40a94398d1e863ca3962ee46494ca97aab206abc3203b"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://www.spice-space.org/download/gtk/"
    regex(/href=.*?spice-gtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 arm64_golden_gate: "94daa7294ec7bb061de72fa11f8ef6db96932dda6ba58399e477bc8b3863dc21"
    sha256 arm64_tahoe:       "21eceed114b1e4ffa0448d21508d99d2c93ae878325b9b51c146ced4181a31fd"
    sha256 arm64_sequoia:     "249a4261f91fe205b61e1636440d889def5f5e4aec5ffd19821caf0a9e743dea"
    sha256 arm64_sonoma:      "73b27a8348177262ab9e24628a0139163cfbf8cf264457c504ac1ddd145cbf8b"
    sha256 sonoma:            "aac4c0b6608b911ac73ca8960add7a8bda7f5f3a316f83430b588140c39b011a"
    sha256 arm64_linux:       "2a66a37b796347b663e8f75fafe1f47589c091b9a5267c2f78fbb361ecb0d906"
    sha256 x86_64_linux:      "83c56974836f7c0159133c7058c58fd32b087e2e0fcdd1503abf8c3d86bb55a0"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libepoxy"
  depends_on "libsoup"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "phodav"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  on_macos do
    depends_on "gettext"
    depends_on "gobject-introspection"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cyrus-sasl"
    depends_on "libva"
    depends_on "systemd" # for libudev
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: "pyparsing"

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  # Fix macOS DRM header usage, upstream PR ref, https://gitlab.freedesktop.org/spice/spice-gtk/-/merge_requests/158
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-gtk/-/commit/02377912fe173e4af7714aef036d0555ee7531bc.diff"
    sha256 "f2cc068e62d4310825f1107820fefb4c29c318acd45cabc4247528a91f7945be"
    type :unofficial
    resolves "https://gitlab.freedesktop.org/spice/spice-gtk/-/merge_requests/158"
  end

  # https://gitlab.com/keycodemap/keycodemapdb/-/merge_requests/18
  patch :DATA

  allow_network_access! :build

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <spice-client.h>
      #include <spice-client-gtk.h>
      int main() {
        return spice_session_new() ? 0 : 1;
      }
    CPP
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@3")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("icu4c")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("systemd")/"pkgconfig" if OS.linux?
    system ENV.cc, "test.cpp",
                   *shell_output("pkgconf --cflags --libs spice-client-gtk-3.0").chomp.split,
                   "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/subprojects/keycodemapdb/tools/keymap-gen b/subprojects/keycodemapdb/tools/keymap-gen
index b6cc95b..d05e945 100755
--- a/subprojects/keycodemapdb/tools/keymap-gen
+++ b/subprojects/keycodemapdb/tools/keymap-gen
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 # -*- python -*-
 #
 # Keycode Map Generator
