class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e3708d4da099d1e22e71384fe8ea0445aa2549d5198c569cdfb2fe75672f90c6"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ab2d41671b597d1fb00b3da2e7fe9cfdda65630d6f4d1fddb5b302af6dacc6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "371881f2d351ce3291309b4997a61943566084f478ab7913396383268042efcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "557ed23d9ec407e15c4253544a8b1ddff3c558b4dde2fad45d4eb9ef9cb48b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0f883a324def10d1dfa421af6f46826ea73bd8f81d6919b4eec4da70bf3cfa6c"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to create subscription", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
