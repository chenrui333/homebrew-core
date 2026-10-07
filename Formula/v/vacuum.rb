class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "4328bb8309efd671618c9f12bfd2cd4cc6deb4d75b4debb9672286d1618170b5"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ade755be5fa6391c656b1c7f953a5702c815dc7322affc741760357a627b9bbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e226466a871318672491a0d0ea2599bc5923de680f66aedcf8707419c47c5720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8068c24dd263f8fddbfc865e84aff2e1d5177dadff2e361c6ec42c6b342bcae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05bf8b4cbc84322b5525957344288b2568005cb63da0ad8fee91bc6750d89c13"
    sha256 cellar: :any,                 x86_64_linux:      "b88fad700a578a14f5d290a289977e82b5a76718b6c71556619bbdfb955d24d4"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "html_report_ui")

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output

    output = shell_output("#{bin}/vacuum html-report 2>&1", 2)
    assert_match "please supply an OpenAPI", output
    assert_match "generate an HTML Report", output
    refute_match "html-report support is not included in this build", output
  end
end
