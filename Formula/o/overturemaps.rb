class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/da/6b/d02503bba3a90fc333d6188b892554bcfccb30b6e3728086fa0fa4c2857f/overturemaps-1.0.2.tar.gz"
  sha256 "e92355dcc2961da0ce95ab9837a59f2d15bcc357be51d0c415ceab3d812fc97d"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b546c09aa45edff2122322bc5ba351f6626c433d9d4b58257e1d173a39cb1581"
    sha256 cellar: :any, arm64_tahoe:       "da396c9a1d123c727224653af61668f8ee746bd25fddbbe5f6f906e2cfd63155"
    sha256 cellar: :any, arm64_sequoia:     "4e29fec7adec9ec0f59a43b3600173da12c4427372c5db3c48449ba2a9036e38"
    sha256 cellar: :any, arm64_sonoma:      "cdecdb7d492c274f9394a92beebc316b2189690a6821b7e055f0b57b8e278e34"
    sha256 cellar: :any, sonoma:            "d15beb475498bc09d3514d2c129262a36df44a105f9a86e17ca151306dfbc04d"
    sha256 cellar: :any, arm64_linux:       "1d85438ed32e08885197ed250d7cb2aeca85ef93b13277d1a28725479d9ad0ad"
    sha256 cellar: :any, x86_64_linux:      "ee2d94999882b84ad727d330fef875b23f25c9e7bd380a07760ad769ccbb1a07"
  end

  depends_on "cmake" => :build  # for pyarrow
  depends_on "ninja" => :build  # for pyarrow
  depends_on "rust" => :build   # for orjson
  depends_on "apache-arrow"
  depends_on "geos"             # for shapely
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy", extra_packages: %w[
    calver
    cython
    flit-core==3.12.0
    hatch-vcs
    hatchling
    libcst
    maturin
    packaging
    pathspec
    pluggy==1.5.0
    poetry-core
    pyyaml
    scikit-build-core
    semantic-version
    setuptools
    setuptools-rust
    setuptools-scm==10.3.4
    tomlkit
    trove-classifiers
    vcs-versioning
    wheel
  ]

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/02/c0/098e5c91ff1537f00c85a6438b6cb1863d17144680cc91f47c87f104a200/libcst-1.9.0.tar.gz"
    sha256 "087b58a9afe076bb08e2d726478e1f16cb928d67ffa9092817e033c335de522a"
  end

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/0f/f3/742fb1f62b825f2c010697eaf4e828004bc2a81e7e806666989c132c7c42/orjson-3.12.0.tar.gz"
    sha256 "d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/3d/e3/27f57f80141379d60defe6703eb50a707325706f07fedfd1312c7a751995/pyarrow-25.0.1.tar.gz"
    sha256 "9150a83248bfed9813ea3c3af74c3856c1984d444aa28e58bf7733b9750ddf6a"
  end

  resource "pyfiglet" do
    url "https://files.pythonhosted.org/packages/c8/e3/0a86276ad2c383ce08d76110a8eec2fe22e7051c4b8ba3fa163a0b08c428/pyfiglet-1.0.4.tar.gz"
    sha256 "db9c9940ed1bf3048deff534ed52ff2dafbbc2cd7610b17bb5eca1df6d4278ef"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "scikit-build-core" do
    url "https://files.pythonhosted.org/packages/b2/1a/8c00b19c0a1e7acf890676af2efa430339d38e59fa9437f2aab8517af3f4/scikit_build_core-1.1.1.tar.gz"
    sha256 "e347a59193c878ac56a363e57506938652a6dd8c965790cb1cbc6bc7e8d5abad"
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

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  deny_network_access!

  def fetch
    resource("orjson").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
      system "cargo", "metadata", "--locked", "--format-version=1"
    end

    resource("maturin").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
      system "cargo", "metadata", "--locked", "--format-version=1"
    end

    resource("libcst").stage do
      cd "native" do
        system "cargo", "fetch", *std_cargo_fetch_args
        system "cargo", "metadata", "--locked", "--format-version=1"
      end
    end
  end

  def install
    numpy_include = formula_opt_lib("numpy")/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = formula_opt_include("geos")
    geos_lib = formula_opt_lib("geos")

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    ENV["PIP_NO_INDEX"] = "1"
    ENV["PIP_NO_CACHE_DIR"] = "1"
    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
    ENV.append_path "PATH", venv.root/"bin"
    bootstrap = %w[
      flit-core
      setuptools
      poetry-core
      click
      packaging
      pathspec
      pyfiglet
      cython
      calver
      semantic-version
      tomlkit
      wheel
      vcs-versioning
      shapely
      pyyaml
      trove-classifiers
      setuptools-scm
      tqdm
      pluggy
      setuptools-rust
      hatchling
      maturin
      libcst
      colorama
      hatch-vcs
      orjson
      scikit-build-core
      pyarrow
    ]
    bootstrap.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
    generate_completions_from_executable(bin/"overturemaps", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overturemaps --version")
    output = shell_output("#{bin}/overturemaps download 2>&1", 2)
    assert_match "Missing option", output
  end
end
