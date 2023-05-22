release_tag_name = 'wasm_run-v0.0.1' # generated; do not edit

# We cannot distribute the XCFramework alongside the library directly,
# so we have to fetch the correct version here.
framework_name = 'WasmRun.xcframework'
remote_zip_name = "#{framework_name}.zip"
url = "https://github.com/juancastillo0/wasm_interpreter/releases/download/#{release_tag_name}/#{remote_zip_name}"
local_zip_name = "#{release_tag_name}.zip"
`
cd Frameworks
rm -rf #{framework_name}

if [ ! -f #{local_zip_name} ]
then
  curl -L #{url} -o #{local_zip_name}
fi

unzip #{local_zip_name}
cd -
`

Pod::Spec.new do |s|
  s.name          = 'flutter_wasm_run'
  s.version       = '0.0.1'
  s.summary       = 'iOS/macOS Flutter bindings for wasm_run'
  s.license       = { :file => '../LICENSE' }
  s.homepage      = 'https://github.com/juancastillo0/wasm_interpreter'
  s.authors       = { 'Juan Manuel Castillo' => '42351046+juancastillo0@users.noreply.github.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.vendored_frameworks = "Frameworks/#{framework_name}"

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.11'
end
