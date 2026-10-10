class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-17.0.1.tgz"
  sha256 "508bc808d6ab0a417f46d1a33129d33da2d4f8c1845780941585677f79856455"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5eb14ab4589b539aa37efe31e5a4cffdc6e0fa9c48c8baa6148aaa28c82bda39"
    sha256 cellar: :any, arm64_tahoe:       "74515c745eb7621ce0ea153bcb4d2bf3e4630d89e3d53905d1dff9437e96b9a7"
    sha256 cellar: :any, arm64_sequoia:     "ba47340a92ba5287f902e078a8c7fa61339edd652e147485b6378b40ba78d2d4"
    sha256 cellar: :any, arm64_linux:       "17073b5d0381317d170965040eda0ddbf84b7597b1d1aee24480c2ac8a2f3edb"
    sha256 cellar: :any, x86_64_linux:      "9ff528cbe533d10f6274e7ff2d60b4c01bfe5cba5fa56821c2525ceaf2c8a033"
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
