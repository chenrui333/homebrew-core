class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.2.tar.gz"
  sha256 "df68a9496db18f6f1e6e286a95ecdc5f3d25de38affe9872c650b4b004c1e2d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c773339ceb71b6d4a9d759fa9601a2844f80e022916505abe0897168702c62bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f19fdcf9f187549dd49da11a12cf7dce574f6b5d89e9d3c50c35bfc8ecf5621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "087eb7a38ce5d960588c7c0f5e417141e7ff8764208790affeb663b1fade6fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0665dd3c9d4846b9156a4129ece161d40611e78cac9da5a23ba17790c56dd8ed"
    sha256 cellar: :any_skip_relocation, sonoma:            "c396b818b315c432e5aa96af427e29c37afc090b6f36c0ced3dd56acab8bb4e1"
    sha256 cellar: :any,                 arm64_linux:       "a1bfe1f7d0060adee98297ad8b0c621f451feefad909fb630b4a1c60968d89e0"
    sha256 cellar: :any,                 x86_64_linux:      "0f9912baebe58e3fd17887cffcc4e7737641ad4eced6920b42ca82fc9b838969"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end
