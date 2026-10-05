class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/65/6a/278112b2d82169bfe6bd2bac025deb917d7c83f890d71509c988fedd9a01/gersemi-0.29.2.tar.gz"
  sha256 "3acab643bec6c8174fb90ece56d76a8381847f77873a1a6ae3211f5b40472c25"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "64fe8b22b13468205e40e720e1f224a2657da604ef6d0609e5a29d31c3c07787"
    sha256 cellar: :any, arm64_tahoe:       "ed99cdb7443d123c9f6cf50296a206768a0b04a1ef404ddddaf52c29edd86ecb"
    sha256 cellar: :any, arm64_sequoia:     "4aeea171054d6ef8f5d5e27ce8cb9f5302d4fa1f3e54d502c6bddb283114c4a1"
    sha256 cellar: :any, arm64_linux:       "8344877d5ea28103c865848fdb3218dacea504fce59718fef250e002efa50a82"
    sha256 cellar: :any, x86_64_linux:      "19f69b9b77d70a950400d4f9f9e5c1c0adc58d83878ac4d1c01ac82adec61636"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    cython
    flit-core
    packaging
    semantic-version
    setuptools
    setuptools-rust
    setuptools-scm
    vcs-versioning
  ]

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  deny_network_access!

  def fetch
    cd "gersemi/rust-backend" do
      system "cargo", "fetch", *std_cargo_fetch_args
      system "cargo", "metadata", "--locked", "--format-version=1"
    end
  end

  def install
    ENV["CARGO_VERSION"] = Formula["rust"].version.to_s
    ENV["PIP_NO_INDEX"] = "1"
    ENV["PIP_NO_CACHE_DIR"] = "1"
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    bootstrap = %w[
      setuptools
      flit-core
      packaging
      vcs-versioning
      setuptools-scm
      semantic-version
      setuptools-rust
      cython
      pyyaml
    ]
    bootstrap.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
