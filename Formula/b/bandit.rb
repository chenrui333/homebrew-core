class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/aa/c3/0cb80dfe0f3076e5da7e4c5ad8e57bac6ac357ff4a6406205501cade4965/bandit-1.9.4.tar.gz"
  sha256 "b589e5de2afe70bd4d53fa0c1da6199f4085af666fde00e8a034f152a52cd628"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "950c6698052c864b88b14880897a4f95b569fd6d4202b9e41794e9d3850f048b"
    sha256 cellar: :any,                 arm64_tahoe:       "1b7189ed69829e064ecbdf704cbd6e08b3a293cc4f8b6f7b8a905853acd3e879"
    sha256 cellar: :any,                 arm64_sequoia:     "97ce6dfbaa20d117c9b42c4c86f7dbc1ecaeec0d729c95dfd3c62a7233d10f08"
    sha256 cellar: :any,                 arm64_sonoma:      "046c7ea7788b6033fc02fbf9a274ac7e61323195392af3fd88835e1383621fca"
    sha256 cellar: :any,                 sonoma:            "b90fd2ec3020a447430ca6c678a90926c961251bd0af287d2c7c4f8a4289069c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "84acad612b361d5211dae97c27d1c1f75251eb1548f636ad9a5e60cad0fd6b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "aeed013586f401f4d8233ad572169066746a062e655e719c3d459dc981101870"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
