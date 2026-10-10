class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "fe80d113258e60b0293de102733f9f250afdbc7c44398a2c802bcd273af38da3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e92aa220a629f4b9c10bc3420d31fc114ee9a0d6d7f48ee578a004e4a7b8b62c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c71085034e504d4538b1fdd9bb0b1505ed2ecedfb240d79b6cd2b699808fb40d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1c906d52af67ebfb3203bc261bc16cc52fb6210c0c20d00946dc4c75cedbae1"
    sha256 cellar: :any,                 arm64_linux:       "fc22471a0c6e65254061964e2597ee2914b5a9b0a34fef089d611bbe40c057c7"
    sha256 cellar: :any,                 x86_64_linux:      "dbb6d10caab1d7f520ede815046b658480182eaa79c40b6d38a8b84d8de35def"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/syswatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").read.scrub
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end
