class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.111.tar.gz"
  sha256 "4329c07f926d0738775ba43bf8c3531f4d377d3f5f2a36e5dff7207f9a281664"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f20e8c9eb67cca3e57f9ceb17e95cb6120421622dd04f07c0be8c3873ddc4935"
    sha256 cellar: :any, arm64_tahoe:       "546f856fc5f75a93c7d515bbba9539b394c968992816bb4723688221dd32ff88"
    sha256 cellar: :any, arm64_sequoia:     "8635671253159ec6b9378b02dd5c940dfe27847669be3213d6ac8c65ede4507d"
    sha256 cellar: :any, arm64_linux:       "6720c9ef5be7b11997ce6cc083f1d17b36bb69c8d8328f238e32b736a8ba08cf"
    sha256 cellar: :any, x86_64_linux:      "1e59ed0a8cfbf9c63fc9938cd1c0b458ba900646fbf7cea963d46481b33bdcde"
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
