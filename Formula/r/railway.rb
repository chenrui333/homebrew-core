class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.64.1.tar.gz"
  sha256 "33731567e3aeace859b02334a5a3ff757d9c97646892670def96eff2a8c9cc5f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6843083875921520959fb33c7da5dda188418a4d83594410d07dda92be72494"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f012e263e33f3c94e4fe9eb2bcc1a9f2394e9d5dc3fd22e924cae771016b699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ae93adfc08aab3fe3875d477cf06b82f39c2145b2a1aec8487459bfe9b801d3"
    sha256 cellar: :any,                 arm64_linux:       "55d1c51261037bf271917f84120902e42240b24301759f98c4cb861f92e7c5d5"
    sha256 cellar: :any,                 x86_64_linux:      "e50473ad588daef6c256e8faa547750a49f2dd7051f0fcdd973ae3bf8beb69ba"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
