class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.4.1.tgz"
  sha256 "98a5eb25bb5698dd4b8a8dbd11f5b0166e947d7c4cc7fea012f92c029ef9b39b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef723ba69421e8515ff3f2911759ab85394ddb940249337bdf44264eab448f8c"
    sha256 cellar: :any, arm64_tahoe:       "172153111465053730fb00fa1ad80b0433f48e83d193a31785b09a014a9ce82a"
    sha256 cellar: :any, arm64_sequoia:     "3d198c52328e7357d9e8bb8b62650b1e5f70aa509ea103a6d84a3fc2fe52bc90"
    sha256 cellar: :any, arm64_linux:       "23cfbb9801997274af4c3c8735a4708e6577b145f9f6914642cf452c9d07bf08"
    sha256 cellar: :any, x86_64_linux:      "b3d298020756e12afb75eff1c46d2054a09008d6c4f27abc5e62c6360db7c9c5"
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
