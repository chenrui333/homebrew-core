class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "2b0d5e58685590001a5b39b1d75a672a1858dcd4b8c53a33f4682b2f26fc83fc"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eaaaf0f254549ff870b0b8a9842106590f3d73d847a22a17be4059c74a90149a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eaaaf0f254549ff870b0b8a9842106590f3d73d847a22a17be4059c74a90149a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaaaf0f254549ff870b0b8a9842106590f3d73d847a22a17be4059c74a90149a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "70204305410b66578900bbf1ed925af1534e60da8e9226bd1d611363259c7161"
    sha256 cellar: :any,                 x86_64_linux:      "55bb49a6c6720b5df853f707e20b75df37321895c3b184659af69ae6320ffc5d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
