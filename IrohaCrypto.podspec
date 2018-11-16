#
# Be sure to run `pod lib lint IrohaCrypto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IrohaCrypto'
  s.version          = '0.1.1'
  s.summary          = 'Provides object oriented wrappers for C/C++ crypto functions used by Iroha blockchain.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ERussel' => 'emkil.russel@gmail.com' }
  s.source           = { :git => 'https://github.com/ERussel/IrohaCrypto.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'IrohaCrypto/Classes/**/*', 'IrohaCryptoImp/**/*.h'
  s.public_header_files = 'IrohaCrypto/Classes/**/*.h'
  s.private_header_files = 'IrohaCryptoImp/**/*.h', 'libsodium-ios/**/*.h'
  s.vendored_libraries = 'IrohaCryptoImp/libed25519.a', 'libsodium-ios/lib/libsodium.a'
  s.preserve_paths = 'IrohaCryptoImp/**/*.h'
  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/IrohaCryptoImp/include/**", 'CLANG_WARN_DOCUMENTATION_COMMENTS' => "NO" }

  s.libraries = 'ed25519', 'sodium'

  s.test_spec do |ts|
      ts.source_files = 'Tests/**/*.{h,m}'
  end

end
