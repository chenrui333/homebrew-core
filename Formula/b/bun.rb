class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler, and package manager"
  homepage "https://bun.sh/"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.3.8.tar.gz"
  sha256 "9714396b53e340387bb2eeb6a92f34a7176d3e1cb73b1dd301f547bd570edcaf"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build

  depends_on "brotli"
  depends_on "c-ares"
  depends_on "highway"
  depends_on "libdeflate"
  depends_on "libuv"
  depends_on "lol-html"
  depends_on "mimalloc"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "zstd"

  resource "picohttpparser" do
    url "https://github.com/h2o/picohttpparser/archive/066d2b1e9ab820703db0837a7255d92d30f0c9f5.tar.gz"
    sha256 "637ff2ab6f5c7f7e05a5b5dc393d5cf2fea8d4754fcaceaaf935ffff5c1323ee"
  end
  resource "ls-hpack" do
    url "https://github.com/litespeedtech/ls-hpack/archive/8905c024b6d052f083a3d11d0a169b3c2735c8a1.tar.gz"
    sha256 "07d8bf901bb1b15543f38eabd23938519e1210eebadb52f3d651d6ef130ef973"
  end

  patch :DATA

  def install
    # Tarball builds may omit generated source-list manifests expected by CMake.
    mkdir_p "cmake/sources"
    bun_error_sources = Pathname("cmake/sources/BunErrorSources.txt")
    unless bun_error_sources.exist?
      bun_error_sources.write("packages/bun-error/index.tsx\npackages/bun-error/bun-error.css\n")
    end
    node_fallbacks_sources = Pathname("cmake/sources/NodeFallbacksSources.txt")
    if !node_fallbacks_sources.exist? || node_fallbacks_sources.read.strip.empty?
      fallback_inputs = Dir["src/node-fallbacks/*.js", "src/node-fallbacks/vendor/*.js"].sort
      node_fallbacks_sources.write("#{fallback_inputs.join("\n")}\n")
    end
    zig_generated_classes_sources = Pathname("cmake/sources/ZigGeneratedClassesSources.txt")
    zig_generated_classes_sources.write("") unless zig_generated_classes_sources.exist?
    cxx_sources = Pathname("cmake/sources/CxxSources.txt")
    cxx_sources.write("") unless cxx_sources.exist?
    c_sources = Pathname("cmake/sources/CSources.txt")
    c_sources.write("") unless c_sources.exist?
    javascript_sources = Pathname("cmake/sources/JavaScriptSources.txt")
    javascript_sources.write("") unless javascript_sources.exist?
    javascript_codegen_sources = Pathname("cmake/sources/JavaScriptCodegenSources.txt")
    javascript_codegen_sources.write("") unless javascript_codegen_sources.exist?
    bake_runtime_sources = Pathname("cmake/sources/BakeRuntimeSources.txt")
    bake_runtime_sources.write("") unless bake_runtime_sources.exist?
    bindgen_sources = Pathname("cmake/sources/BindgenSources.txt")
    bindgen_sources.write("") unless bindgen_sources.exist?
    zig_sources = Pathname("cmake/sources/ZigSources.txt")
    zig_sources.write("") unless zig_sources.exist?
    bindgen_v2_sources = Pathname("cmake/sources/BindgenV2Sources.txt")
    bindgen_v2_sources.write("") unless bindgen_v2_sources.exist?
    bindgen_v2_internal_sources = Pathname("cmake/sources/BindgenV2InternalSources.txt")
    bindgen_v2_internal_sources.write("") unless bindgen_v2_internal_sources.exist?
    resource("picohttpparser").stage do
      mkdir_p buildpath/"vendor/picohttpparser"
      cp "picohttpparser.c", buildpath/"vendor/picohttpparser/picohttpparser.c"
      cp "picohttpparser.h", buildpath/"vendor/picohttpparser/picohttpparser.h"
    end
    resource("ls-hpack").stage do
      rm_r buildpath/"vendor/lshpack" if (buildpath/"vendor/lshpack").exist?
      mkdir_p buildpath/"vendor/lshpack"
      cp_r Dir["*"], buildpath/"vendor/lshpack"
    end
    inreplace "cmake/targets/BuildBun.cmake",
              /(\s+OUTPUTS\n\s+\$\{BUN_BINDGENV2_CPP_OUTPUTS\}\n\s+\$\{BUN_BINDGENV2_ZIG_OUTPUTS\}\n)/,
              "\\1  ALWAYS_RUN\n"
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                register_repository(
                  NAME
                    picohttpparser
                  REPOSITORY
                    h2o/picohttpparser
                  COMMIT
                    066d2b1e9ab820703db0837a7255d92d30f0c9f5
                  OUTPUTS
                    picohttpparser.c
                )
              CMAKE
              <<~CMAKE
                if(EXISTS ${VENDOR_PATH}/picohttpparser/picohttpparser.c)
                  message(STATUS "Using vendored picohttpparser")
                else()
                  register_repository(
                    NAME
                      picohttpparser
                    REPOSITORY
                      h2o/picohttpparser
                    COMMIT
                      066d2b1e9ab820703db0837a7255d92d30f0c9f5
                    OUTPUTS
                      picohttpparser.c
                  )
                endif()
              CMAKE
    webkit_download_block = <<~CMAKE
      file(
        DOWNLOAD ${WEBKIT_DOWNLOAD_URL} ${CACHE_PATH}/${WEBKIT_FILENAME} SHOW_PROGRESS
        STATUS WEBKIT_DOWNLOAD_STATUS
      )
    CMAKE
    webkit_guarded_download_block = <<~CMAKE
      if (BUN_BOOTSTRAP STREQUAL "OFF")
        message(FATAL_ERROR "BUN_BOOTSTRAP=OFF: WebKit download disabled. Provide a local WEBKIT_PATH.")
      endif()
      file(
        DOWNLOAD ${WEBKIT_DOWNLOAD_URL} ${CACHE_PATH}/${WEBKIT_FILENAME} SHOW_PROGRESS
        STATUS WEBKIT_DOWNLOAD_STATUS
      )
    CMAKE
    inreplace "cmake/tools/SetupWebKit.cmake", webkit_download_block, webkit_guarded_download_block
    inreplace "cmake/tools/SetupWebKit.cmake",
              "set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)",
              <<~CMAKE
                if(EXISTS ${WEBKIT_PATH}/lib/libWTF.a)
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
                elseif(EXISTS ${WEBKIT_PATH}/libWTF.a)
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH})
                else()
                  set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
                endif()
              CMAKE
    inreplace "cmake/Globals.cmake",
              "  register_command(\n    COMMENT\n      ${NPM_COMMENT}\n",
              <<~CMAKE
                if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
                  message(STATUS "BUN_BOOTSTRAP=OFF: skipping JS dependency install for ${NPM_CWD}.")
                  return()
                endif()
                register_command(
                  COMMENT
                    ${NPM_COMMENT}
              CMAKE
    inreplace "cmake/Globals.cmake",
              /function\(register_repository\)/,
              <<~CMAKE
                function(register_repository)
                  if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
                    message(FATAL_ERROR "BUN_BOOTSTRAP=OFF: external repository downloads are disabled.")
                  endif()
              CMAKE
    inreplace "cmake/targets/CloneZstd.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_ZSTD "Use system zstd" OFF)
                if(USE_SYSTEM_ZSTD)
                  message(STATUS "Using system zstd")
                  add_custom_target(clone-zstd)
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildZstd.cmake",
              "register_cmake_command(",
              <<~CMAKE
                option(USE_SYSTEM_ZSTD "Use system zstd" OFF)
                if(USE_SYSTEM_ZSTD)
                  find_library(ZSTD_LIBRARY NAMES zstd REQUIRED)
                  find_path(ZSTD_INCLUDE_DIR NAMES zstd.h REQUIRED)
                  add_library(zstd STATIC IMPORTED GLOBAL)
                  set_target_properties(zstd PROPERTIES
                    IMPORTED_LOCATION ${ZSTD_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${ZSTD_INCLUDE_DIR}
                  )
                  return()
                endif()
                register_cmake_command(
              CMAKE
    inreplace "cmake/targets/BuildBoringSSL.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_BORINGSSL "Use system OpenSSL libraries" OFF)
                if(USE_SYSTEM_BORINGSSL)
                  find_library(CRYPTO_LIBRARY NAMES crypto REQUIRED)
                  find_library(SSL_LIBRARY NAMES ssl REQUIRED)
                  find_path(OPENSSL_INCLUDE_DIR NAMES openssl/ssl.h REQUIRED)
                  add_library(crypto UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(crypto PROPERTIES
                    IMPORTED_LOCATION ${CRYPTO_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR}
                  )
                  add_library(ssl UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(ssl PROPERTIES
                    IMPORTED_LOCATION ${SSL_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR}
                  )
                  add_library(decrepit INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(decrepit INTERFACE crypto)
                  message(STATUS "Using system OpenSSL for BoringSSL targets")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildBrotli.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_BROTLI "Use system brotli" OFF)
                if(USE_SYSTEM_BROTLI)
                  find_library(BROTLICOMMON_LIBRARY NAMES brotlicommon REQUIRED)
                  find_library(BROTLIDEC_LIBRARY NAMES brotlidec REQUIRED)
                  find_library(BROTLIENC_LIBRARY NAMES brotlienc REQUIRED)
                  find_path(BROTLI_INCLUDE_DIR NAMES brotli/decode.h REQUIRED)
                  target_include_directories(${bun} PRIVATE ${BROTLI_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${BROTLICOMMON_LIBRARY} ${BROTLIDEC_LIBRARY} ${BROTLIENC_LIBRARY})
                  message(STATUS "Using system brotli")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildCares.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_CARES "Use system c-ares" OFF)
                if(USE_SYSTEM_CARES)
                  find_library(CARES_LIBRARY NAMES cares REQUIRED)
                  find_path(CARES_INCLUDE_DIR NAMES ares.h REQUIRED)
                  add_library(cares UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(cares PROPERTIES
                    IMPORTED_LOCATION ${CARES_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${CARES_INCLUDE_DIR}
                  )
                  add_library(c-ares INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(c-ares INTERFACE cares)
                  message(STATUS "Using system c-ares")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildHighway.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_HIGHWAY "Use system highway" OFF)
                if(USE_SYSTEM_HIGHWAY)
                  find_library(HWY_LIBRARY NAMES hwy REQUIRED)
                  find_path(HWY_INCLUDE_DIR NAMES hwy/highway.h REQUIRED)
                  add_library(highway UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(highway PROPERTIES
                    IMPORTED_LOCATION ${HWY_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${HWY_INCLUDE_DIR}
                  )
                  message(STATUS "Using system highway")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLibDeflate.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LIBDEFLATE "Use system libdeflate" OFF)
                if(USE_SYSTEM_LIBDEFLATE)
                  find_library(LIBDEFLATE_LIBRARY NAMES deflate libdeflate REQUIRED)
                  find_path(LIBDEFLATE_INCLUDE_DIR NAMES libdeflate.h REQUIRED)
                  add_library(libdeflate UNKNOWN IMPORTED GLOBAL)
                  set_target_properties(libdeflate PROPERTIES
                    IMPORTED_LOCATION ${LIBDEFLATE_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${LIBDEFLATE_INCLUDE_DIR}
                  )
                  message(STATUS "Using system libdeflate")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLolHtml.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LOLHTML "Use system lol-html" OFF)
                if(USE_SYSTEM_LOLHTML)
                  find_package(PkgConfig REQUIRED)
                  pkg_check_modules(LOLHTML REQUIRED IMPORTED_TARGET lol-html)
                  target_link_libraries(${bun} PRIVATE PkgConfig::LOLHTML)
                  message(STATUS "Using system lol-html")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildLshpack.cmake",
              <<~CMAKE,
                register_repository(
                  NAME
                    lshpack
                  REPOSITORY
                    litespeedtech/ls-hpack
                  COMMIT
                    8905c024b6d052f083a3d11d0a169b3c2735c8a1
                )
              CMAKE
              <<~CMAKE
                if(EXISTS ${VENDOR_PATH}/lshpack/CMakeLists.txt)
                  message(STATUS "Using vendored ls-hpack")
                else()
                  register_repository(
                    NAME
                      lshpack
                    REPOSITORY
                      litespeedtech/ls-hpack
                    COMMIT
                      8905c024b6d052f083a3d11d0a169b3c2735c8a1
                  )
                endif()
              CMAKE
    inreplace "cmake/targets/BuildMimalloc.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_MIMALLOC "Use system mimalloc" OFF)
                if(USE_SYSTEM_MIMALLOC)
                  find_library(MIMALLOC_LIBRARY NAMES mimalloc REQUIRED)
                  find_path(MIMALLOC_INCLUDE_DIR NAMES mimalloc.h REQUIRED)
                  target_include_directories(${bun} PRIVATE ${MIMALLOC_INCLUDE_DIR})
                  target_link_libraries(${bun} PRIVATE ${MIMALLOC_LIBRARY})
                  message(STATUS "Using system mimalloc")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildZlib.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_ZLIB "Use system zlib" OFF)
                if(USE_SYSTEM_ZLIB)
                  find_package(ZLIB REQUIRED)
                  add_library(zlib INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(zlib INTERFACE ZLIB::ZLIB)
                  message(STATUS "Using system zlib")
                  return()
                endif()
                register_repository(
              CMAKE

    args = %w[
      -GNinja
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_AR=/usr/bin/ar
      -DCMAKE_RANLIB=/usr/bin/ranlib
      -DUSE_SYSTEM_ZIG=ON
      -DBUN_BOOTSTRAP=OFF
      -DBUN_EXECUTABLE=BUN_BOOTSTRAP_DISABLED
      -DUSE_SYSTEM_LIBUV=ON
      -DUSE_SYSTEM_SQLITE=ON
      -DUSE_SYSTEM_BORINGSSL=ON
      -DUSE_SYSTEM_BROTLI=ON
      -DUSE_SYSTEM_CARES=ON
      -DUSE_SYSTEM_HIGHWAY=ON
      -DUSE_SYSTEM_LIBDEFLATE=ON
      -DUSE_SYSTEM_LOLHTML=ON
      -DUSE_SYSTEM_MIMALLOC=ON
      -DUSE_SYSTEM_ZLIB=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DWEBKIT_LOCAL=ON
      -DENABLE_BASELINE=ON
    ]

    webkit_path = ENV["HOMEBREW_BUN_WEBKIT_PATH"].to_s
    webkit_candidates = if webkit_path.empty?
      [
        Pathname("vendor/WebKit/WebKitBuild/Release/lib/libWTF.a"),
        Pathname("vendor/WebKit/WebKitBuild/Release/libWTF.a"),
      ]
    else
      args << "-DWEBKIT_PATH=#{webkit_path}"
      [
        Pathname(webkit_path)/"lib/libWTF.a",
        Pathname(webkit_path)/"libWTF.a",
        Pathname(webkit_path)/"usr/local/lib/libWTF.a",
        Pathname(webkit_path)/"WebKitBuild/Release/lib/libWTF.a",
        Pathname(webkit_path)/"WebKitBuild/Release/libWTF.a",
      ]
    end
    if webkit_candidates.none?(&:exist?)
      odie "WEBKIT_LOCAL=ON requires local WebKit static libs (missing libWTF.a). " \
           "Set HOMEBREW_BUN_WEBKIT_PATH to a prebuilt WebKit tree."
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")
    (testpath/"hello.js").write("console.log('ok')")
    assert_match "ok", shell_output("#{bin}/bun run #{testpath}/hello.js")
  end
end

__END__
From dc78fd800172cb7592612149e90ffdbd4d62f68b Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:09:40 -0500
Subject: [PATCH 1/4] cmake: add system zig option

---
 cmake/tools/SetupZig.cmake | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/cmake/tools/SetupZig.cmake b/cmake/tools/SetupZig.cmake
index fcdd8721f3..4035faced4 100644
--- a/cmake/tools/SetupZig.cmake
+++ b/cmake/tools/SetupZig.cmake
@@ -92,3 +92,11 @@ register_command(
   OUTPUTS
     ${ZIG_EXECUTABLE}
 )
+option(USE_SYSTEM_ZIG "Use system Zig from PATH" OFF)
+
+if (USE_SYSTEM_ZIG)
+  unset(ZIG_EXECUTABLE CACHE)
+  find_program(ZIG_EXECUTABLE zig REQUIRED)
+  message(STATUS "Using system Zig: ${ZIG_EXECUTABLE}")
+  return()
+endif()
-- 
2.50.1 (Apple Git-155)


From d3cb93d12d119e2f18d15529821c02c6507efd5f Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:09:40 -0500
Subject: [PATCH 2/4] cmake: add bun bootstrap toggle

---
 cmake/targets/BuildBun.cmake |  9 +++++++++
 cmake/tools/SetupBun.cmake   | 13 +++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/cmake/targets/BuildBun.cmake b/cmake/targets/BuildBun.cmake
index 64536cc26b..05493136a6 100644
--- a/cmake/targets/BuildBun.cmake
+++ b/cmake/targets/BuildBun.cmake
@@ -434,5 +434,9 @@ string(REPLACE ";" "," BUN_BINDGENV2_SOURCES_COMMA_SEPARATED
   "${BUN_BINDGENV2_SOURCES}")
 
+if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
+  message(STATUS "BUN_BOOTSTRAP=OFF: bindgen-v2 codegen requires pre-generated outputs.")
+endif()
+
 execute_process(
   COMMAND ${BUN_EXECUTABLE} ${BUN_FLAGS} run ${BUN_BINDGENV2_SCRIPT}
     --command=list-outputs
@@ -1583,3 +1583,6 @@ if(NOT BUN_CPP_ONLY)
     endif()
   endif()
 endif()
+if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
+  message(STATUS "BUN_BOOTSTRAP=OFF: codegen targets require pre-generated outputs.")
+endif()
diff --git a/cmake/tools/SetupBun.cmake b/cmake/tools/SetupBun.cmake
index b57d29b9a1..c598b96798 100644
--- a/cmake/tools/SetupBun.cmake
+++ b/cmake/tools/SetupBun.cmake
@@ -1,3 +1,16 @@
+option(BUN_BOOTSTRAP "Require Bun to build" ON)
+
+if (NOT BUN_BOOTSTRAP)
+  message(STATUS "BUN_BOOTSTRAP=OFF: skipping bun requirement. Codegen must be pre-generated.")
+  set(BUN_EXECUTABLE "true")
+  return()
+endif()
+
+if (BUN_EXECUTABLE AND EXISTS ${BUN_EXECUTABLE})
+  message(STATUS "Using provided Bun executable: ${BUN_EXECUTABLE}")
+  return()
+endif()
+
 find_command(
   VARIABLE
     BUN_EXECUTABLE
-- 
2.50.1 (Apple Git-155)


From 160702c711148884bfca484e24fad868c800d57a Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:09:40 -0500
Subject: [PATCH 3/4] cmake: add system dep toggles

---
 cmake/targets/BuildLibuv.cmake  | 9 +++++++++
 cmake/targets/BuildSQLite.cmake | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/cmake/targets/BuildLibuv.cmake b/cmake/targets/BuildLibuv.cmake
index 3072d95532..6108c42711 100644
--- a/cmake/targets/BuildLibuv.cmake
+++ b/cmake/targets/BuildLibuv.cmake
@@ -1,3 +1,12 @@
+option(USE_SYSTEM_LIBUV "Use system libuv" OFF)
+
+if (USE_SYSTEM_LIBUV)
+  find_package(PkgConfig REQUIRED)
+  pkg_check_modules(LIBUV REQUIRED libuv)
+  message(STATUS "Using system libuv")
+  return()
+endif()
+
 register_repository(
   NAME
     libuv
diff --git a/cmake/targets/BuildSQLite.cmake b/cmake/targets/BuildSQLite.cmake
index ce4cd8da24..a848320388 100644
--- a/cmake/targets/BuildSQLite.cmake
+++ b/cmake/targets/BuildSQLite.cmake
@@ -1,3 +1,12 @@
+option(USE_SYSTEM_SQLITE "Use system SQLite" OFF)
+
+if (USE_SYSTEM_SQLITE)
+  find_package(PkgConfig REQUIRED)
+  pkg_check_modules(SQLITE3 REQUIRED sqlite3)
+  message(STATUS "Using system SQLite")
+  return()
+endif()
+
 register_cmake_command(
   TARGET
     sqlite
-- 
2.50.1 (Apple Git-155)


From 850663497e8884c4972a570efae2b73f3b4e27a9 Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:12:33 -0500
Subject: [PATCH 4/4] cmake: allow register_command target dependency

---
 cmake/Globals.cmake | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmake/Globals.cmake b/cmake/Globals.cmake
index ab78654512..ae6cfdf827 100644
--- a/cmake/Globals.cmake
+++ b/cmake/Globals.cmake
@@ -428,6 +428,10 @@ function(register_command)
   set(CMD_COMMANDS COMMAND ${CMD_COMMAND})
   set(CMD_EFFECTIVE_DEPENDS)
 
+  if(CMD_TARGET)
+    list(APPEND CMD_EFFECTIVE_DEPENDS ${CMD_TARGET})
+  endif()
+
   list(GET CMD_COMMAND 0 CMD_EXECUTABLE)
  if(CMD_EXECUTABLE MATCHES "/|\\\\")
    list(APPEND CMD_EFFECTIVE_DEPENDS ${CMD_EXECUTABLE})
-- 
2.50.1 (Apple Git-155)

From 0e8c2f0b7f3c7b9a0b5e2f2a1f1b26e0b0a9f5c7 Mon Sep 17 00:00:00 2001
From: Rui Chen <rui@chenrui.dev>
Date: Fri, 6 Feb 2026 13:55:00 -0500
Subject: [PATCH 5/5] cmake: fallback UWS/USOCKETS version in tarballs

---
 cmake/tools/GenerateDependencyVersions.cmake | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmake/tools/GenerateDependencyVersions.cmake b/cmake/tools/GenerateDependencyVersions.cmake
index 0d60a8c2c2..a5c8c2b4e1 100644
--- a/cmake/tools/GenerateDependencyVersions.cmake
+++ b/cmake/tools/GenerateDependencyVersions.cmake
@@ -123,7 +123,7 @@ function(generate_dependency_versions_header)
     OUTPUT_VARIABLE BUN_GIT_SHA
     OUTPUT_STRIP_TRAILING_WHITESPACE
     ERROR_QUIET
   )
-  if(NOT BUN_GIT_SHA)
-    set(BUN_GIT_SHA "unknown")
+  if(NOT BUN_GIT_SHA)
+    set(BUN_GIT_SHA "${BUN_VERSION_STRING}")
   endif()
   list(APPEND DEPENDENCY_VERSIONS "UWS" "${BUN_GIT_SHA}")
   list(APPEND DEPENDENCY_VERSIONS "USOCKETS" "${BUN_GIT_SHA}")
-- 
2.50.1 (Apple Git-155)

--- a/cmake/tools/SetupWebKit.cmake
+++ b/cmake/tools/SetupWebKit.cmake
@@ -25,6 +25,18 @@
 
 set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)
 set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/lib)
+if(WEBKIT_LOCAL)
+  if(NOT EXISTS ${WEBKIT_INCLUDE_PATH} AND EXISTS ${WEBKIT_PATH}/usr/local/include)
+    set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/usr/local/include)
+  endif()
+  if(NOT EXISTS ${WEBKIT_LIB_PATH})
+    if(EXISTS ${WEBKIT_PATH}/libJavaScriptCore.a)
+      set(WEBKIT_LIB_PATH ${WEBKIT_PATH})
+    elseif(EXISTS ${WEBKIT_PATH}/usr/local/lib)
+      set(WEBKIT_LIB_PATH ${WEBKIT_PATH}/usr/local/lib)
+    endif()
+  endif()
+endif()
 
 if(WEBKIT_LOCAL)
   if(EXISTS ${WEBKIT_PATH}/cmakeconfig.h)
