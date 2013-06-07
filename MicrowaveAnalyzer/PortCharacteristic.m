//
//  PortCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 20.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "PortCharacteristic.h"


@implementation PortCharacteristic

- (id)instance {
    return [[[self class] alloc] initWithMeasurement:_measurement R:_R];
}

- (id)initWithMeasurement:(Measurement *)measurement R:(double)R {
    if ((self = [super initWithMeasurement:measurement])) {
        _R = R;
        
        Option *option = [Option new];
        option.title = @"Complex Modifier";
        option.values = @[@"Real", @"Imag.", @"Mag.", @"Angle"];
        [self.options addObject:option];
        
        Option *dbOption = self.options[OptionTypeOutputType];
        dbOption.parentOption = option;
        dbOption.parentIndexes = [@[@(0), @(1), @(2)] mutableCopy];
        
        option = [Option new];
        option.title = @"To port index";
        option.values = @[@"1", @"2"];
        [self.options addObject:option];
        
        option = [Option new];
        option.title = @"From port index";
        option.values = @[@"1", @"2"];
        [self.options addObject:option];
    }
    return self;
}

- (ComplexNumber *)complexForFreq:(NSNumber *)freq {
    return [self valueForFreq:freq
                            i:OPTION_VALUE(OptionTypeToPortIndex)
                            j:OPTION_VALUE(OptionTypeFromPortIndex)
                      sMatrix:[_measurement measurementForFrequency:freq]];
}

- (double)valueForFreq:(NSNumber *)freq {
    ComplexNumber *n = [self complexForFreq:freq];
    
    switch (OPTION_VALUE(OptionTypeComplexModifier)) {
        case ComplexModifierReal:
            return n.re;
            
        case ComplexModifierImag:
            return n.im;
            
        case ComplexModifierMag:
            return n.mag;
            
        case ComplexModifierAngle:
            return n.ang;
            
        default:
            return 0;
    }
}

- (NSArray *)complexNumbers {
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSNumber *freq in _measurement.freq) {
        [result addObject:[self normalizeComplexNumber:[self complexForFreq:freq]]];
    }
    
    return [result copy];
}

- (ComplexNumber *)normalizeComplexNumber:(ComplexNumber *)complexNumber {
    return nil;
}

- (ComplexNumber *)valueForFreq:(NSNumber *)freq i:(int)i j:(int)j sMatrix:(ComplexMatrix *)sMatrix {
    return 0;
}

- (NSString *)optionsDescription {
    return [NSString stringWithFormat:@"%@%@, %@, %@",
            [self.options[OptionTypeToPortIndex] selectedValue],
            [self.options[OptionTypeFromPortIndex] selectedValue],
            [self.options[OptionTypeComplexModifier] selectedValue],
            [super optionsDescription]];
}

@end
