class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-63.1.1.tgz"
  sha256 "9d9e69c018269203d2370293236aa6d2df03c29c6daebac9d41a969fd52ef95c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fe0d770a43bbffbcbe312c777ffa0773927548dff7eaa98feed599723a677dde"
    sha256 cellar: :any,                 arm64_tahoe:       "fe0d770a43bbffbcbe312c777ffa0773927548dff7eaa98feed599723a677dde"
    sha256 cellar: :any,                 arm64_sequoia:     "fe0d770a43bbffbcbe312c777ffa0773927548dff7eaa98feed599723a677dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c61db49d6db2ad9c44e39c0dd244940ee3e309782e382058aac66dba95faac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c7978339215ad93e65c351f4ea48c6e720151b0a12b160af09ff5cdd60551521"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
