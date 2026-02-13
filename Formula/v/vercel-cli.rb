class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.17.0.tgz"
  sha256 "3f26fb6686fc8fc6d1a24f987830b82a4d74774cf0a1e2fcdb87eb19ec2fdb58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "125f07c9e1698c35ff77c2b6bec4126ecb3dfdfb2c0ab903f698c0d3cd8ea7db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125f07c9e1698c35ff77c2b6bec4126ecb3dfdfb2c0ab903f698c0d3cd8ea7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125f07c9e1698c35ff77c2b6bec4126ecb3dfdfb2c0ab903f698c0d3cd8ea7db"
    sha256 cellar: :any_skip_relocation, sonoma:        "e65fb85ec99b85a407a668fe39d3ea12ddb372f6bbcfafde454a3249801b38f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79ed55d7a77fa83fcbc17fdc7449844f3d5cab9a09758b3928a393c04accc30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39a0d68c84a0d94029de7f820875f4bb15436278a3ab93c13a31f4a772eecd8"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
