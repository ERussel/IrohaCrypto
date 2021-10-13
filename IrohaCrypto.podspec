#
# Be sure to run `pod lib lint IrohaCrypto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IrohaCrypto'
  s.version          = '0.9.0'
  s.summary          = 'Provides object oriented wrappers for C/C++ crypto functions used by blockchains.'

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ERussel' => 'emkil.russel@gmail.com' }
  s.source           = { :git => 'https://github.com/ERussel/IrohaCrypto.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.subspec 'Common' do |cn|
    cn.source_files = 'IrohaCrypto/Classes/Common/**/*'
    cn.public_header_files = 'IrohaCrypto/Classes/Common/**/*.h'
  end

  s.subspec 'Iroha' do |ir|
    ir.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'VALID_ARCHS' => 'x86_64 armv7 arm64'  }
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
    sr.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'VALID_ARCHS' => 'x86_64 armv7 arm64'  }
    sr.dependency 'IrohaCrypto/blake2'
    sr.dependency 'IrohaCrypto/Common'
    sr.dependency 'IrohaCrypto/BIP39'
    sr.source_files = 'IrohaCrypto/Classes/sr25519/**/*', 'sr25519Imp/**/*.h'
    sr.public_header_files = 'IrohaCrypto/Classes/sr25519/**/*.h'
    sr.private_header_files = 'sr25519Imp/**/*.h'
    sr.vendored_libraries = 'sr25519Imp/libsr25519crust.a'
    sr.preserve_paths = 'sr25519Imp/**/*.h'
  end

  s.subspec 'blake2' do |b2|
    b2.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'VALID_ARCHS' => 'x86_64 armv7 arm64'  }
    b2.source_files = 'IrohaCrypto/Classes/blake2/**/*', 'blake2Imp/**/*.h'
    b2.public_header_files = 'IrohaCrypto/Classes/blake2/**/*.h'
    b2.private_header_files = 'blake2Imp/**/*.h'
    b2.vendored_libraries = 'blake2Imp/libblake2.a'
    b2.preserve_paths = 'blake2Imp/**/*.h'
  end

  s.subspec 'secp256k1' do |secp|
    secp.dependency 'IrohaCrypto/Common'
    secp.dependency 'secp256k1.c', '~> 0.1'
    secp.source_files = 'IrohaCrypto/Classes/secp256k1/**/*'
  end

  s.subspec 'ed25519' do |ed|
    ed.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'VALID_ARCHS' => 'x86_64 armv7 arm64'  }
    ed.dependency 'IrohaCrypto/Common'
    ed.source_files = 'IrohaCrypto/Classes/ed25519/**/*', 'ed25519Imp/**/*.h'
    ed.public_header_files = 'IrohaCrypto/Classes/ed25519/**/*.h'
    ed.private_header_files = 'ed25519Imp/**/*.h'
    ed.vendored_libraries = 'ed25519Imp/libed25519_sha2.a'
    ed.preserve_paths = 'ed25519Imp/**/*.h'
  end

  s.subspec 'ss58' do |ss|
    ss.dependency 'IrohaCrypto/blake2'
    ss.dependency 'IrohaCrypto/Common'
    ss.source_files = 'IrohaCrypto/Classes/ss58/**/*'
    ss.public_header_files = 'IrohaCrypto/Classes/ss58/**/*.h'
  end

  s.pod_target_xcconfig = { 'CLANG_WARN_DOCUMENTATION_COMMENTS' => "NO" }

  s.test_spec do |ts|
      ts.source_files = 'Tests/**/*.{h,m}'
      ts.resources = ['Tests/**/*.json']
  end

end
