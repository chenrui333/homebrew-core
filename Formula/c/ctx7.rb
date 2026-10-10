class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.6.0.tgz"
  sha256 "c515df1f913acb20667a569415875e7456e7833e1ee146c55ad3d266f06d3c74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50d2bafff408bb56a313c3e22f9aac34e15eed2059684c6b1e1b93b6c445eb09"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
