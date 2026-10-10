class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/apache/cassandra-ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 6
  head "https://github.com/apache/cassandra-ccm.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e895d4b37b6f0e91759bb27932e93259c642f4a68810f781e46a5271a71eb719"
    sha256 cellar: :any, arm64_tahoe:       "67b755e68216edfdcbe945e3644c4a5cbab93b4f7b6f8cdc0a66dcb6955717bc"
    sha256 cellar: :any, arm64_sequoia:     "891677994e9c63ddcf5b86405b86d8dfcce0b0c7a4c35857cb344dd23a29921d"
    sha256 cellar: :any, arm64_sonoma:      "3891e530c85afeedbc5b09a4186744102c06ab98aab885fe4f28106a2ea0b8da"
    sha256 cellar: :any, sonoma:            "465c9976007d204f33c9877c66ea5380311604f6429c3ad444c5633482bbd9a1"
    sha256 cellar: :any, arm64_linux:       "a6dc7168ca471aa9a9f069d7e7eccfff655ccf31d4971bd194eaddd639a9b60e"
    sha256 cellar: :any, x86_64_linux:      "229e27e99a7ab2d46e2b87de628f52095a68cb5f08dcd0b66ff3ba775e10251f"
  end

  depends_on "libev"
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages extra_packages: ["cassandra-driver", "setuptools"]

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/bb/ed/4e16210e194660f107929ee494f1cf18557252655067d9b39029c241be2d/cassandra_driver-3.30.1.tar.gz"
    sha256 "0c6a3e1428f7c6a9aa6c944b9c47a37cd2cdbeb5b5a82d42c33afdd56f14e398"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/f7/9c/16649913bf14c73e0a9453782e148362ff2657067deff6aa9c7ebcddcc31/deprecated-3.0.0.tar.gz"
    sha256 "16850204d3a1e6bb0acd06bff48d96e8b0a0d25d1c52f71705405a0f4894192d"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/2a/8c/dde022aa6747b114f6b14a7392871275dea8867e2bd26cddb80cc6d66620/geomet-1.1.0.tar.gz"
    sha256 "51e92231a0ef6aaa63ac20c443377ba78a303fd2ecd179dc3567de79f3c11605"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/3e/d2/a254a26d8ceaea87e0eee2e89fcfe53ddc1858418647493bb2937549ab6f/wrapt-2.5.0.tar.gz"
    sha256 "c48cdb6c904dca76d9915a579e4a5fab6b0c25f650c1019ce78a78effaf7a345"
  end

  # Drop `pkg_resources`, removed in setuptools 81+; backport of upstream
  # https://github.com/apache/cassandra-ccm/commit/0b19c8eef37d
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output(bin/"ccm", 1)
  end
end

__END__
diff --git a/ccm b/ccm
index 92c13e5..cad7c69 100755
--- a/ccm
+++ b/ccm
@@ -4,7 +4,6 @@ import os
 import sys
 import warnings

-import pkg_resources
 from six import print_

 from ccmlib import common
@@ -12,6 +11,14 @@ from ccmlib.cmds import cluster_cmds, command, node_cmds
 from ccmlib.remote import (PARAMIKO_IS_AVAILABLE, execute_ccm_remotely,
                            get_remote_options, get_remote_usage)

+try:  # Python 3.8+
+    from importlib.metadata import entry_points
+except ImportError:  # pragma: no cover - fallback for older Pythons
+    try:
+        from importlib_metadata import entry_points  # type: ignore
+    except ImportError:
+        entry_points = None
+

 def get_command(kind, cmd):
     cmd_name = kind.lower().capitalize() + cmd.lower().capitalize() + "Cmd"
@@ -52,7 +59,23 @@ def print_global_usage():
     exit(1)


-for entry_point in pkg_resources.iter_entry_points(group='ccm_extension'):
+def _iter_ccm_extension_entry_points():
+    if entry_points is None:
+        warnings.warn("importlib.metadata not available; skipping ccm_extension entry points")
+        return []
+
+    eps = entry_points()
+
+    if hasattr(eps, 'select'):  # modern importlib.metadata
+        return eps.select(group='ccm_extension')
+
+    if isinstance(eps, dict):  # older importlib_metadata returns dict
+        return eps.get('ccm_extension', [])
+
+    return [ep for ep in eps if getattr(ep, 'group', None) == 'ccm_extension']
+
+
+for entry_point in _iter_ccm_extension_entry_points():
     entry_point.load()()

 common.check_win_requirements()

