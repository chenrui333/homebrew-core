class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.3.tar.gz"
  sha256 "fe0df274084d75899f911934ac253fa4c7ae12a089481f49c14cb9def08984a3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdd858da94d4f605d90369021e76547f804a23e755849ceb4ab7e806c1ad7eef" => :catalina
    sha256 "fc8270a2dc659a6ee67d07ec7429dddb568c5824102f91e71197f34bbb3efcfb" => :mojave
    sha256 "866fda218cf2873885fac085de83d0ddf860a7d475a6880cbda85b554cddb001" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
