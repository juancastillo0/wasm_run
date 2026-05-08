Pod::Spec.new do |s|
  s.name          = 'wasm_run_flutter'
  s.version       = '0.0.1'
  s.summary       = 'iOS/macOS Flutter bindings for wasm_run'
  s.license       = { :file => '../LICENSE' }
  s.homepage      = 'https://github.com/juancastillo0/wasm_run'
  s.authors       = { 'Juan Manuel Castillo' => '42351046+juancastillo0@users.noreply.github.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
end
