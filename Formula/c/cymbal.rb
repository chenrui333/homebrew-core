class Cymbal < Formula
  desc "Language-agnostic code navigation CLI powered by tree-sitter"
  homepage "https://github.com/1broseidon/cymbal"
  url "https://github.com/1broseidon/cymbal/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "093a6e49b1e66d65d396bbd3ce391e5e239f725047494b905af54daf60324a54"
  license "MIT"
  head "https://github.com/1broseidon/cymbal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d881979a73ba426793999e3a64669438e9e5bd48f8195b2a8e5143b3117e208a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41f0ea98d5debe15f917359fb383e23e9787c35b289745aadc7dc28cfafa5cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "285fcea86bd0353a1e5432ba6b15195a35da3e200832ef62206cf14093dffc7b"
    sha256 cellar: :any,                 arm64_linux:       "2fcd5b31356d314c08a6dbef9e2bfccb3dd117949d58f0183e4b25b5121d0211"
    sha256 cellar: :any,                 x86_64_linux:      "c7372661d37580741ada346d6a5f033e6478e05f6f4c0ede0b71369e68101d92"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X github.com/1broseidon/cymbal/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: %w[libsqlite3 sqlite_omit_load_extension])

    generate_completions_from_executable(bin/"cymbal", shell_parameter_format: :cobra)
  end

  test do
    ENV["CYMBAL_NO_UPDATE_NOTIFIER"] = "1"
    system "git", "init", "--quiet"
    (testpath/"main.go").write <<~GO
      package main

      func greet(name string) string {
        return "hello " + name
      }

      func main() {
        println(greet("brew"))
      }
    GO

    result = JSON.parse(shell_output("#{bin}/cymbal search greet --json")).fetch("results").first
    assert_equal "greet", result.fetch("name")
    assert_equal "function", result.fetch("kind")
    assert_match "hello", shell_output("#{bin}/cymbal search hello --text")
    assert_match version.to_s, shell_output("#{bin}/cymbal --version")
  end
end
