class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.10.0.tgz"
  sha256 "c3b4a3cbbb54a35018b03e20fcb1b9e8e955f4e77f8b23ca400a83814c43655e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1498164a7be9e772b052d80119c6daddaf59ea8f3998ec4055b2dfa006d85f11"
    sha256 cellar: :any, arm64_tahoe:       "93d2aad91f6e9bdbe15226a181751cb2cdce5ac37d87ce166beee45efb41684c"
    sha256 cellar: :any, arm64_sequoia:     "16083cefc27496f02594488b148c75ea6e8aa6bd79d5037d975876713f9d5dca"
    sha256 cellar: :any, arm64_linux:       "74e7703d974e672e778c384a8904a0be1db4561376e56897a5d65f49973f83bc"
    sha256 cellar: :any, x86_64_linux:      "b109baf43cef700a0e04a4aa6addb9b6bc31da29f1717245104c948c7b831977"
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
