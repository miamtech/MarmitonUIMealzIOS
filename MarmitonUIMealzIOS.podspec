Pod::Spec.new do |spec|
    spec.name         = 'MarmitonUIMealzIOS'
    spec.version      = '5.0.0'
    spec.summary      = 'Marmitom Mealz UI iOS SDK'
    spec.description  = <<-DESC
        Marmitom Mealz UI iOS SDK.
        DESC

    spec.homepage     = 'https://www.miam.tech'
    spec.license      = "GPLv3"
    spec.author             = { "Diarmuid McGonagle" => "it@miam.tech" }
    spec.source       = { :git => "https://github.com/miamtech/MarmitonUIMealzIOS.git", :tag => "#{spec.version}" }
    spec.platform     = :ios, "12.0"
    spec.swift_version = '5.8'
    spec.dependency 'MealzCoreRelease', '~> 5.0.0'
    spec.dependency 'MealziOSSDKRelease', '~> 5.0.0'
    spec.static_framework = true
end
