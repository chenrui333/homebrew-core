class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler, and package manager"
  homepage "https://bun.sh/"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.3.8.tar.gz"
  sha256 "9714396b53e340387bb2eeb6a92f34a7176d3e1cb73b1dd301f547bd570edcaf"
  license "TODO"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build

  depends_on "libuv"
  depends_on "sqlite"

  patch :DATA

  def install
    # Bootstrap bun (downloads allowed for fast prototype)
    bootstrap_dir = buildpath/"bootstrap"
    bootstrap_zip = buildpath/"bun-bootstrap.zip"
    bootstrap_dir.mkpath

    if OS.mac?
      if Hardware::CPU.arm?
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.8/bun-darwin-aarch64.zip"
      else
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.8/bun-darwin-x64.zip"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.8/bun-linux-aarch64.zip"
      else
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.8/bun-linux-x64.zip"
      end
    else
      odie "Unsupported OS for bootstrap bun"
    end

    system "curl", "-L", "-o", bootstrap_zip, url
    system "unzip", "-q", bootstrap_zip, "-d", bootstrap_dir
    bootstrap_bin = Dir[bootstrap_dir/"**/bun"].find { |p| File.file?(p) }
    odie "Bootstrap bun not found in #{bootstrap_dir}" if bootstrap_bin.nil?
    chmod "+x", bootstrap_bin

    # Generate cmake/sources/*.txt using bun's glob implementation (brace expansion)
    (buildpath/"cmake"/"sources").mkpath
    system bootstrap_bin, "scripts/glob-sources.mjs"

    args = %W[
      -GNinja
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_AR=/usr/bin/ar
      -DCMAKE_RANLIB=/usr/bin/ranlib
      -DUSE_SYSTEM_ZIG=ON
      -DBUN_BOOTSTRAP=ON
      -DBUN_EXECUTABLE=#{bootstrap_bin}
      -DUSE_SYSTEM_LIBUV=ON
      -DUSE_SYSTEM_SQLITE=ON
      -DENABLE_BASELINE=ON
    ]

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
 cmake/targets/BuildBun.cmake |  4 ++++
 cmake/tools/SetupBun.cmake   | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/cmake/targets/BuildBun.cmake b/cmake/targets/BuildBun.cmake
index 64536cc26b..05493136a6 100644
--- a/cmake/targets/BuildBun.cmake
+++ b/cmake/targets/BuildBun.cmake
@@ -1583,3 +1583,7 @@ if(NOT BUN_CPP_ONLY)
     endif()
   endif()
 endif()
+# If bootstrap is disabled, fail fast with actionable guidance.
+if (BUN_BOOTSTRAP STREQUAL "OFF" OR BUN_EXECUTABLE STREQUAL "BUN_BOOTSTRAP_DISABLED")
+  message(FATAL_ERROR "BUN_BOOTSTRAP=OFF requires pre-generated codegen outputs. Upstream must ship them or provide a Node-based generator.")
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
+  set(BUN_EXECUTABLE "BUN_BOOTSTRAP_DISABLED")
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
