// Copyright 2018-present 650 Industries. All rights reserved.

/**
 An extensible react instance creation delegate. This class will loop through each `ExpoReactDelegateHandler` to determine the winner to create the instance.
 */
@objc
public class ExpoReactDelegate: NSObject {
  private let handlers: [ExpoReactDelegateHandler]

  public init(handlers: [ExpoReactDelegateHandler]) {
    self.handlers = handlers
  }

  @objc
  public func createBridge(delegate: ABI49_0_0RCTBridgeDelegate, launchOptions: [AnyHashable: Any]?) -> ABI49_0_0RCTBridge {
    self.handlers.forEach { $0.bridgeWillCreate() }
    let result = self.handlers.lazy
      .compactMap { $0.createBridge(reactDelegate: self, bridgeDelegate: delegate, launchOptions: launchOptions) }
      .first(where: { _ in true }) ?? ABI49_0_0RCTBridge(delegate: delegate, launchOptions: launchOptions)!
    self.handlers.forEach { $0.bridgeDidCreate(bridge: result) }
    return result
  }

  @objc
  public func createRootView(
    bridge: ABI49_0_0RCTBridge,
    moduleName: String,
    initialProperties: [AnyHashable: Any]?,
    fabricEnabled: Bool = ABI49_0_0EXAppDefines.APP_NEW_ARCH_ENABLED
  ) -> UIView {
    return self.handlers.lazy
      .compactMap { $0.createRootView(reactDelegate: self, bridge: bridge, moduleName: moduleName, initialProperties: initialProperties) }
      .first(where: { _ in true }) ?? ABI49_0_0EXAppSetupDefaultRootView(bridge, moduleName, initialProperties, fabricEnabled)
  }

  @objc
  public func createRootViewController() -> UIViewController {
    return self.handlers.lazy
      .compactMap { $0.createRootViewController(reactDelegate: self) }
      .first(where: { _ in true }) ?? UIViewController()
  }
}
