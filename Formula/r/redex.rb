class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  url "https://github.com/facebook/redex/archive/refs/tags/v2026.09.09.tar.gz"
  sha256 "9bea5953cd1e06f6c32ec913c79c11893624caf621a62f3b4d065a6c77e0988e"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1637e7c641492afb10f89d0ab47df964df897ab6026e1af0d6329d4a15d75d87"
    sha256 cellar: :any, arm64_tahoe:       "bedc7d74c8c6aae4dfde67293b461ddfb8cf0391466a0bca535377adb7546ab4"
    sha256 cellar: :any, arm64_sequoia:     "8b7979ae9df58e485b86d4de4bdade6e851b7748a256c11ded8bd22f50580357"
    sha256 cellar: :any, arm64_sonoma:      "80f2572ec3edecb40908bc0de68f18625ec71ac6c21cba6143617e92ef5bd164"
    sha256 cellar: :any, sonoma:            "3392e2b95d7d3cf00d250e2875fa877f9844d289283470d0591b9a7434438ffd"
    sha256 cellar: :any, arm64_linux:       "a96632b9d002482b4b69a16a045cac8d05b46c0297d9362e447a7bc6d42c3fc7"
    sha256 cellar: :any, x86_64_linux:      "f0421685457e0b1657c294396973da261c0e3be40059a5a23c07ebb37ab907f8"
  end

  depends_on "cmake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: %w[setuptools packaging]

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  def install
    zlib_home = if OS.linux?
      formula_opt_prefix("zlib-ng-compat")
    else
      MacOS.sdk_for_formula(self).path/"usr"
    end

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    python_scripts = %w[
      apkutil
      redex.py
      gen_packed_apilevels.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *python_scripts

    args = %W[
      -DBUILD_TYPE=Shared
      -DENABLE_STATIC=OFF
      -DBUILD_SHARED_LIBS=ON
      -DZLIB_HOME=#{zlib_home}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.glob("*")
    chmod "+x", libexec/"redex.py"
    bin.write_exec_script libexec/"redex.py"
  end

  test do
    resource "homebrew-test_apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    (testpath/"homebrew-default.config").write <<~JSON
      {
        "redex": {
          "passes": [
            "ReBindRefsPass",
            "ResultPropagationPass",
            "BridgeSynthInlinePass",
            "FinalInlinePassV2",
            "DelSuperPass",
            "CommonSubexpressionEliminationPass",
            "MethodInlinePass",
            "PeepholePass",
            "ConstantPropagationPass",
            "LocalDcePass",
            "RemoveUnreachablePass",
            "DedupBlocksPass",
            "UpCodeMotionPass",
            "SingleImplPass",
            "ReorderInterfacesDeclPass",
            "ShortenSrcStringsPass",
            "CommonSubexpressionEliminationPass",
            "RegAllocPass",
            "CopyPropagationPass",
            "LocalDcePass",
            "ReduceGotosPass"
          ]
        },
        "compute_xml_reachability": false,
        "analyze_native_lib_reachability": false
      }
    JSON
    (testpath/"homebrew-default.pro").write "-keep class * { *; }\n"

    testpath.install resource("homebrew-test_apk")
    config = %W[
      --config #{testpath}/homebrew-default.config
      --proguard-config #{testpath}/homebrew-default.pro
    ]
    system bin/"redex.py", *config, "-u", "--ignore-zipalign", "--unpack-dest", "redex-test", "redex-test.apk"
    assert_path_exists testpath/"redex-test.redex_extracted_apk"
    assert_path_exists testpath/"redex-test.redex_dexen"
  end
end
