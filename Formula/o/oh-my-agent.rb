class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.2.0.tgz"
  sha256 "e92c4a7c59107db349543d658f5f2fb237825f2faa33bb7aaffe10d2d8663c05"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f42c22726343e8057059fee07236261779c050d779d3dc9a1ae02482c90220c"
    sha256 cellar: :any, arm64_tahoe:       "077ea9041c9405528ffb6b921d9da58712e574d7a3bb9e37204ea8674105bcef"
    sha256 cellar: :any, arm64_sequoia:     "b421dcbb73fe7a0240cf6cc93cd25e50e0de25ec7496248fc5a7d959056f2638"
    sha256 cellar: :any, arm64_linux:       "e2ef74c7ee0a767e8786ce8e668e2c700a3763784559cfc8ff0ed07da9c62a9f"
    sha256 cellar: :any, x86_64_linux:      "c76daf9155787b78059b6a9946a5f5c1e59182fbe791ff11f4b6c7f17d80162f"
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
