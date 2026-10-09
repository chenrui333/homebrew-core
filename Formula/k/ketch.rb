class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "e493e64e8b0da049faea10e831c41964c8005c965ef3b5f74a58b247b171b227"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b647134e1ad7e00a4856a2c47f98bb76daadf18dc682796b4874d6e74aaeefad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b647134e1ad7e00a4856a2c47f98bb76daadf18dc682796b4874d6e74aaeefad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b647134e1ad7e00a4856a2c47f98bb76daadf18dc682796b4874d6e74aaeefad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdfffd99b58705008824f3b952cc3943c26b81ab4938b38920baaeaf033008ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8579944222fab0f03960c21cabc9e2c80dfc1576950ebe786a76778b3053c373"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/1broseidon/ketch/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ketch", shell_parameter_format: :cobra)
  end

  test do
    ENV["KETCH_NO_UPDATE_NOTIFIER"] = "1"
    html = <<~HTML
      <html>
        <head><title>Ketch extraction test</title></head>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
