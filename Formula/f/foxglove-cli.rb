class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "491085b6ee1e4213ab54e83154fda16a9571d1568cab81d5fa5b334bcb1428f2"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66c886f8fc73a9fd852ebc8fe3cea4b2feeca82a665ea46c34ffaba746cabc1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c11717d5376602edb22ca0002efc24ca1b35982c70eb30a45c7813df5382079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f95c1648f179f81ac9fe4ff086bb5c1a99e502790c1fd815342b1c3454b4632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "720e3a095bfe4b4a3a9a05cd4cec003f8810aa823b008b4839ede06acdfb6a8e"
    sha256 cellar: :any_skip_relocation, sonoma:            "5c6d7bb3e91a04f91de9b82eec09934f251752741e24907b532325feb3c882e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86fe10a3a6049e3eb7bee553836ac3a08e56f44282769f5897b3618e4a8bfcd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2164d17f3e10fce829f84b76c6ee0e3adea053aee576a1743ed5a1307600324d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["FOXGLOVE_VERSION"] = version.to_s
    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
    mv bin/"foxglove-rust", bin/"foxglove"
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
