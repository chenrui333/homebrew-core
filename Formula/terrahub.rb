require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.34.tgz"
  sha256 "1082700e70db6aa478bdf5c9a5f062b1e928fcc719864797070c6bbb8b7816f1"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7972ce492779018b540cd90079578097685cef3cc75874ced360d0ba6465934f" => :catalina
    sha256 "e8e599a557875175f9b65dba1ef209244db279cd2d068c4b037d3405316a8011" => :mojave
    sha256 "d66c2d8e0ea4602dbe306647ebc6fc52f7bb56685033ba972f3e44de2a506102" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
