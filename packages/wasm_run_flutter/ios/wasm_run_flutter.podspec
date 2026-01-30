# wasm_run_flutter iOS podspec
#
# The native library is now built by wasm_run_native via Cargokit.
# This podspec is kept minimal as Flutter's FFI plugin mechanism will
# automatically link the native library from wasm_run_native.

Pod::Spec.new do |s|
  s.name          = 'wasm_run_flutter'
  s.version       = '0.1.0'
  s.summary       = 'Flutter bindings for wasm_run'
  s.description   = <<-DESC
Flutter plugin that provides native bindings for wasm_run.
The native library is built from source by wasm_run_native.
                    DESC
  s.license       = { :file => '../LICENSE' }
  s.homepage      = 'https://github.com/juancastillo0/wasm_run'
  s.authors       = { 'Juan Manuel Castillo' => '42351046+juancastillo0@users.noreply.github.com' }

  s.source        = { :path => '.' }
  s.source_files  = 'Classes/**/*'

  s.ios.deployment_target = '12.0'

  # Native library is provided by wasm_run_native dependency
  s.dependency 'wasm_run_native'
end
