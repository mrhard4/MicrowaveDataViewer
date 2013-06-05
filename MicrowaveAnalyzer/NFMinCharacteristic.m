//
//  NFMinCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "NFMinCharacteristic.h"

@implementation NFMinCharacteristic

+ (double)dbMultiplier {
    return 10.;
}

- (NSString *)title {
    return @"NFMin";
}

- (double)valueForFreq:(NSNumber *)freq {
    double v = [[_measurement measurementForFrequency:freq] doubleValue];
    
    return pow(10., v / 10.);
}

@end
