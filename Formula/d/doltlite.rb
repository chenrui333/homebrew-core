class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.50.17/doltlite-autoconf-0.50.17.tar.gz"
  sha256 "c0f44e749c9e2efb2c4f7b02e76e675f0bf3c85efddebeb6844b0f004938ab87"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d57ac3fc1303552bae215437d37ad0d00d4ab65daead473fbf5c915ea16146bb"
    sha256 cellar: :any, arm64_tahoe:       "604c511cc14c618c6311d488720e215b717767853231498e8a3663c66c593a41"
    sha256 cellar: :any, arm64_sequoia:     "d76942c8cffbffca8581c96b3c3528e040df453212ce5504f4b40f4a33ed24ba"
    sha256 cellar: :any, arm64_linux:       "d01b52768d1fc4439235b4f3792f3a495acee1406dcd2035382c28778a696228"
    sha256 cellar: :any, x86_64_linux:      "a4e41445ef39886acebc68cd53097859480c9c421f9bc11e22cab4f69f252c67"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
    # `make install` would also install `libsqlite3`, `sqlite3.h` and `sqlite3.1` from `sqlite`
    system "make", "install-shell-0", "install-doltlite-lib", "install-doltlite-headers"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")

    (testpath/"hello.c").write <<~'C'
      #include <stdio.h>
      #include "doltlite.h"
      int main(void) {
        sqlite3 *db;
        if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
        sqlite3_close(db);
        printf("ok\n");
        return 0;
      }
    C

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-ldoltlite", "-o", "hello"
    assert_equal "ok", shell_output("./hello").chomp
  end
end
