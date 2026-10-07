class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.17.1",
      revision: "a13d6ab1804751f8f4f964fb1154d057fc9c9ff6"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f927b18c520d3247e16842bba365f7ecdb271d7cfffc69bcf7d63a0e01f31f9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f927b18c520d3247e16842bba365f7ecdb271d7cfffc69bcf7d63a0e01f31f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f927b18c520d3247e16842bba365f7ecdb271d7cfffc69bcf7d63a0e01f31f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "67c2dd209795d6bf0242379a8795c8707f032da1c16cb3c62569f3670f8d1aec"
    sha256 cellar: :any,                 x86_64_linux:      "693e4c263e408c73ff800d48c8c2db7e3dc7c1ecf07a3d29341ef314c4b6a691"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/mgechev/revive/cli.commit=#{Utils.git_head}
      -X github.com/mgechev/revive/cli.date=#{time.iso8601}
      -X github.com/mgechev/revive/cli.builtBy=#{tap.user}
    ]
    ldflags << "-X github.com/mgechev/revive/cli.version=#{version}" if build.stable?

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revive -version")

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    GO

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
