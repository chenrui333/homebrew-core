class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.7.3.tgz"
  sha256 "a5bdb7efdec6ebae907c3c240091e2d247c3558ab87d0c1424c9bb8e025519de"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "91bc6be205e9421d204b5c83f2a54d81c50013327d16f9059895950973f51903"
    sha256 cellar: :any, arm64_tahoe:       "810921cea5feb408f5b8d3ff8e9bda95d269451d0b749c87e1b250eb72a84b33"
    sha256 cellar: :any, arm64_sequoia:     "bb83b32d804e8e8fdafee08ae8ced2ae9a453e73949a06d2906a3d917512536f"
    sha256 cellar: :any, arm64_linux:       "d2460b6742f0a266c575ae0afdb2fd9391628182a4711308f33d9fbc62f689aa"
    sha256 cellar: :any, x86_64_linux:      "8914cc611997b815efeb8e769ba177e76ba9572b5ed72b5dc24b3afe3c1e8db5"
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
