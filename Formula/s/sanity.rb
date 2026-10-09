class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.15.0.tgz"
  sha256 "d0f9eec65de9b05c11e862a81ccac01e68b2f2b21d58db2f1127c5cfe625fd0d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7ddb9adcaf7d10aa56d9858240a2a35ed74d9e6254352226ffa25ffea870475"
    sha256 cellar: :any, arm64_tahoe:       "a7ddb9adcaf7d10aa56d9858240a2a35ed74d9e6254352226ffa25ffea870475"
    sha256 cellar: :any, arm64_sequoia:     "a7ddb9adcaf7d10aa56d9858240a2a35ed74d9e6254352226ffa25ffea870475"
    sha256 cellar: :any, arm64_linux:       "000428e3dbfd3cfd243d91b7a49184a38bdfa488c3af6de58b1a0207f2fab44c"
    sha256 cellar: :any, x86_64_linux:      "12d34a1d6147555fdd573911ce60b2e76b09fd31075935c280454e70ce8a8f27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
