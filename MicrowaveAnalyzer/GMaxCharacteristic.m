//
//  GMaxCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 24.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GMaxCharacteristic.h"
#import "ComplexMatrix.h"
#import "ComplexNumber.h"

@implementation GMaxCharacteristic

+ (double)dbMultiplier {
    return 10.;
}

- (NSString *)title {
    return @"GMax";
}

- (double)valueForFreq:(NSNumber *)freq {
    ComplexMatrix *sMatrix = [_measurement measurementForFrequency:freq];
    
    ComplexNumber *result = [[sMatrix elementForColumn:1 row:0] div:[sMatrix elementForColumn:0 row:1]];
    
    return result.mag;
}

- (id)initWithMeasurement:(Measurement *)measurement {
    if ((self = [super initWithMeasurement:measurement])) {
        //[self.options removeAllObjects];
    }
    return self;
}

@end
