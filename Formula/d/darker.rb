class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/akaihola/darker"
  url "https://files.pythonhosted.org/packages/df/78/ad6af1661c2eca0ec69b7ff7c99d95dcae29c5e0071c7ebc98e6670f4663/darker-3.0.0.tar.gz"
  sha256 "eb53776f037fcf42b1f5a56f62fb841cd871d95a78a388536dc91dc4355ce8bb"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "855e44d663650e9b4baad1f529f53b36615a5224ad1066f0476bdc980e9002c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02e21a974bae70f67a3b52d764da980696a89f4fac7987dcb6c0cfa99bbe0d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e9c5f797cba8fba4758d297996ea31bfd531201c810bb6137728367dd8fde8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "280862988a1ba81641ca5117e462b01c5ee11e4322e80a89edef75070d909c15"
    sha256 cellar: :any_skip_relocation, sonoma:            "b88539f673dfc1ded1a55407ac5e11ed5c297ed4f50a8fed70cfbcd5b58f0fb2"
    sha256 cellar: :any,                 arm64_linux:       "3b5fb4a1a33e4e423fe454d3c4d1c9de2870f8c6db55e3a420466301d298013b"
    sha256 cellar: :any,                 x86_64_linux:      "ff6352bdb61f25b4edefccab2bb73f07b47fd163143508c86dc3c4c88d596383"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages package_name: "darker[black]", extra_packages: %w[
    ast-serialize
    black
    calver
    flit-core
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
    librt
    maturin
    mypy
    pluggy
    poetry-core
    semantic-version
    setuptools
    setuptools-rust
    setuptools-scm
    tomlkit
    trove-classifiers
    types-psutil
    types-setuptools
    vcs-versioning
    wheel
  ]

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/c2/1c/7257e6ec9382843915ce475558ce4492ccb5ed39122c256bb369c27e2ebf/ast_serialize-0.12.1.tar.gz"
    sha256 "5285a390caf1c44368ae270f037f797b91427d138b7d43cad0f1fda4c83518d9"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "darkgraylib" do
    url "https://files.pythonhosted.org/packages/33/3f/e07f4a048a3d73b97311274c307d13d26a59c0c5cb6ac3388e343a03543c/darkgraylib-2.4.1.tar.gz"
    sha256 "032df9cf2a545573f4492a9c03cd70ea6264ebddaabf973ea02a02fdb6aed6f8"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-fancy-pypi-readme" do
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/04/f5/9dc696772d241814bacac7880bac32f2930b5a6ebc1f85317b83161a011c/librt-0.16.0.tar.gz"
    sha256 "ac38d6d8d66bf3d744148dbbc0b8e193e195a51e364ed55e224631f5721891fc"
  end

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/34/4e/64300736cf0a0373a27b94a91b664ee7382e36f77b0621bae6381da3e180/mypy-2.4.0.tar.gz"
    sha256 "77bdaebd452f43fcfc4cc3ba94352a3ea537cd01e3f2d0879f48673d2ec00d6e"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
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

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "types-psutil" do
    url "https://files.pythonhosted.org/packages/97/0a/f48b9b0ab5ba8599fd117309e345152bf82c756c72be2ff0f635780c2792/types_psutil-7.2.2.20260906.tar.gz"
    sha256 "93abf22cf9a62b915f724e433bde702995ac274865425fd4a76d1d9b5828da1a"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/4f/cd/3b2a3362a526f91c33f785a291462b2ec448ae531101c62372fc30a21f53/types_setuptools-84.0.0.20260812.tar.gz"
    sha256 "09bedc248ebbb7a232c9419dfcdca329706e61bf2aa5743e9424d027f1d956b4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
    resource("ast-serialize").stage do
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
      flit-core
      setuptools
      poetry-core
      click
      mypy-extensions
      packaging
      pathspec
      typing-extensions
      toml
      librt
      types-psutil
      types-setuptools
      calver
      semantic-version
      tomlkit
      wheel
      vcs-versioning
      trove-classifiers
      darkgraylib
      setuptools-scm
      pluggy
      setuptools-rust
      hatchling
      maturin
      hatch-fancy-pypi-readme
      hatch-vcs
      ast-serialize
      platformdirs
      mypy
      pytokens
      black
    ]
    bootstrap.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/darker --version")

    (testpath/"darker_test.py").write <<~PYTHON
      print(
      'It works!')
    PYTHON
    system bin/"darker", "darker_test.py"
    assert_equal 'print("It works!")', (testpath/"darker_test.py").read.strip
  end
end
