class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://files.pythonhosted.org/packages/5b/16/6f1d0e05ceff921106281db6866d45e1b7eb284f078886e463ca9a1e6566/vapoursynth_bm3d-11.0.tar.gz"
  sha256 "a1d02dd4bf7e2b5bfaa2b3c6744e5093b225e8562a39d183a6ba239554cd876c"
  license "MIT"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "561a1a41c9959e571b1d54030bb789350192070b729c0b51fc5147042be9d54c"
    sha256 cellar: :any, arm64_tahoe:       "ab6f04f6c19a12c93db8c21a75c6b8f5bf2eded72ee3bbf17bb664002c15a680"
    sha256 cellar: :any, arm64_sequoia:     "0cfc85062a2cb1ccfbba44e28cc714e1a7529a1abc59472e2a70f6742ff04ac9"
    sha256 cellar: :any, arm64_sonoma:      "20f00b073e2243a147bde3cf910ca95b1b3407b1807d2413f633ef37c1974a03"
    sha256 cellar: :any, sonoma:            "cb91156d287ef75a47e3ce0ca3f1b870af2b82f7cae432f0cfcaae1d948f1b4a"
    sha256               arm64_linux:       "b0943031a534cba652e42a5a33ad4d52de40586195e3b22e14ac1bd628817f80"
    sha256               x86_64_linux:      "d1e499cc1ae84d17684d1898ca282803dc3661fb89f3574e8f63a89f37e90210"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  deny_network_access!

  def install
    (buildpath/"python.ini").write "[binaries]\npython = '#{python3}'\n"

    # Work around Homebrew's python prefix patch
    args = %W[
      --native-file=python.ini
      -Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import vapoursynth as vs
      clip = vs.core.std.BlankClip(width=32, height=32, format=vs.GRAYS, length=1, color=[0.25])
      filtered = vs.core.bm3d.Basic(clip, sigma=[3])
      frame = filtered.get_frame(0)
      assert frame.width == 32 and frame.height == 32
      assert abs(frame[0][0, 0] - 0.25) < 1e-6
    PYTHON
  end
end
