class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.7.4.tgz"
  sha256 "6ba24970528db8bfa9ffb4dcc36fe67d7e4c8f7feec2c90e156ca814a57ec69e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "30cd0fa9531760118b6d6e5004d85950386b3e04977ab908bf989e0207697215"
    sha256 cellar: :any, arm64_tahoe:       "5f94e029db82a4f4880879cb91461abbf2b6edec20dd2bae928acd5c92dcd39f"
    sha256 cellar: :any, arm64_sequoia:     "0e84df4d09c836a81c0914ad3f5eb1f5b835f881261eb453580457ebdfd62e5f"
    sha256 cellar: :any, arm64_linux:       "0a0abce787bf946a062714c81ec921dd212db6b380aa92f99d438404f316b984"
    sha256 cellar: :any, x86_64_linux:      "cd3cf8ae006882aaf4650a744ab6200e226381f49dc44a42f8ae170f8b6a0484"
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
