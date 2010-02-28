//
//  main.m
//  TextWrap
//
//  Created by Jiang Jiang on 2/28/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TextWrapper.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSRegisterServicesProvider([TextWrapper new], @"TextWrapService");
    NSUpdateDynamicServices();
    
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
    
    [pool release];
}
