//
//  FlularkFlutterViewController.swift
//  flulark
//
//  Created by 项重飞 on 2022/11/10.
//

import Foundation
import LarkSSO

import Flutter
import LarkSSO


class FlularkFlutterViewController: UIViewController , LarkSSODelegate{
        func lkSSODidReceive(response: SSOResponse) {
            if SwiftFlularkPlugin.useChallengeCode {
                response.safeHandleResultWithCodeVerifier(success: { (code, codeVerifier) in
                    let map = [SwiftFlularkPlugin.FLU_LARK_CALLBACK:code]
                    SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod(SwiftFlularkPlugin.FLU_LARK_SUCCESS_CALLBACK, arguments: map)

                }, failure: { (error) in
                    let map = [SwiftFlularkPlugin.FLU_LARK_CALLBACK:"\(error)"]
                    SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod(SwiftFlularkPlugin.FLU_LARK_ERROR_CALLBACK, arguments: map)
                })
            } else {
                response.safeHandleResult { (code) in
                    let map = [SwiftFlularkPlugin.FLU_LARK_CALLBACK:code]
                                    SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod(SwiftFlularkPlugin.FLU_LARK_SUCCESS_CALLBACK, arguments: map)

                } failure: { (error) in
                    switch error.type {
                    case .cancelled: break
                    default:
                         let map = [SwiftFlularkPlugin.FLU_LARK_CALLBACK:"\(error)"]
                                        SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod(SwiftFlularkPlugin.FLU_LARK_ERROR_CALLBACK, arguments: map)

                        break
                    }
                }
            }
        }
}
