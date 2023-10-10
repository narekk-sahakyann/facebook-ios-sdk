//
//  PicsartExperiments.swift
//  FBSDKCoreKit
//
//  Created by Narek Sahakyan on 05.10.23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

@objcMembers
@objc(FBSDKPicsartExperiments)
public final class PicsartExperiments: NSObject {
  private static let syncQueue = DispatchQueue(label: "FBSDKPicsartExperiments", attributes: .concurrent)
  
  // MARK: - Perform Heavy Operations On Background Sync
  
  private static var _performHeavyOperationsOnBackgroundSyncEnabled = false
  
  // Getter
  public static var performHeavyOperationsOnBackgroundSyncEnabled: Bool {
    syncQueue.sync {
      _performHeavyOperationsOnBackgroundSyncEnabled
    }
  }
  
  // Setter
  public static func setPerformHeavyOperationsOnBackgroundSyncEnabled(_ enabled: Bool) {
    syncQueue.async(flags: .barrier) {
      _performHeavyOperationsOnBackgroundSyncEnabled = enabled
    }
  }
}
