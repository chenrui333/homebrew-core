class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.1.tar.gz"
  sha256 "8d807cd909f4481d6777f7707e5ae75dcc399e14d68ff14a3c814731826e0dfc"
  license "MIT"
  revision 2
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77b60bcd0ec5ebe4aa2f0b51b33cc5d0f67c1a9e53d9cf96c8a24044bb8f44d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77b60bcd0ec5ebe4aa2f0b51b33cc5d0f67c1a9e53d9cf96c8a24044bb8f44d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77b60bcd0ec5ebe4aa2f0b51b33cc5d0f67c1a9e53d9cf96c8a24044bb8f44d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "77b60bcd0ec5ebe4aa2f0b51b33cc5d0f67c1a9e53d9cf96c8a24044bb8f44d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "177afc1e20f698794d1c6bc119073572422b79be02c3c2ad83e7459a63f4f29f"
    sha256 cellar: :any,                 x86_64_linux:      "b2c172c6763e761878de10fc80273ead35a04475f6a6a7b73a58d1da48434b82"
  end

  depends_on "go"

  patch do
    url "https://github.com/dominikh/go-tools/commit/4ff8b865d12b49f3af67daf2294023336987dad5.patch?full_index=1"
    sha256 "19f123d3f405f779e82a739d3d6e7e3b289659b496ac82bd699586465b06ecc4"
    type :unofficial
    resolves "https://github.com/dominikh/go-tools/pull/1834"
  end
  patch do
    url "https://github.com/dominikh/go-tools/commit/01bcfe17fb93153091b35df4036a1d73087817ab.patch?full_index=1"
    sha256 "52ce80f83d597020938bb7c463070f3c133802995029faeb632e3fc385fb4d8a"
    type :unofficial
    resolves "https://github.com/dominikh/go-tools/pull/1834"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end
