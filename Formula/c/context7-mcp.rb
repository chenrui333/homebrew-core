class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.1.2.tgz"
  sha256 "dc9786b8649a18d9986ddc788716604c570486c06a78db662e39e89162fba0c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98f5c25d259cf6ada78fd0b005c3d5b973e8577e6cb562aee6a726639b91f7eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
