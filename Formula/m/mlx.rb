class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://github.com/ml-explore/mlx/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "326ce8da407b7c15f721b28f77dd18cf22b2d51edaaa4623c0e1ee46e93df1ba"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "cbe266cb34736f1faa24fc8f30e61fdb8a88eb6053f8183978b63b0948e21954"
    sha256 cellar: :any, arm64_sonoma:  "33684d3fec2142ee4015796f5f74ffdcb88651e72e07d035713a413a63207087"
    sha256 cellar: :any, arm64_ventura: "d45e1caad843c1eafe1cf2489fde0c5163529569a6de5f206612941bf13f651a"
    sha256 cellar: :any, sonoma:        "e6f252dbf454b99957c2f325c8113b92f846aeba40ad6848f5467a22f4ac6b7c"
    sha256 cellar: :any, ventura:       "9a916d853089ec7dd07aa523c4076e95caed86d32b3eda9299a6a680e5784a2d"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nanobind" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python-setuptools" => :build
  depends_on "robin-map" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.13"

  on_arm do
    depends_on xcode: ["15.0", :build] # for metal
  end

  on_intel do
    depends_on "openblas"
  end

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt#L98
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https://developer.apple.com/metal/cpp/files/metal-cpp_macOS15_iOS18.zip"
      sha256 "0433df1e0ab13c2b0becbd78665071e3fa28381e9714a3fce28a497892b8a184"
    end
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt#L21
  resource "gguflib" do
    url "https://github.com/antirez/gguf-tools/archive/af7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
    ]
    args << if Hardware::CPU.arm?
      (buildpath/"metal_cpp").install resource("metal-cpp")
      "-DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}/metal_cpp"
    else
      "-DMLX_ENABLE_X64_MAC=ON"
    end

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.allclose(mx.cos(x), mx.array(1.0))
    PYTHON
    system python3, "test.py"
  end
end
