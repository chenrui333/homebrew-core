class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/2c/43/1a2ae2dd8ae97bf1ec9991db097e52626d35b57d242f9687c9314eac5b57/esptool-5.4.0.tar.gz"
  sha256 "fd756598db0a26c9975fa18511b08687c54bf2ce7322ede80cf1f5117dad1f50"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5537e585f3793c012baacf1c8b7742d0091ca78a5484f83cd20315acb7ee6b9e"
    sha256 cellar: :any, arm64_tahoe:       "de6fa5a6a7c048145f96f2127038d5cdf045aef8f68e02c1605bc1584eaac993"
    sha256 cellar: :any, arm64_sequoia:     "4ea9c2b550d15e4fcf76bf6d27ed90b886c15698d93eeb5ef4957316a7977c0f"
    sha256 cellar: :any, arm64_sonoma:      "d9fb4c4f5a63ff30cc165da70fe4da3e17580bed1790d24534c9a7929c6a9afd"
    sha256 cellar: :any, arm64_linux:       "af4cc63b6ab7f614628b8153ddddb5551c0333fe0c03bb6b42f8a01e6f96c2ef"
    sha256 cellar: :any, x86_64_linux:      "ab996c9b7d7a28945403078b4ee7cd3b197094dde4b370d710ab5d1226d54681"
  end

  depends_on "rust" => :build # for tibs
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography", extra_packages: %w[
    calver
    cython
    flit-core==3.12.0
    hatchling
    maturin
    packaging
    pathspec
    pluggy
    poetry-core
    semantic-version
    setuptools
    setuptools-rust
    setuptools-scm
    tomlkit
    trove-classifiers
    vcs-versioning
    wheel
  ]

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/04/f7/6765577df59e2345036e435f7e983e1c291d67b7d76a51918eff04ad1494/bitarray-3.11.0.tar.gz"
    sha256 "bf19437ec00ec3d40aef82eaeedc14cf4000be9b635c4f5049796506e6630dd8"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/36/d3/de6fe4e7065df8c2f1ac1766f5fdccbe75bc18af2cf2dbeecd34d68e1518/bitstring-4.4.0.tar.gz"
    sha256 "e682ac522bb63e041d16cbc9d0ca86a4f00194db16d0847c7efe066f836b2e37"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "esp-pylib" do
    url "https://files.pythonhosted.org/packages/92/bc/a0f0eccc6abc2dfdeae259a83a8296aa6c03729369bf28403dc9ea2f9fc6/esp_pylib-1.1.4.tar.gz"
    sha256 "dcbd717e8a0d7139d18c28352b637f0ee70fc8e40f0db1c090796c9fad16c89a"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
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
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/f7/ea/21e4867ea0ef881ffd4c0550fc21a061435e50d6324bcd034396633cbc18/rich_click-1.9.8.tar.gz"
    sha256 "4008f921da88b5d91646c134ec881c1500e5a6b3f093e90e8f29400e09608371"
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

  resource "tibs" do
    url "https://files.pythonhosted.org/packages/57/cd/6cf028decf1c2df4d26077dd5d0532587d93d4917233d5e004133166a940/tibs-0.5.7.tar.gz"
    sha256 "173dfbecb2309edd9771f453580c88cf251e775613461566b23dbd756b3d54cb"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  deny_network_access!

  def fetch
    resource("tibs").stage do
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
      poetry-core
      bitarray
      intelhex
      pyserial
      reedsolo
      websockets
      cython
      calver
      semantic-version
      click
      mdurl
      packaging
      pathspec
      tomlkit
      pyyaml
      trove-classifiers
      markdown-it-py
      wheel
      vcs-versioning
      setuptools-scm
      pluggy
      setuptools-rust
      hatchling
      maturin
      pygments
      tibs
      rich
      bitstring
      esp-pylib
      rich-click
    ]
    bootstrap.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
    generate_completions_from_executable(bin/"esptool", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "Usage: espefuse", shell_output("#{bin}/espefuse --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write <<~EOS.unpack1("m")
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
