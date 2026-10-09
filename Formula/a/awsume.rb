class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  # Restore PyPI URL and remove livecheck after https://github.com/trek10inc/awsume/issues/289
  url "https://github.com/trek10inc/awsume/archive/refs/tags/4.5.5.tar.gz"
  sha256 "33946d1dbd62394024b1d11c09aeb1eb566981b99e0d8eed5255b948e74ccebc"
  license "MIT"
  revision 2
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c12164915da3176960ba9654be3cf2085fb3f5e0e328d27f17463a198f532812"
    sha256 cellar: :any,                 arm64_tahoe:       "912c294f4270cad32ba129a55ad7de6f297a22fcc7af22a62eddeacf4b6e2d46"
    sha256 cellar: :any,                 arm64_sequoia:     "85513d3816f52eb95a95979227e54763f8f8c977c29910155f41d80169481dcc"
    sha256 cellar: :any,                 arm64_sonoma:      "06bb905c74719049654e9a9c8c68cd6ff3d284baa2274049b9a48377826ed9d5"
    sha256 cellar: :any,                 sonoma:            "b154b5ef67b65108428650e7b3d644a25b84d3c2cc448faa877599468cb5be47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a750c88a9b764ab55a9ad12c108a422846955f417332ed9c95b4032755938a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "35d320dcce1421dab098f6a23f083b3d740a82d67a992db3242778fa48cccf60"
  end

  # https://github.com/trek10inc/awsume/blob/master/README.md
  deprecate! date: "2026-09-11", because: :deprecated_upstream, replacement_formula: "awscli"
  disable! date: "2027-09-11", because: :deprecated_upstream, replacement_formula: "awscli"

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2a/80/0430e16c302b0d1a4ca3c8c69ffee9e4f8f2170d56162d2761b34fd512ba/boto3-1.43.109.tar.gz"
    sha256 "c829bc3352e1e3922d8fe1db10b697182ac411b64ce5fc3acb0a06a29837417e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3c/da/424aaef4727876f4095bd2c10e683bb8531ac3bea56b0b6efd29eeb57f91/botocore-1.43.109.tar.gz"
    sha256 "46b15bea4d942aaea6d7ab7c4b8a3a7290305064a3b41a6cb271cde9da3ba371"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")
    assert_match <<~YAML, (testpath/".config/awsume/config.yaml").read
      colors: true
      fuzzy-match: false
      role-duration: 0
    YAML
    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
