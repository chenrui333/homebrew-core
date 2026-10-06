class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.102.tar.gz"
  sha256 "6aeea1d13bd6baf6440c044dd36a99866dc6d68e737b4e3114524cafa815c48c"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "d783d241ed54dc1b49c7cfb3195761886dbc72149dd48491fb96a029821fddec"
    sha256 arm64_tahoe:       "35890c679b98a317980a90193df8e1f8c5c73b45fc6e9f09b9e15fd05fb27e75"
    sha256 arm64_sequoia:     "150b7ef2865eea497b7867a51cc95d201e5bb87a82acefd8e5f54383e2438717"
    sha256 arm64_linux:       "d3f304575723a47e6b97825e13bc867e372628d85293bf9789715706e8c44c1d"
    sha256 x86_64_linux:      "479a5232632a9a04a0327ce1f0373d16d89bfcde68e1ca21f73403cc72ec452b"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://github.com/veg/hyphy/commit/f3fbdf2db77c9f5d32d868d60780c893c857348e.patch?full_index=1"
    sha256 "c8662c672ff3b44e276ae908115389ea647b019480d6d2a0a91397fe246ce47c"
    type :unofficial
    resolves "https://github.com/veg/hyphy/pull/2030"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyphy --version")

    cp pkgshare/"data/p51.nex", testpath
    system bin/"hyphy", "slac", "--alignment", "p51.nex"
    assert_path_exists "p51.nex.SLAC.json"
  end
end
