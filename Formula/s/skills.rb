class Skills < Formula
  desc "Open agent skills ecosystem"
  homepage "https://skills.sh"
  url "https://registry.npmjs.org/skills/-/skills-1.7.1.tgz"
  sha256 "00a812f4b0d2559e54e655a97aae80a5b24acd0cf9db2177ec9942abb611058d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e8e5e3f54bb3f64e483f090b8dd36a57eb40ee8e3957c50d3e074b04992a7ff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
    assert_match "No project skills found", shell_output("#{bin}/skills list")
    system bin/"skills", "init", "test-skill"
    assert_path_exists testpath/"test-skill/SKILL.md"
  end
end
