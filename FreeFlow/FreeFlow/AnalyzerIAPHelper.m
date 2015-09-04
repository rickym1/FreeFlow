//
//  AnalyzerIAPHelper.m
//  dripcalculator
//
//  Created by rick m on 9/3/15.
//  Copyright (c) 2015 FreeFlowAppDevelopers. All rights reserved.
//

#import "AnalyzerIAPHelper.h"

@implementation AnalyzerIAPHelper

+ (AnalyzerIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static AnalyzerIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.doggydog.dripcalculator.inappanalyzer",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
