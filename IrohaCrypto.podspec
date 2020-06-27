#
# Be sure to run `pod lib lint IrohaCrypto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IrohaCrypto'
  s.version          = '0.4.0'
  s.summary          = 'Provides object oriented wrappers for C/C++ crypto functions used by Iroha blockchain.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ERussel' => 'emkil.russel@gmail.com' }
  s.source           = { :git => 'https://github.com/ERussel/IrohaCrypto.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.subspec 'Common' do |cn|
    cn.source_files = 'IrohaCrypto/Classes/Common/**/*'
    cn.public_header_files = 'IrohaCrypto/Classes/Common/**/*.h'
  end

  s.subspec 'Iroha' do |ir|
    ir.dependency 'IrohaCrypto/Common'
    ir.source_files = 'IrohaCrypto/Classes/Iroha/**/*', 'IrohaCryptoImp/**/*.h'
    ir.public_header_files = 'IrohaCrypto/Classes/Iroha/**/*.h'
    ir.private_header_files = 'IrohaCryptoImp/**/*.h'
    ir.vendored_libraries = 'IrohaCryptoImp/libed25519.a'
    ir.preserve_paths = 'IrohaCryptoImp/**/*.h'
  end

  s.subspec 'BIP39' do |bip39|
    bip39.dependency 'IrohaCrypto/Common'
    bip39.source_files = 'IrohaCrypto/Classes/BIP39/**/*'
    bip39.public_header_files = 'IrohaCrypto/Classes/BIP39/**/*.h'
  end

  s.subspec 'Scrypt' do |sct|
    sct.dependency 'IrohaCrypto/Common'
    sct.dependency 'scrypt.c', '~> 0.1'
    sct.source_files = 'IrohaCrypto/Classes/Scrypt/**/*'
    sct.public_header_files = 'IrohaCrypto/Classes/Scrypt/**/*.h'
  end

  s.subspec 'sr25519' do |sr|
    sr.dependency 'IrohaCrypto/Common'
    sr.dependency 'IrohaCrypto/BIP39'
    sr.source_files = 'IrohaCrypto/Classes/sr25519/**/*', 'sr25519Imp/**/*.h'
    sr.public_header_files = 'IrohaCrypto/Classes/sr25519/**/*.h'
    sr.private_header_files = 'sr25519Imp/**/*.h'
    sr.vendored_libraries = 'sr25519Imp/libsr25519crust.a'
    sr.preserve_paths = 'sr25519Imp/**/*.h'
  end

  s.pod_target_xcconfig = { 'CLANG_WARN_DOCUMENTATION_COMMENTS' => "NO" }

  s.test_spec do |ts|
      ts.source_files = 'Tests/**/*.{h,m}'
      ts.resources = ['Tests/**/*.json']
  end

end
