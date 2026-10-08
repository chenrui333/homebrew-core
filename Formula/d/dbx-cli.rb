class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.110.tar.gz"
  sha256 "0bd53e76570d6359eacd73a6c68dc4180faf7d15c1a325ea6898faa32e05dc63"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d738ec37cf46128d86fff70d7e149950744e0470d1d54f34be3d829f2540c422"
    sha256 cellar: :any, arm64_tahoe:       "0876d0297d3409647f0fa07a3cf843da072c468b9197bb5659c2d6b9b7912c9c"
    sha256 cellar: :any, arm64_sequoia:     "63078eb2b7415f25844f8d6c2e9b70e0ed48869df20685509fc0c6863377d0dc"
    sha256 cellar: :any, arm64_linux:       "e86650a680610d2cd6aff8b352cf80259f124179fbf0f1bbd56dedcf1e017ff1"
    sha256 cellar: :any, x86_64_linux:      "ff3b19cac1fbfd5e4fde246cb0ec31f972bbca5a0370856c8eca9bea5d869080"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
