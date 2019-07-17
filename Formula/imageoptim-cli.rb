require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.3.8.tar.gz"
  sha256 "a10230170c4158cd5a8f9146a586e364930ed86d1af98d3df574123d06164111"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a6900ff56f1ecb196b38ff4d9391a7935dda759759ca391d8babc2d3473d643" => :mojave
    sha256 "787da7525a4f29cf09a4ae0c6f43994d90b22a3491e17110637e42cb382f0558" => :high_sierra
    sha256 "e9d5159487de92a2d43ca11df21e241bd02369be862be182319ac580bb51b25c" => :sierra
  end

  depends_on "node@10" => :build
  depends_on "yarn" => :build

  def install
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
