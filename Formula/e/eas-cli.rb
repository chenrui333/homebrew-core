class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.12.0.tgz"
  sha256 "4510df9253e32ff154c5403b862e3855246a953d20fc493e48f2d88df0688f85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50c85d97110ec7bf889e4405ef4af4c264bcaae30aae318e27bb1f76776a77c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
