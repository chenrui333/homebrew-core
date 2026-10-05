class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://www.pgbarman.org/"
  url "https://files.pythonhosted.org/packages/eb/8c/b225bca1623a6370885f005e2f575f5f13c5c790eb9bef6695299efca4dd/barman-3.20.1.tar.gz"
  sha256 "cac6542ac7a8f7cf2a7892807509d78dd24346a021afc24a7c3ec5b1626cc636"
  license "GPL-3.0-or-later"
  head "https://github.com/EnterpriseDB/barman.git", branch: "REL_3_X_master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d23b8930c53c3b18b4a791cc3c571bb0c5156cdc24c0fc81a57dc10dd9edf631"
    sha256 cellar: :any, arm64_tahoe:       "d34f8e988ee531ece5ee754ee3f0476dca90c9ef67ad732f65d1ae9666fa98f6"
    sha256 cellar: :any, arm64_sequoia:     "0fdd3a55d21e9b2fd4d57e3d96113a579b6857e826c8c0a76173a64af799dcfb"
    sha256 cellar: :any, arm64_linux:       "baa24a7899a00105cd1aa2e3e9484e3a8376f31884d7d2d35c572b0603a45542"
    sha256 cellar: :any, x86_64_linux:      "5678f52d4c13ff120308bb728c9ead0c5c4b55d5475bc072151a930c79fb06b5"
  end

  depends_on "rust" => :build # for uv_build > maturin
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    flit-core==3.12.0
    maturin
    packaging
    semantic-version
    setuptools
    setuptools-rust
    setuptools-scm==7.1.0
    typing-extensions
    uv-build==0.12.23
    wheel
  ]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/91/81/6ea19b8b28feb9405c8c87a307776614d6e404bdb98467d1ce10a39d2c1d/psycopg2-2.9.13.tar.gz"
    sha256 "d36784fc2dae69523ba4b79c7d1d1b4d6e83e87836874f111262f4db940b16a6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
    url "https://files.pythonhosted.org/packages/98/12/2c1e579bb968759fc512391473340d0661b1a8c96a59fb7c65b02eec1321/setuptools_scm-7.1.0.tar.gz"
    sha256 "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uv-build" do
    url "https://files.pythonhosted.org/packages/b4/65/672d5c1e7fff2a602b51758cd96c379ea80c0c20d9d10aae5139bfde9877/uv_build-0.12.23.tar.gz"
    sha256 "b0428317e2783252b33b513446436071f4e14bfeb38655c99877ca6550ea4aac"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  deny_network_access!

  def fetch
    resource("uv-build").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
      system "cargo", "metadata", "--locked", "--format-version=1"
    end

    resource("maturin").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
      system "cargo", "metadata", "--locked", "--format-version=1"
    end
  end

  def install
    ENV["PIP_NO_INDEX"] = "1"
    ENV["PIP_NO_CACHE_DIR"] = "1"
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    ENV.append_path "PATH", venv.root/"bin"
    bootstrap = %w[
      setuptools
      flit-core
      psycopg2
      six
      semantic-version
      packaging
      typing-extensions
      wheel
      setuptools-scm
      python-dateutil
      setuptools-rust
      maturin
      uv-build
    ]
    bootstrap.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
    etc.install "docs/barman.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/barman --version")

    cp etc/"barman.conf", testpath
    inreplace "barman.conf", "barman_user = barman", "barman_user = #{ENV["USER"]}"
    system bin/"barman", "-c", "barman.conf", "list-servers"
  end
end
