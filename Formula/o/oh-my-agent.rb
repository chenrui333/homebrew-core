class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-16.0.0.tgz"
  sha256 "ff7b79f8ea1c2e9c0d04fcd0e4194f12d2c6237a217194557e06e9d41ad2ccd9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "78d6f81e0ed3cada87d2aac0f70ec123c3332a75df7081435c07ea679ed33986"
    sha256 cellar: :any, arm64_tahoe:       "4cf400f92f2a96ecee0f86b4e7faec85c5a6e416df4a7f1648c98b5d462b746e"
    sha256 cellar: :any, arm64_sequoia:     "233b676d9ce0e7d7793ca0af99a9596cf28e45b50183e889cfdc4a638da43259"
    sha256 cellar: :any, arm64_linux:       "d16f9ebf412301d6e342e22cba8a6ec7dfaa0cd18d2be126e605233f499bf11a"
    sha256 cellar: :any, x86_64_linux:      "14a0fb4f3166696b89e2cca204ecde3c3f6feb814afc884d4908675274491f33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
