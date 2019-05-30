//
//  ActivityManager.swift
//  location-practice
//
//  Created by jinsei_shima on 2019/05/31.
//  Copyright © 2019 jinsei_shima. All rights reserved.
//

import Foundation
import CoreMotion

public class ActivityManager: CMMotionActivityManager {
    
    let pedometer = CMPedometer()
    let activity =  CMMotionActivityManager()
    
    var pedmeterString = ""
    var activityString = ""
    
    public func getPedmeter() {
        
        if CMPedometer.isStepCountingAvailable() == false { return }
        
        let now = Date()
        let from = Date(timeInterval: -60*60*24*7, since: now)
        
        CMPedometer().queryPedometerData(from: from, to: now, withHandler: { (data: CMPedometerData, error: Error) in
            print(data)
            } as! CMPedometerHandler)
    }
    
    public func startActivity() {
        
        if CMMotionActivityManager.isActivityAvailable() != true { return }
        
        startActivityUpdates(to: OperationQueue.main, withHandler: { data in
            print(data ?? "")
        })
    }
    
    public func getStep() {
        
        if CMPedometer.isStepCountingAvailable() == false { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let midnight = formatter.string(from: Date())
        let fromDateString = midnight + " 00:00:00"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fromDate = formatter.date(from: fromDateString)!
        //        let toDate = Date()
        
        pedometer.startUpdates(from: fromDate, withHandler: { data, error in
            
            guard let data = data else { return }
            
            let stepNumber = data.numberOfSteps
            let distance = data.distance ?? 0
            let step = String(describing: stepNumber)
            
            self.pedmeterString = String(format: "%@ steps, %.1f m", step, distance.floatValue)
            
//            Notification.notification(title: "Movement", subTitle: "pedometer update", body: self.pedmeterString)
        })
        
        activity.startActivityUpdates(to: OperationQueue.current!, withHandler: { data in
            
            guard let data = data else { return }
            
            let isStationary = data.stationary
            let isWalking = data.walking
            let isRunning = data.running
            let isAutomotive = data.automotive
            let isCycling = data.cycling
            let isUnknow = data.unknown
            
            self.activityString = "station : \(isStationary), walk : \(isWalking), run : \(isRunning), automotive : \(isAutomotive), cycle : \(isCycling), unknow : \(isUnknow)"
            
//            Notification.notification(title: "Movement", subTitle: "activity update", body: self.activityString)
        })
    }
}
