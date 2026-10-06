class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-4.2.1.tgz"
  sha256 "3bc39460b5ab85a30e5761c7e07c4dc5db6ac9384b66d171669f9f0eab4fe8ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "035260d47058b07a6cfe352d3884c772b0b15b6aa2bd2bb1cdbb023f97327b74"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bru --version", nil, 0)
    assert_match "You can run only at the root of a collection", pipe_output("#{bin}/bru run 2>&1", nil, 4)
  end
end
