class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-17.1.1.tgz"
  sha256 "2d485e5953c4cffc8e4cc441dc21150ab1569c0af83731dfab8bf80d12777e85"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9bbc31665cf4eb33abdebc3f3f8307a0fdc1ef13394f341c0dfe671303d448f"
    sha256 cellar: :any, arm64_tahoe:       "323021aa56bc8e73a8c7a5d55821da6d38d9d49d85a130c1000fa4d4bfe29cf3"
    sha256 cellar: :any, arm64_sequoia:     "a2bad8a1565027727665fa89718232486f183938351b5afdda437ac8bade0fd9"
    sha256 cellar: :any, arm64_linux:       "bc61645d74b5e22a2786103765134d4ee7850f34dec1f8d92c829c9bb9eae0d9"
    sha256 cellar: :any, x86_64_linux:      "203c2b634e7b58d789d9d1cc286c9f6a8dadab4dcffdf9023ff208d8f44a46f2"
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
