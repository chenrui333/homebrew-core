class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "5e34d18d10c976a8a4dd4be49a87a18b3025969c6c7dd6e47116ee0c49b913f1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c83a71121c7a7f1b59c68ee2fbef5cb51a7a655df06bf8959c64c5a1f9c132d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c83a71121c7a7f1b59c68ee2fbef5cb51a7a655df06bf8959c64c5a1f9c132d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c83a71121c7a7f1b59c68ee2fbef5cb51a7a655df06bf8959c64c5a1f9c132d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "944ba5aa9d58e6acd7bfed6db41ddebba4ab04fd8160140032cf60d2c09d24ae"
    sha256 cellar: :any,                 x86_64_linux:      "de41500f995badcaa645e85aa10d6406c830f0b35fb52f3f730719719e092458"
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
