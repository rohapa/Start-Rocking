//
//  main.m
//  Start Rocking
//
//  Created by Java Lancer on 08/08/16.
//  Copyright © 2016 Java Lancer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[]) {
	[[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
	return NSApplicationMain(argc, argv);
}
