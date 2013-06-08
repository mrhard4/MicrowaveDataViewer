//
//  BaseCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseCharacteristic.h"

@implementation Option

- (id)selectedValue {
    return self.values[self.selectedValueIndex];
}

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
        
#define RANDOM_FLOAT (float)(arc4random() % 1000) / 1000.f
        
        self.lineWidth = 2.f;
        self.lineColor = [UIColor colorWithRed:RANDOM_FLOAT green:RANDOM_FLOAT blue:1.f - (RANDOM_FLOAT / 5.f) alpha:1.f];;
    }
    return self;
}

- (NSString *)fullTitle {
    return _fullTitle ? : [self description];
}

- (NSString *)SmithDescription {
    return _fullTitle ? : [self description];
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

- (id)instance {
    return [[[self class] alloc] initWithMeasurement:_measurement];
}

- (id)copyWithZone:(NSZone *)zone {
    BaseCharacteristic *result = [self instance];
    result.options = [NSMutableArray new];
    for (Option *o in self.options) {
        Option *newOption = [Option new];
        newOption.selectedValueIndex = o.selectedValueIndex;
        newOption.values = o.values;
        newOption.title = o.title;
        newOption.parentOption = o.parentOption;
        newOption.parentIndexes = o.parentIndexes;
        [result.options addObject:newOption];
    }
    return result;
}

- (NSArray *)freq {
    return _measurement.freq;
}

+ (double)dbMultiplier {
    return 20.;
}

- (NSString *)optionsDescription {
    Option *o = self.options.count ? self.options[0] : nil;
    return o.selectedValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.title, [self optionsDescription]];
}

- (BOOL)isEqual:(id)object {
    return [self class] == [object class] && [[self description] isEqualToString:[object description]];
}

@end
