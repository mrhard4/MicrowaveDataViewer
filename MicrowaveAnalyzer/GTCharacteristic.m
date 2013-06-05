//
//  GTCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 27.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GTCharacteristic.h"
#import "ComplexMatrix.h"
#import "ComplexNumber.h"

@implementation GTCharacteristic

- (NSString *)title {
    return @"GT";
}

- (double)valueForFreq:(NSNumber *)freq {
    ComplexMatrix *sMatrix = [_measurement measurementForFrequency:freq];
    //return [sMatrix elementForColumn:1 row:0].im * [sMatrix elementForColumn:1 row:0].im;
    return [sMatrix elementForColumn:1 row:0].mag * [sMatrix elementForColumn:1 row:0].mag;
}

+ (double)dbMultiplier {
    return 10.;
}

@end
