class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.0.tgz"
  sha256 "7b381ae414c5901333955fb3b1294ba10bcc057495ca847ef2b7054fc3d3f1f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6931a3f10d27e0b44195ccbc6b368e2f6f59228781c4aa071576763fef859078"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6931a3f10d27e0b44195ccbc6b368e2f6f59228781c4aa071576763fef859078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6931a3f10d27e0b44195ccbc6b368e2f6f59228781c4aa071576763fef859078"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e475fd2a650a70d7aaca9cfc5440a84aebfe47a7bff14b7d44300a64dc9c1f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fcb3c142e8643df8c258b00bb179651e031d56ff123c28ec501d88141a46cfbb"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
