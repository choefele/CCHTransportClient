Pod::Spec.new do |spec|
  spec.name     = 'CCHTransportClient'
  spec.version  = '1.1.0'
  spec.license  = 'Copyright Claus Höfele'
  spec.summary  = 'Real-time data from various transportation APIs for iOS and OS X'
  spec.homepage = 'https://github.com/choefele/CCHTransportClient'
  spec.authors  = { 'Claus Höfele' => 'claus@claushoefele.com' }
  spec.social_media_url = 'https://twitter.com/claushoefele'
  spec.source   = { :git => 'https://github.com/choefele/CCHTransportClient.git', :tag => spec.version.to_s }
  spec.frameworks = 'CoreLocation'
  spec.requires_arc = true

  spec.dependency 'Ono', '~> 1.1.0'
  spec.dependency 'CCHBinaryData', '~> 1.0.0'
  spec.dependency 'GZIP', '~> 1.0.0'

  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.source_files = 'CCHTransportClient/**/*.{h,m}'
  spec.private_header_files = 'CCHTransportClient/de.bahn/{*Generator, *Parser, CCHTransportDEBahnClientUtils}.h, CCHTransportClient/de.vbb/{*Generator, *Parser, CCHTransportDEVBBClientUtils}.h'
end
