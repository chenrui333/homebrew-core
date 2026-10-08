class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "3038e9bbdcf450acebc9e5a65bbadc638778dedda5e4522906d9284b98283bfa"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c80be18bda7bd9d0af4afecd6273a3c3e18205deadc41c7b2e33b09b214b2764"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "964fd9f9034aecfa0324dca3ffe3b376222591d568dff9c0d6250c04b8983b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27887c04c36257301bb8704c0d24b62d473f1a79ab5dca0e14f0dba8c54bf882"
    sha256 cellar: :any,                 arm64_linux:       "1c1fa8cb725879999b0f6a0fa1c925882ea3b7b8f635eaf1f135a430236b310d"
    sha256 cellar: :any,                 x86_64_linux:      "ca81b561b53928240feb6a2041bbace143472abcbf587c052e122c755204d62e"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  allow_network_access! :test

  def fetch
    cd "ui" do
      system "pnpm", "fetch"
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cd "ui" do
      system "pnpm", "--offline", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config

    port = free_port
    pid = spawn bin/"pitchfork", "supervisor", "run", "--web-port", port.to_s
    sleep 1
    assert_match "<title>Pitchfork</title>", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
  end
end
