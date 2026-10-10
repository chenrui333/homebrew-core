class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.25.tar.gz"
  sha256 "2563cf18a0394df79fd9eca5734c7bacf55993c2544237020c5a3bf48676c216"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f919cfd67fb3df562bd4630ddaa8d66a4a49869f4e805b0aff2b6a39eb1dea9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f919cfd67fb3df562bd4630ddaa8d66a4a49869f4e805b0aff2b6a39eb1dea9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f919cfd67fb3df562bd4630ddaa8d66a4a49869f4e805b0aff2b6a39eb1dea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04c23f25eb72eca0a987b2d2437542b20c3897809b6df2e66b4dee1c0a546bdf"
    sha256 cellar: :any,                 x86_64_linux:      "604274ce4466ca253bbe4e5527b13124a5eb23715b6d932142c9280278ab385b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
