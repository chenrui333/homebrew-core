class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.2.0.tgz"
  sha256 "e92c4a7c59107db349543d658f5f2fb237825f2faa33bb7aaffe10d2d8663c05"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0571353904bdb963212271a15d497ac5557d7cba223e4f5f707cc6c59415b6a8"
    sha256 cellar: :any, arm64_tahoe:       "f4d3c48c958d7312ec50aecceb916ce51d28ec8a3704c4684f67de62255ef5f4"
    sha256 cellar: :any, arm64_sequoia:     "8f9bfbbbc27597549c123abe343ed9e1747bb7ee2c02106077138b3107a8ddfc"
    sha256 cellar: :any, arm64_linux:       "f13d5d4cf24578f483e7f2482c20ea3160e585ce1ec28b9fd6ea97c490be7263"
    sha256 cellar: :any, x86_64_linux:      "66ee855138ba92715ed348000fe180e17235b5d1081661b52869fe9873e645d7"
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
