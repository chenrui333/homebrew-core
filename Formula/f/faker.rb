class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.42.0.tar.gz"
  sha256 "de2fb5cc0b7964832d14188bdf1d14e4c72b8a20018ca5892a8148f17c38a747"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "064565abb7167ffec9bb13b47a5331b9805cad632e3658bc369f458277aebc8f"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end
