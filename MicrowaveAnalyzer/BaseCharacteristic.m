//
//  BaseCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseCharacteristic.h"

@implementation Option

@end



@implementation BaseCharacteristic

- (id)initWithMeasurement:(Measurement *)measurement {
    if ((self = [super init])) {
        _measurement = measurement;
        _options = [NSMutableArray new];
        
        Option *option = [Option new];
        option.values = @[@"no db", @"db"];
        option.title = @"Output format";
        
        [_options addObject:option];
    }
    return self;
}

- (double)minValue {
    double min = MAXFLOAT;
    for (NSNumber *f in _measurement.freq) {
        double val = [self localizedValueForFreq:f];
        if (min > val) {
            min = val;
        }
    }
    return min;
}

- (double)maxValue {
    double max = -MAXFLOAT;
    for (NSNumber *f in _measurement.freq) {
        double val = [self localizedValueForFreq:f];
        if (max < val) {
            max = val;
        }
    }
    return max;
}

- (NSString *)title {
    return nil;
}

- (double)localizedValueForFreq:(NSNumber *)freq {
    BOOL inDB = OPTION_VALUE(0) == 1;
    double result = [self valueForFreq:freq];
    if (inDB) {
        result = [[self class] dbMultiplier] * log10(fabs(result));
    }
    return isnan(result) ? 0. : result;
}

- (double)valueForFreq:(NSNumber *)freq {
    return 0;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSArray *)freq {
    return _measurement.freq;
}

+ (double)dbMultiplier {
    return 20.;
}

@end
