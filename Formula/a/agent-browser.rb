class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.9.3.tgz"
  sha256 "df9e8f9bef955364d71cf36920acc0e0c68292ef195de37bc2fa26f780a1e277"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34b88ca239b91832740c3d0bffb16c48fc5adb4dc04397e972b3603703c348da"
    sha256 cellar: :any,                 arm64_sequoia: "907fa5e25f0e5a13892862fbad7db29463aab5f71921be05b6ef51d039b22529"
    sha256 cellar: :any,                 arm64_sonoma:  "907fa5e25f0e5a13892862fbad7db29463aab5f71921be05b6ef51d039b22529"
    sha256 cellar: :any,                 sonoma:        "267606b8895d34087d6599869e9f20d53052e260ad117264f15a875e089d75dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27000e68cda8ca073ba5dedffcf6b52ba738f980e8a73dde0b36052d20d14d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5660e61edde3b6db42ddb1d2b42f20548579727784e2bd169e26f0e4aa5386c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
