//
//  AppDelegate.swift
//  Start Rocking
//
//  Created by Adhithyan Vijayakumar on 17/06/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var isStarted: Bool!
    let userName = NSUserName()
    var task:NSTask!
    let pipe = NSPipe()
    let startMenuItem = NSMenuItem()
    let quitMenuItem = NSMenuItem()
    let menu = NSMenu()
    var block: dispatch_block_t!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        isStarted = false
        startMenuItem.title = "Start/Stop"
        //startMenuItem.keyEquivalent = "s"
        startMenuItem.action = Selector("control:")
        
        quitMenuItem.title = "Quit"
        //quitMenuItem.keyEquivalent = "q"
        quitMenuItem.action = Selector("terminate:")
        
        menu.addItem(startMenuItem)
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image = NSImage(named: "on")
        }
        
        block = {
            self.control("");
        };
        
        control("")
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        //showNotification("Stopped Rocking !")
        
    }
    
    func control(sender: AnyObject){
        if !isStarted{
            isStarted = true
            statusItem.button!.image = NSImage(named: "on")
            
            task = NSTask()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["/Users/" + userName + "/Desktop/spotify-notify.scpt"]
            task.launch()
            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(310) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), block)
        }else{
            if task.running{
                task.terminate()
                //showNotification("Script killed before full execution.")
            }else{
                //showNotification("Script completed execution.")
            }
            
            isStarted = false
            statusItem.button!.image = NSImage(named: "off")
            //startMenuItem.title = "Start"
        }
    }
    
    func showNotification(message: NSString) -> Void{
        let notification = NSUserNotification()
        notification.title = "Start Rocking"
        notification.informativeText = message as String
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
}

