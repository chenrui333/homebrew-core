class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "7f785558cb60e9fb839e8ef0fb8964ca3341ce4ab090e08d4ce8bf9627f173ea"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a0d12a69cadc997ff2d3a6c417fa66c97c1d2615e1d80ca5429beb4f430ac1d9"
    sha256 cellar: :any, arm64_tahoe:       "32f4d229b561c0321224292a23691076f23bd48243df5d3a68eff3bc54ffbc44"
    sha256 cellar: :any, arm64_sequoia:     "8edb24e4ecb07d4ff91b69b78f256bd432828ade902b0ad47586a5b942a8184b"
    sha256 cellar: :any, arm64_linux:       "64ba901c2ef059180565b2d4af71c5cf2b069ad588206524c430e989e2b8fbfa"
    sha256 cellar: :any, x86_64_linux:      "5b45e326d19e6ea9255d90bd886796c4c940ad9e716875f2daa9242716701d62"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
