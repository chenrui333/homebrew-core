class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.42.0/pushpin-1.42.0.tar.bz2"
  sha256 "9ac513757b41511d26cde151b61894201903e73ec003877f667e9c2d1307184e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    sha256               arm64_golden_gate: "fbbc4a62fc06f90c820b63ba0784693439435324e629dc6351e851b705268811"
    sha256               arm64_tahoe:       "2b5aeb85a438bc413a92149daa304f26836526ff92256c07c70ed041251d4422"
    sha256               arm64_sequoia:     "83c631e870b574182bc1d9e4edf110f7db80888ec892d3273737e37027a473bc"
    sha256               arm64_sonoma:      "a14bc5d6d6e34e0c8091a0fbc71c8fbe7a2c57d596775a490457194b983899d2"
    sha256 cellar: :any, arm64_linux:       "52ee3c376104c3969775cd9abc56a95c8e71e13a289d2b88b521f76f6de738f9"
    sha256 cellar: :any, x86_64_linux:      "6952b44e67eb4b1c62e5ef62ac6aae32cd014623fac5c99b946ab78672db2b36"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"
  depends_on "python@3.14"
  depends_on "qtbase"
  depends_on "zeromq"

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    if build.stable?
      # Release tarball builds with vendored crates but we need to update openssl-sys after patch
      odie "Remove `cargo vendor`!" if version > "1.42.0"
      system "cargo", "vendor", "--locked"
    else
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Work around `cc` crate picking non-shim compiler when compiling `ring`.
    # This causes include/GFp/check.h:27:11: fatal error: 'assert.h' file not found
    ENV["HOST_CC"] = ENV.cc

    args = %W[
      RELEASE=1
      PREFIX=#{prefix}
      LIBDIR=#{lib}
      CONFIGDIR=#{etc}
      RUNDIR=#{var}/run
      LOGDIR=#{var}/log
      BOOST_INCLUDE_DIR=#{formula_opt_include("boost")}
    ]

    system "make", *args
    system "make", *args, "install"
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    cp HOMEBREW_PREFIX/"etc/pushpin/pushpin.conf", conffile

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end

    routesfile.write <<~EOS
      * localhost:10080
    EOS

    runfile.write <<~PYTHON
      import threading
      import time
      from http.server import BaseHTTPRequestHandler, HTTPServer
      from urllib.request import urlopen
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write(b'test response\\n')
      def server_worker(c):
        global port
        server = HTTPServer(('', 10080), TestHandler)
        port = server.server_address[1]
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      tries = 0
      while True:
        try:
          with urlopen('http://localhost:7999/test') as f:
            body = f.read()
            assert(body == b'test response\\n')
          break
        except Exception:
          # pushpin may not be listening yet. try again soon
          tries += 1
          if tries >= 10:
            raise Exception(f'test client giving up after {tries} tries')
          time.sleep(1)
    PYTHON

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = spawn bin/"pushpin", "--config=#{conffile}"
    sleep 5

    begin
      system python3, runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 4f329199..dd3a29fa 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1146,9 +1146,9 @@ checksum = "0ab1bc2a289d34bd04a330323ac98a1b4bc82c9d9fcb1e66b63caa84da26b575"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.9.0",
  "cfg-if",
@@ -1178,9 +1178,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index eec44fd2..1b7c0fc8 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -82,7 +82,7 @@ log = "0.4"
 miniz_oxide = "0.6"
 mio = { version = "1", features = ["os-poll", "os-ext", "net"] }
 notify = "7"
-openssl = "=0.10.72"
+openssl = "=0.10.78"
 paste = "1.0"
 prometheus = { version = "0.13", default-features = false }
 rustls = { version = "0.23", default-features = false, features = ["ring", "std", "tls12"] }
