class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.5.0.tgz"
  sha256 "ee8056f6867eb875f4d3a3a003af9ce7b1fc1f9013e4af2d9643d91529399891"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f256d692e1cb990db173b9f4b67e1931ec9e71bf2338783a312bc10d563bbe67"
    sha256 cellar: :any,                 arm64_tahoe:       "f256d692e1cb990db173b9f4b67e1931ec9e71bf2338783a312bc10d563bbe67"
    sha256 cellar: :any,                 arm64_sequoia:     "f256d692e1cb990db173b9f4b67e1931ec9e71bf2338783a312bc10d563bbe67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a704f820e5d4527a764050678837fe6b5d7f050b70631ba84c486e2c0b4f257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ba1a107fdfb4eab5731ead7b811e6fc907a6db80492589d14f0d05de416e724"
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
