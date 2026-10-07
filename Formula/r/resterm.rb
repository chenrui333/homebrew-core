class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "e3187871c9c5370f3bf1a70d8dad290ea9c25377e2fd4ab345eb1db94faa6bef"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ff428708a6c633e95da28ad09d69869afeb873761f728bab18fdf758965fc90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ff428708a6c633e95da28ad09d69869afeb873761f728bab18fdf758965fc90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ff428708a6c633e95da28ad09d69869afeb873761f728bab18fdf758965fc90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "252da2f5973f5afa0829520f41ef76656a487bf04dc6d62d03852ad368662c4b"
    sha256 cellar: :any,                 x86_64_linux:      "eef47e46d7b8579582b4ac59fe6ec5dbc624d4f7107c7e567e535bdf3abe2481"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
