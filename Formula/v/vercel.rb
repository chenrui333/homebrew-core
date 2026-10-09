class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-63.0.1.tgz"
  sha256 "6964c00db4eaaac0cfb71249da78d3621b01745bde90487199842b8c9b77682a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1b6a3a6074f518a18cc6eb9dab1e401f3b82ee872f985b5b92d7d56a170ada97"
    sha256 cellar: :any,                 arm64_tahoe:       "1b6a3a6074f518a18cc6eb9dab1e401f3b82ee872f985b5b92d7d56a170ada97"
    sha256 cellar: :any,                 arm64_sequoia:     "1b6a3a6074f518a18cc6eb9dab1e401f3b82ee872f985b5b92d7d56a170ada97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e21967b5cb4c0ed2945c28d4080c3a03398e4dd7e3b5a1ec0dfa9785333c9df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bf4ba7439256617a9cc0a14b7f7b633fc9ecec7055ca5997142c3adbce95c0ad"
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
