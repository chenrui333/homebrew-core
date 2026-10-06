class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.4.1.tgz"
  sha256 "98a5eb25bb5698dd4b8a8dbd11f5b0166e947d7c4cc7fea012f92c029ef9b39b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b8d65bf6363d5c34b755e0c2a1b0e54d10fbf258616fadf69490264406262a5"
    sha256 cellar: :any, arm64_tahoe:       "5860f3eaab978bb25503229a15737f09bee8f99826aef2b2671c29cb27957fe5"
    sha256 cellar: :any, arm64_sequoia:     "dc4fa1d2f5f5799fd9ba167d108ec097d0a3b49b5175d4f3618e6f3157ebd738"
    sha256 cellar: :any, arm64_linux:       "15f6e98a9376da2e09aad97827d8a939be4da94c17a05564e305ce0225495c0f"
    sha256 cellar: :any, x86_64_linux:      "fe45009ab894979b56952d6b52ff82ae5a9d4bb3aaf5da06c73ae8c8955f1b23"
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
