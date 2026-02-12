class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler, and package manager"
  homepage "https://bun.sh/"
  url "https://github.com/oven-sh/bun/archive/refs/tags/bun-v1.3.8.tar.gz"
  sha256 "9714396b53e340387bb2eeb6a92f34a7176d3e1cb73b1dd301f547bd570edcaf"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "esbuild" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build

  depends_on "brotli"
  depends_on "c-ares"
  depends_on "hdrhistogram_c"
  depends_on "highway"
  depends_on "libarchive"
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
  resource "nodejs-headers" do
    url "https://nodejs.org/dist/v24.3.0/node-v24.3.0-headers.tar.gz"
    sha256 "045e9bf477cd5db0ec67f8c1a63ba7f784dedfe2c581e3d0ed09b88e9115dd07"
  end
  resource "lezer-cpp" do
    url "https://registry.npmjs.org/@lezer/cpp/-/cpp-1.1.3.tgz"
    sha256 "c03573bc59c1e8458ea365b1bef6c69025ccad499b1c181f1608a8a090894c0b"
  end
  resource "lezer-common" do
    url "https://registry.npmjs.org/@lezer/common/-/common-1.3.0.tgz"
    sha256 "f39d47d2a032de876151f5d1867d2efe8d1b597edb877f19ea8d92ac4925ce5a"
  end
  resource "lezer-highlight" do
    url "https://registry.npmjs.org/@lezer/highlight/-/highlight-1.2.3.tgz"
    sha256 "5257a530b96473efa7dcfd02adf790d71bc4d6f216e77d3b5842fb26f0b674ef"
  end
  resource "lezer-lr" do
    url "https://registry.npmjs.org/@lezer/lr/-/lr-1.4.3.tgz"
    sha256 "22b56fa117f749e07499ad039158c6efac603f3b419966e630fa48e81b61a01f"
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
    resource("nodejs-headers").stage do
      rm_r buildpath/"vendor/nodejs" if (buildpath/"vendor/nodejs").exist?
      mkdir_p buildpath/"vendor/nodejs"
      cp_r Dir["*"], buildpath/"vendor/nodejs"
      # PrepareNodeHeaders.cmake removes conflicting OpenSSL/libuv headers
      rm_r buildpath/"vendor/nodejs/include/node/openssl" if (buildpath/"vendor/nodejs/include/node/openssl").exist?
      rm_r buildpath/"vendor/nodejs/include/node/uv" if (buildpath/"vendor/nodejs/include/node/uv").exist?
      rm buildpath/"vendor/nodejs/include/node/uv.h" if (buildpath/"vendor/nodejs/include/node/uv.h").exist?
      (buildpath/"vendor/nodejs/include/.node-headers-prepared").write("1")
    end
    # Pre-install @lezer npm packages needed by cppbind.ts (C++ → Zig binding
    # generator). The script auto-runs `bun install` when node_modules is
    # missing, but that hangs inside the Homebrew sandbox (no network).
    %w[lezer-cpp lezer-common lezer-highlight lezer-lr].each do |res|
      scope = res.delete_prefix("lezer-")
      dest = buildpath/"node_modules/@lezer"/scope
      mkdir_p dest
      resource(res).stage { cp_r Dir["*"], dest }
    end
    inreplace "cmake/tools/SetupBun.cmake",
              "if (NOT CI)",
              <<~CMAKE
                if (NOT EXISTS ${BUN_EXECUTABLE})
                  if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
                    if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
                      set(BUN_BOOTSTRAP_FILENAME "bun-darwin-aarch64.zip")
                      set(BUN_BOOTSTRAP_SHA256 "672a0a9a7b744d085a1d2219ca907e3e26f5579fca9e783a9510a4f98a36212f")
                    else()
                      set(BUN_BOOTSTRAP_FILENAME "bun-darwin-x64.zip")
                      set(BUN_BOOTSTRAP_SHA256 "4a0ecd703b37d66abaf51e5bc24fd1249e8dc392c17ee6235710cf51a0988b85")
                    endif()
                  elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
                    set(BUN_BOOTSTRAP_FILENAME "bun-linux-aarch64.zip")
                    set(BUN_BOOTSTRAP_SHA256 "4e9deb6814a7ec7f68725ddd97d0d7b4065bcda9a850f69d497567e995a7fa33")
                  else()
                    set(BUN_BOOTSTRAP_FILENAME "bun-linux-x64.zip")
                    set(BUN_BOOTSTRAP_SHA256 "0322b17f0722da76a64298aad498225aedcbf6df1008a1dee45e16ecb226a3f1")
                  endif()
                  set(BUN_BOOTSTRAP_URL "https://github.com/oven-sh/bun/releases/download/bun-v${VERSION}/${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_ARCHIVE "${CACHE_PATH}/${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_ROOT "${CACHE_PATH}/bootstrap-bun-${VERSION}")
                  string(REPLACE ".zip" "" BUN_BOOTSTRAP_DIRNAME "${BUN_BOOTSTRAP_FILENAME}")
                  set(BUN_BOOTSTRAP_EXTRACTED "${BUN_BOOTSTRAP_ROOT}/${BUN_BOOTSTRAP_DIRNAME}/bun")
                  if(NOT EXISTS "${BUN_BOOTSTRAP_ARCHIVE}")
                    file(
                      DOWNLOAD "${BUN_BOOTSTRAP_URL}" "${BUN_BOOTSTRAP_ARCHIVE}" SHOW_PROGRESS
                      EXPECTED_HASH "SHA256=${BUN_BOOTSTRAP_SHA256}"
                    )
                  endif()
                  if(NOT EXISTS "${BUN_BOOTSTRAP_EXTRACTED}")
                    file(ARCHIVE_EXTRACT INPUT "${BUN_BOOTSTRAP_ARCHIVE}" DESTINATION "${BUN_BOOTSTRAP_ROOT}")
                  endif()
                  if(NOT EXISTS "${BUN_BOOTSTRAP_EXTRACTED}")
                    message(FATAL_ERROR "Failed to extract bootstrap bun: ${BUN_BOOTSTRAP_EXTRACTED}")
                  endif()
                  set(BUN_EXECUTABLE "${BUN_BOOTSTRAP_EXTRACTED}" CACHE FILEPATH "Bun executable" FORCE)
                  message(STATUS "Using downloaded bootstrap Bun: ${BUN_EXECUTABLE}")
                endif()

                if (NOT CI)
              CMAKE
    # Use vendored Node.js headers instead of downloading
    inreplace "cmake/targets/BuildBun.cmake",
              "set(NODEJS_HEADERS_PATH ${VENDOR_PATH}/nodejs)\n\nregister_command(",
              <<~CMAKE
                set(NODEJS_HEADERS_PATH ${VENDOR_PATH}/nodejs)

                if(EXISTS ${NODEJS_HEADERS_PATH}/include/node/node_version.h)
                  message(STATUS "Using vendored Node.js headers")
                  add_custom_target(bun-node-headers)
                else()

                register_command(
              CMAKE
    # Avoid network package installs for bun-error and node-fallbacks
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                register_bun_install(
                  CWD
                    ${BUN_ERROR_SOURCE}
                  NODE_MODULES_VARIABLE
                    BUN_ERROR_NODE_MODULES
                )
              CMAKE
              <<~CMAKE
                set(BUN_ERROR_NODE_MODULES)
                message(STATUS "Skipping bun install for bun-error")
              CMAKE
    react_refresh_define = %q(--define:process.env.NODE_ENV=\"'development'\")
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                register_bun_install(
                  CWD
                    ${BUN_NODE_FALLBACKS_SOURCE}
                  NODE_MODULES_VARIABLE
                    BUN_NODE_FALLBACKS_NODE_MODULES
                )
              CMAKE
              <<~CMAKE
                set(BUN_NODE_FALLBACKS_NODE_MODULES)
                message(STATUS "Skipping bun install for node-fallbacks")
              CMAKE
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                # This command relies on an older version of `esbuild`, which is why
                # it uses ${BUN_EXECUTABLE} x instead of ${ESBUILD_EXECUTABLE}.
                register_command(
                  TARGET
                    bun-node-fallbacks
                  COMMENT
                    "Building node-fallbacks/*.js"
                  CWD
                    ${BUN_NODE_FALLBACKS_SOURCE}
                  COMMAND
                    ${BUN_EXECUTABLE} ${BUN_FLAGS} run build-fallbacks
                      ${BUN_NODE_FALLBACKS_OUTPUT}
                      ${BUN_NODE_FALLBACKS_SOURCES}
                  SOURCES
                    ${BUN_NODE_FALLBACKS_SOURCES}
                    ${BUN_NODE_FALLBACKS_NODE_MODULES}
                  OUTPUTS
                    ${BUN_NODE_FALLBACKS_OUTPUTS}
                )
              CMAKE
              <<~CMAKE
                # This command relies on an older version of `esbuild`, which is why
                # it uses ${BUN_EXECUTABLE} x instead of ${ESBUILD_EXECUTABLE}.
                if(EXISTS ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/assert)
                  register_command(
                    TARGET
                      bun-node-fallbacks
                    COMMENT
                      "Building node-fallbacks/*.js"
                    CWD
                      ${BUN_NODE_FALLBACKS_SOURCE}
                    COMMAND
                      ${BUN_EXECUTABLE} ${BUN_FLAGS} run build-fallbacks
                        ${BUN_NODE_FALLBACKS_OUTPUT}
                        ${BUN_NODE_FALLBACKS_SOURCES}
                    SOURCES
                      ${BUN_NODE_FALLBACKS_SOURCES}
                      ${BUN_NODE_FALLBACKS_NODE_MODULES}
                    OUTPUTS
                      ${BUN_NODE_FALLBACKS_OUTPUTS}
                  )
                else()
                  message(STATUS "Skipping node-fallbacks/*.js (node_modules not installed)")
                  string(REPLACE ";" " " BUN_NODE_FALLBACKS_OUTPUTS_SHELL "${BUN_NODE_FALLBACKS_OUTPUTS}")
                  register_command(
                    TARGET
                      bun-node-fallbacks
                    COMMENT
                      "Generating placeholder node-fallbacks/*.js"
                    COMMAND
                      /bin/sh -c "mkdir -p ${BUN_NODE_FALLBACKS_OUTPUT} && : > /dev/null && touch ${BUN_NODE_FALLBACKS_OUTPUTS_SHELL}"
                    OUTPUTS
                      ${BUN_NODE_FALLBACKS_OUTPUTS}
                  )
                endif()
              CMAKE
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                # An embedded copy of react-refresh is used when the user forgets to install it.
                # The library is not versioned alongside React.
                set(BUN_REACT_REFRESH_OUTPUT ${BUN_NODE_FALLBACKS_OUTPUT}/react-refresh.js)
                register_command(
                  TARGET
                    bun-node-fallbacks-react-refresh
                  COMMENT
                    "Building node-fallbacks/react-refresh.js"
                  CWD
                    ${BUN_NODE_FALLBACKS_SOURCE}
                  COMMAND
                    ${BUN_EXECUTABLE} ${BUN_FLAGS} build
                      ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js
                      --outfile=${BUN_REACT_REFRESH_OUTPUT}
                      --target=browser
                      --format=cjs
                      --minify
                      #{react_refresh_define}
                  SOURCES
                    ${BUN_NODE_FALLBACKS_SOURCE}/package.json
                    ${BUN_NODE_FALLBACKS_SOURCE}/bun.lock
                    ${BUN_NODE_FALLBACKS_NODE_MODULES}
                  OUTPUTS
                    ${BUN_REACT_REFRESH_OUTPUT}
                )
              CMAKE
              <<~CMAKE
                # An embedded copy of react-refresh is used when the user forgets to install it.
                # The library is not versioned alongside React.
                set(BUN_REACT_REFRESH_OUTPUT ${BUN_NODE_FALLBACKS_OUTPUT}/react-refresh.js)
                if(EXISTS ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js)
                  register_command(
                    TARGET
                      bun-node-fallbacks-react-refresh
                    COMMENT
                      "Building node-fallbacks/react-refresh.js"
                    CWD
                      ${BUN_NODE_FALLBACKS_SOURCE}
                    COMMAND
                      ${BUN_EXECUTABLE} ${BUN_FLAGS} build
                        ${BUN_NODE_FALLBACKS_SOURCE}/node_modules/react-refresh/cjs/react-refresh-runtime.development.js
                        --outfile=${BUN_REACT_REFRESH_OUTPUT}
                        --target=browser
                        --format=cjs
                        --minify
                        #{react_refresh_define}
                    SOURCES
                      ${BUN_NODE_FALLBACKS_SOURCE}/package.json
                      ${BUN_NODE_FALLBACKS_SOURCE}/bun.lock
                      ${BUN_NODE_FALLBACKS_NODE_MODULES}
                    OUTPUTS
                      ${BUN_REACT_REFRESH_OUTPUT}
                  )
                else()
                  message(STATUS "Skipping node-fallbacks/react-refresh.js (react-refresh not installed)")
                  register_command(
                    TARGET
                      bun-node-fallbacks-react-refresh
                    COMMENT
                      "Generating placeholder node-fallbacks/react-refresh.js"
                    COMMAND
                      /bin/sh -c "mkdir -p ${BUN_NODE_FALLBACKS_OUTPUT} && : > ${BUN_REACT_REFRESH_OUTPUT}"
                    OUTPUTS
                      ${BUN_REACT_REFRESH_OUTPUT}
                  )
                endif()
              CMAKE
    # Close the else() block for node headers
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                  OUTPUTS
                    ${NODEJS_HEADERS_PATH}/include/node/node_version.h
                    ${NODEJS_HEADERS_PATH}/include/.node-headers-prepared
                )
              CMAKE
              <<~CMAKE
                  OUTPUTS
                    ${NODEJS_HEADERS_PATH}/include/node/node_version.h
                    ${NODEJS_HEADERS_PATH}/include/.node-headers-prepared
                )
                endif()
              CMAKE
    inreplace "cmake/targets/BuildBun.cmake",
              /(\s+OUTPUTS\n\s+\$\{BUN_BINDGENV2_CPP_OUTPUTS\}\n\s+\$\{BUN_BINDGENV2_ZIG_OUTPUTS\}\n)/,
              "\\1  ALWAYS_RUN\n"
    inreplace "cmake/targets/BuildBun.cmake",
              "--platform=browser\n      --minify",
              "--platform=browser\n      --minify\n      --external:peechy"
    bun_error_esbuild_cmd = <<~'CMAKE'.gsub(/^/, "      ")
      bun-error.css
      --outdir=${BUN_ERROR_OUTPUT}
      --define:process.env.NODE_ENV=\"'production'\"
      --minify
      --bundle
      --platform=browser
      --format=esm
    CMAKE
    bun_error_esbuild_replacement = [
      bun_error_esbuild_cmd,
      "      --external:preact",
      "      --external:preact/hooks",
      "      --external:preact/jsx-runtime",
    ].join("\n")
    inreplace "cmake/targets/BuildBun.cmake",
              bun_error_esbuild_cmd,
              bun_error_esbuild_replacement
    # Disable WebKit features bun doesn't use — cmakeconfig.h enables them but
    # required headers (WebGLAny.h, BufferMediaSource.h, DetachedRTCDataChannel.h)
    # are absent.  Patch root.h to override after cmakeconfig.h is included
    # (avoids -Wmacro-redefined with -Werror).
    inreplace "src/bun.js/bindings/root.h",
              '#include "cmakeconfig.h"',
              "#include \"cmakeconfig.h\"\n" \
              "#undef ENABLE_WEBGL\n#define ENABLE_WEBGL 0\n" \
              "#undef ENABLE_MEDIA_SOURCE\n#define ENABLE_MEDIA_SOURCE 0\n" \
              "#undef ENABLE_WEB_RTC\n#define ENABLE_WEB_RTC 0"
    inreplace "cmake/targets/BuildBun.cmake",
              <<~CMAKE,
                if (NOT WIN32)
                  # Enable precompiled headers
                  # Only enable in these scenarios:
                  # 1. NOT in CI, OR
                  # 2. In CI AND BUN_CPP_ONLY is enabled
                  if(NOT CI OR (CI AND BUN_CPP_ONLY))
                    target_precompile_headers(${bun} PRIVATE
                      "$<$<COMPILE_LANGUAGE:CXX>:${CWD}/src/bun.js/bindings/root.h>"
                    )
                  endif()
                endif()
              CMAKE
              <<~CMAKE
                if (NOT WIN32)
                  message(STATUS "Skipping precompiled headers for Homebrew build")
                endif()
              CMAKE
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
    inreplace "src/bun.js/bindings/root.h",
              "#include <JavaScriptCore/JSCJSValue.h>",
              "#include <JSCJSValue.h>"
    inreplace "src/bun.js/bindings/root.h",
              "#include <JavaScriptCore/JSCInlines.h>",
              "#include <JSCInlines.h>"
    inreplace "src/bun.js/bindings/root.h",
              "#include <JavaScriptCore/HandleSet.h>",
              "#include <HandleSet.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/ExceptionHelpers.h>",
              "#include <ExceptionHelpers.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/GCIncomingRefCountedInlines.h>",
              "#include <GCIncomingRefCountedInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/HeapInlines.h>",
              "#include <HeapInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/IdentifierInlines.h>",
              "#include <IdentifierInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSArrayBufferViewInlines.h>",
              "#include <JSArrayBufferViewInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSCJSValueInlines.h>",
              "#include <JSCJSValueInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSCellInlines.h>",
              "#include <JSCellInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSFunctionInlines.h>",
              "#include <JSFunctionInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSGlobalObjectInlines.h>",
              "#include <JSGlobalObjectInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSObjectInlines.h>",
              "#include <JSObjectInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSGlobalProxy.h>",
              "#include <JSGlobalProxy.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/JSString.h>",
              "#include <JSString.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/Operations.h>",
              "#include <Operations.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/SlotVisitorInlines.h>",
              "#include <SlotVisitorInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/StrongInlines.h>",
              "#include <StrongInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/StructureInlines.h>",
              "#include <StructureInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/ThrowScope.h>",
              "#include <ThrowScope.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/WeakGCMapInlines.h>",
              "#include <WeakGCMapInlines.h>"
    inreplace "src/bun.js/bindings/JSCInlines.h",
              "#include <JavaScriptCore/WeakGCSetInlines.h>",
              "#include <WeakGCSetInlines.h>"
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
    # Create a shim directory so #include <JavaScriptCore/X.h> resolves to PrivateHeaders/X.h.
    # The bun source has ~1400 includes using this pattern and the system framework doesn't
    # have these private headers; the shim avoids rewriting every include individually.
    jsc_shim = buildpath/"jsc-include-shim"
    mkdir_p jsc_shim
    inreplace "cmake/tools/SetupWebKit.cmake",
              "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders\n",
              <<~CMAKE
                ${WEBKIT_PATH}/JavaScriptCore.framework/Headers
                ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders
                ${WEBKIT_PATH}/JavaScriptCore.framework/PrivateHeaders
                ${WEBKIT_PATH}/../../Source/JavaScriptCore/dfg
                ${WEBKIT_PATH}/../../Source/JavaScriptCore/runtime
                #{jsc_shim}
              CMAKE
    # Populate the shim at configure time: create a JavaScriptCore directory containing
    # symlinks to headers from PrivateHeaders, public Headers, and Source tree.
    # This resolves all ~1400 #include <JavaScriptCore/X.h> in bun source at once.
    inreplace "cmake/tools/SetupWebKit.cmake",
              "set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)",
              <<~CMAKE.chomp
                set(WEBKIT_INCLUDE_PATH ${WEBKIT_PATH}/include)
                # Create JavaScriptCore include shim for angle-bracket private header includes
                set(JSC_SHIM_DIR "#{jsc_shim}/JavaScriptCore")
                if(NOT EXISTS "${JSC_SHIM_DIR}")
                  file(MAKE_DIRECTORY "${JSC_SHIM_DIR}")
                  # Link PrivateHeaders (bulk of needed headers)
                  foreach(HDIR "${WEBKIT_PATH}/JavaScriptCore.framework/PrivateHeaders"
                               "${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders"
                               "${WEBKIT_PATH}/JavaScriptCore.framework/Headers"
                               "${WEBKIT_PATH}/JavaScriptCore/Headers")
                    if(EXISTS "${HDIR}")
                      file(GLOB _hdrs "${HDIR}/*.h")
                      foreach(_h ${_hdrs})
                        get_filename_component(_name "${_h}" NAME)
                        if(NOT EXISTS "${JSC_SHIM_DIR}/${_name}")
                          file(CREATE_LINK "${_h}" "${JSC_SHIM_DIR}/${_name}" SYMBOLIC)
                        endif()
                      endforeach()
                    endif()
                  endforeach()
                  # Link Source tree headers not in PrivateHeaders (e.g. runtime inlines)
                  set(JSC_SRC "${WEBKIT_PATH}/../../Source/JavaScriptCore")
                  if(EXISTS "${JSC_SRC}")
                    foreach(SUBDIR runtime API heap inspector dfg)
                      if(EXISTS "${JSC_SRC}/${SUBDIR}")
                        file(GLOB _hdrs "${JSC_SRC}/${SUBDIR}/*.h")
                        foreach(_h ${_hdrs})
                          get_filename_component(_name "${_h}" NAME)
                          if(NOT EXISTS "${JSC_SHIM_DIR}/${_name}")
                            file(CREATE_LINK "${_h}" "${JSC_SHIM_DIR}/${_name}" SYMBOLIC)
                          endif()
                        endforeach()
                      endif()
                    endforeach()
                  endif()
                  message(STATUS "Created JSC include shim directory: ${JSC_SHIM_DIR}")
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
    inreplace "cmake/tools/SetupZig.cmake",
              "register_command(",
              <<~CMAKE
                option(USE_SYSTEM_ZIG "Use system Zig from PATH" OFF)
                if (USE_SYSTEM_ZIG)
                  unset(ZIG_EXECUTABLE)
                  unset(ZIG_EXECUTABLE CACHE)
                  find_program(ZIG_EXECUTABLE zig REQUIRED)
                  set(CMAKE_ZIG_FLAGS)
                  add_custom_target(clone-zig)
                  message(STATUS "Using system Zig: ${ZIG_EXECUTABLE}")
                  return()
                endif()
                register_command(
              CMAKE
    inreplace "cmake/tools/SetupEsbuild.cmake",
              "if(CMAKE_HOST_WIN32)",
              <<~CMAKE
                option(USE_SYSTEM_ESBUILD "Use system esbuild from PATH" OFF)
                if(USE_SYSTEM_ESBUILD)
                  find_program(ESBUILD_EXECUTABLE esbuild REQUIRED)
                  message(STATUS "Using system esbuild: ${ESBUILD_EXECUTABLE}")
                  return()
                endif()
                if(CMAKE_HOST_WIN32)
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
    inreplace "cmake/targets/BuildLibArchive.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_LIBARCHIVE "Use system libarchive" OFF)
                if(USE_SYSTEM_LIBARCHIVE)
                  find_package(PkgConfig REQUIRED)
                  pkg_check_modules(LIBARCHIVE REQUIRED IMPORTED_TARGET libarchive)
                  add_library(libarchive INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(libarchive INTERFACE PkgConfig::LIBARCHIVE)
                  message(STATUS "Using system libarchive")
                  return()
                endif()
                register_repository(
              CMAKE
    inreplace "cmake/targets/BuildHdrHistogram.cmake",
              "register_repository(",
              <<~CMAKE
                option(USE_SYSTEM_HDRHISTOGRAM "Use system hdrhistogram_c" OFF)
                if(USE_SYSTEM_HDRHISTOGRAM)
                  find_library(HDR_HISTOGRAM_LIBRARY NAMES hdr_histogram hdr_histogram_static REQUIRED)
                  find_path(HDR_HISTOGRAM_INCLUDE_DIR NAMES hdr/hdr_histogram.h REQUIRED)
                  add_library(hdrhistogram INTERFACE IMPORTED GLOBAL)
                  target_link_libraries(hdrhistogram INTERFACE ${HDR_HISTOGRAM_LIBRARY})
                  target_include_directories(hdrhistogram INTERFACE ${HDR_HISTOGRAM_INCLUDE_DIR})
                  message(STATUS "Using system hdrhistogram_c")
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
    inreplace "cmake/targets/BuildLshpack.cmake",
              "-DLSHPACK_XXH=ON",
              <<~CMAKE.chomp
                -DLSHPACK_XXH=ON
                    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
              CMAKE
    # Zig 0.15.x removed no_link_obj field; guard with @hasField for compatibility
    inreplace "build.zig",
              "obj.no_link_obj = opts.os != .windows and !opts.no_llvm;",
              <<~ZIG.chomp
                if (@hasField(@TypeOf(obj.*), "no_link_obj")) {
                    obj.no_link_obj = opts.os != .windows and !opts.no_llvm;
                }
              ZIG
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
      -DUSE_SYSTEM_LIBUV=ON
      -DUSE_SYSTEM_SQLITE=ON
      -DUSE_SYSTEM_BORINGSSL=ON
      -DUSE_SYSTEM_BROTLI=ON
      -DUSE_SYSTEM_CARES=ON
      -DUSE_SYSTEM_HDRHISTOGRAM=ON
      -DUSE_SYSTEM_HIGHWAY=ON
      -DUSE_SYSTEM_LIBARCHIVE=ON
      -DUSE_SYSTEM_LIBDEFLATE=ON
      -DUSE_SYSTEM_LOLHTML=ON
      -DUSE_SYSTEM_MIMALLOC=ON
      -DUSE_SYSTEM_ESBUILD=ON
      -DUSE_SYSTEM_ZLIB=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DWEBKIT_LOCAL=ON
      -DENABLE_TINYCC=OFF
      -DENABLE_BASELINE=ON
    ]

    # Use system bun for codegen if available (avoids flaky bootstrap download)
    system_bun = Pathname("#{Dir.home}/.bun/bin/bun")
    args << "-DBUN_EXECUTABLE=#{system_bun}" if system_bun.executable?

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

    # build.zig hardcodes vendor/zstd/lib for zstd.h include path used by
    # translate-c.  Point it at the system zstd when using USE_SYSTEM_ZSTD.
    mkdir_p "vendor/zstd"
    ln_s Formula["zstd"].opt_include, "vendor/zstd/lib"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # Generate codegen files first — they are Ninja build targets, not
    # produced during cmake configure.
    system "cmake", "--build", "build", "--target", "bun-zig-generated-classes"

    # The codegen script (generate-classes.ts) produces ZigGeneratedClasses.cpp
    # with jsDynamicCast<WebCore::JSBlob*> but the JSBlob class definition
    # comes from Zig compilation (which hasn't happened yet and won't link in
    # a Homebrew build).  Add a minimal stub so the C++ compiles.
    inreplace "build/codegen/ZigGeneratedClasses.h",
              "class StructuredCloneableDeserialize {",
              <<~CPP
                class JSBlob : public JSDOMObject {
                public:
                    using Base = JSDOMObject;
                    DECLARE_INFO;
                    void* wrapped() const { return m_wrapped; }
                    static size_t memoryCost(void*) { return 0; }
                    template<typename, JSC::SubspaceAccess mode> static JSC::GCClient::IsoSubspace* subspaceFor(JSC::VM& vm)
                    {
                        if constexpr (mode == JSC::SubspaceAccess::Concurrently)
                            return nullptr;
                        return subspaceForImpl(vm);
                    }
                    static JSC::GCClient::IsoSubspace* subspaceForImpl(JSC::VM& vm);
                    static JSC::Structure* createStructure(JSC::VM& vm, JSC::JSGlobalObject* globalObject, JSC::JSValue prototype)
                    {
                        return JSC::Structure::create(vm, globalObject, prototype, JSC::TypeInfo(JSC::ObjectType, StructureFlags), info(), JSC::NonArray);
                    }
                    static void destroy(JSC::JSCell*);
                protected:
                    void* m_wrapped { nullptr };
                    JSBlob(JSC::Structure* structure, JSDOMGlobalObject& globalObject)
                        : Base(structure, globalObject) {}
                };

                class StructuredCloneableDeserialize {
              CPP
    inreplace "build/codegen/ZigGeneratedClasses.cpp",
              "} // namespace WebCore",
              <<~CPP
                const JSC::ClassInfo JSBlob::s_info = { "Blob"_s, &Base::s_info, nullptr, nullptr, CREATE_METHOD_TABLE(JSBlob) };
                JSC::GCClient::IsoSubspace* JSBlob::subspaceForImpl(JSC::VM&) { return nullptr; }
                void JSBlob::destroy(JSC::JSCell*) {}

                } // namespace WebCore
              CPP

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
