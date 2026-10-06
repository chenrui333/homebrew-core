class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "5c75d24ab6110391f62e7a73b913fc8f37f4c7451b629fe2f26a7d8768c7d77e"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c5f356f28858e1c05dbf055a10c7076d7fdaa8714a7a038ef12dafc9cd6932c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88ae13f4fd258c5acff5c3e14624dfcad79a3d9a4f0de7f2103a0fddfdbb26f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a6591de2ddb563eafdee2cfc2d0c91a01ba43e5c9188d7795dacca4f6dc5133"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ee62d9a6aebec5b1e63ead71ff41e982b9104768a65901a3da89e0a4c90a60b"
    sha256 cellar: :any,                 x86_64_linux:      "4e8da46b79b1402b9e597db28454a49cac9c4d216ebeb096472f29ecaa35c6e6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "Starting kamal-proxy", output
  ensure
    Process.kill("HUP", pid)
  end
end
