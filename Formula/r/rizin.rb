class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.0/rizin-src-v0.7.0.tar.xz"
  sha256 "fc6734320d88b9e2537296aa0364a3c3b955fecc8d64dda26f1f3ede7c8d6c31"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sonoma:   "6a02ff9082c7fef57a7813200d2cae47e0c1a257ade2ce263306063fc4324837"
    sha256 arm64_ventura:  "e482f300af3190ecec4d78739648915e3993944c76e87c3826fcc7f353a76d60"
    sha256 arm64_monterey: "6c9df7bc34edd2ca6371e0a79c055a1e416a3974d9787067e1219f19eb07090e"
    sha256 sonoma:         "9d72ef15a4004739978d7afee2864e3410a907dfe806d2e50f94660ac7962f49"
    sha256 ventura:        "061a4a6b5d494c6eaeba008cc8fbb66f0a4f28e71ee274d7d3b8916751a8c957"
    sha256 monterey:       "29e63fc95ec43077fd1f7fc7fe4b4ab21609f4e4a656e0807a04d5aa3b440942"
    sha256 x86_64_linux:   "fa252b3ccbabd010acdd1ed41053f96aac05054c0d640304bdcbabbc325c76c1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = %W[
      -Dpackager=#{tap.user}
      -Dpackager_version=#{pkg_version}
      -Duse_sys_capstone=enabled
      -Duse_sys_libzip_openssl=true
      -Duse_sys_libzip=enabled
      -Duse_sys_libzstd=enabled
      -Duse_sys_lz4=enabled
      -Duse_sys_lzma=enabled
      -Duse_sys_magic=enabled
      -Duse_sys_openssl=enabled
      -Duse_sys_pcre2=enabled
      -Duse_sys_xxhash=enabled
      -Duse_sys_zlib=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
      --wrap-mode=nodownload
    ]

    if OS.mac?
      args << "--force-fallback-for=rzgdb,rzwinkd,rzar,rzqnx,tree-sitter-c,rzspp,rizin-shell-parser,rzheap"
    else
      args << "--force-fallback-for=rzgdb,rzwinkd,rzar,rzqnx,tree-sitter-c,rzspp,rizin-shell-parser,rzheap,ptrace-wrap"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/rizin/plugins").mkpath
  end

  def caveats
    <<~EOS
      Plugins, extras and bindings will installed at:
        #{HOMEBREW_PREFIX}/lib/rizin
    EOS
  end

  test do
    assert_match "rizin #{version}", shell_output("#{bin}/rizin -v")
    assert_match "2a00a0e3", shell_output("#{bin}/rz-asm -a arm -b 32 'mov r0, 42'")
    assert_match "push rax", shell_output("#{bin}/rz-asm -a x86 -b 64 -d 0x50")
  end
end
