# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

inhibit_all_warnings!

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

def install_pods
    # Pods for Code Bible
    
    pod 'lottie-ios'
    pod 'CryptoSwift'
    pod 'ColiseuPlayer', :git => 'https://github.com/ricardopereira/ColiseuPlayer'
    pod 'URITemplate', :git => 'https://github.com/SentulAsia/URITemplate.swift'
end

def install_test_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'Mockingjay'
end

target 'Code Bible' do
    # Pods for Code Bible
    install_pods
end

target 'Code Bible Dev' do
    # Pods for Code Bible Dev
    install_pods
end

target 'Code BibleTests' do
    inherit! :search_paths
    
    # Pods for Code BibleTests
    install_test_pods
end

target 'Code BibleUITests' do
    inherit! :search_paths

    # Pods for Code BibleTests
end
