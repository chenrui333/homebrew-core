class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.1.tgz"
  sha256 "3a7d63f0afc8d92326215c09e71a8505761de7a8a1639951786b1f8cc5de69dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c2dca502494d0aaca342bbf66ccb167c833e5964932193307b889b354ff3568"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c2dca502494d0aaca342bbf66ccb167c833e5964932193307b889b354ff3568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c2dca502494d0aaca342bbf66ccb167c833e5964932193307b889b354ff3568"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd6d081a073e2646179a796f548956555de8f60cf2efc34b0b6443f330e7894e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bd6d081a073e2646179a796f548956555de8f60cf2efc34b0b6443f330e7894e"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
