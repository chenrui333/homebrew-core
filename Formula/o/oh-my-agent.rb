class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.7.2.tgz"
  sha256 "e2ced4bd3a5263265d7b515378d8424bcc54c01b2ec52e90162ecfdccc2a5d2a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4cf3999897ac12d8d52e83912a34531bd65151f2fd6d29f5ffd9200e3b9ec1b7"
    sha256 cellar: :any, arm64_tahoe:       "757fbe078b1f0492d7de6fe8431b7998cbb1c96ad081e09d0a2527dcd65573c8"
    sha256 cellar: :any, arm64_sequoia:     "a9f021abf2c5ef166a8eb337e614471c32f1330acde6a7ffb5ef5dd9d151cb11"
    sha256 cellar: :any, arm64_linux:       "4aa6f97dd41926d1fa42a1a63fbdeea2db799941c27c8d235b09145f4957ba5b"
    sha256 cellar: :any, x86_64_linux:      "5f972fd8fc4439fa3852cc5256c66edc225919949f70045526c2b6e1e970f060"
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
