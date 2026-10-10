class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "a044c594c0492cc96b48e6f32080cfbd4e9154229647ed29f16ef5caed033208"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ed02d4fbaec1df37883d93751d45ec6b287e959a62075e9757e28dc60cbd970"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d96c21b3a5460e1f0408a2047b1fc484e4074daf9de5776484395ebedab2d8e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d63c9f8a494c6f4087c1a4612ae14fde97a1f8d89126d1ba1978324201b5912d"
    sha256 cellar: :any,                 arm64_linux:       "839f63ee589971f0b35131de3edb60df0fa5319e426d8b2d9065b29df3e82866"
    sha256 cellar: :any,                 x86_64_linux:      "bf6d8f17048485bc3a7732258956cd3d77d4daa917c1c4ed061db98b7e155cc7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  resource "grin" do
    url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.2.tar.gz"
    sha256 "df68a9496db18f6f1e6e286a95ecdc5f3d25de38affe9872c650b4b004c1e2d3"
  end

  deny_network_access!

  def fetch
    resource("grin").stage buildpath/"grin"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end
