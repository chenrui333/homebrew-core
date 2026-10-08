class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "41257acd9d11d4ed9d0db7d6bb0a8e570280a59ce118f9afa6e019541ba08b53"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7317083b6cf90a1542feafa1b68ae0d32dffde7c346da3405dfb39aac436387b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7317083b6cf90a1542feafa1b68ae0d32dffde7c346da3405dfb39aac436387b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7317083b6cf90a1542feafa1b68ae0d32dffde7c346da3405dfb39aac436387b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e62be51d33ae6d30892b3598845816a8c53ae5a8f469b4f41e365fbd69bd900"
    sha256 cellar: :any,                 x86_64_linux:      "760ca378c6c7337ccf2f155a64f65a7c020ffc4f835377633d1f7759734ff363"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  def shell_output_with_tty(cmd, expected_status = 0)
    return shell_output(cmd, expected_status) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal expected_status, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    relay_output = shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1", 123)
    assert_match "failed to fetch 'listblockedips'", relay_output
  end
end
