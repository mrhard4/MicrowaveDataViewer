//
//  ABCDCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "ABCDCharacteristic.h"
#import "Measurement.h"
#import "Matrix.h"

@implementation ABCDCharacteristic

- (ComplexNumber *)valueForFreq:(NSNumber *)freq i:(int)i j:(int)j sMatrix:(ComplexMatrix *)sMatrix {
    ComplexNumber *denominator = [[sMatrix elementForColumn:1 row:0] multiplyByNumber:2.];
    ComplexNumber *numerator = nil;
    switch (2 * i + j) {
        case 0: {
            numerator = [[ONE_ADD_S11(sMatrix) multiply:ONE_SUB_S22(sMatrix)] add:S12_MULTIPLY_S21(sMatrix)];
            break;
        }
            
        case 1: {
            numerator = [[[ONE_ADD_S11(sMatrix) multiply:ONE_ADD_S22(sMatrix)] sub:S12_MULTIPLY_S21(sMatrix)] multiplyByNumber:self.R];
            break;
        }
            
        case 2: {
            numerator = [[[ONE_SUB_S11(sMatrix) multiply:ONE_SUB_S22(sMatrix)] sub:S12_MULTIPLY_S21(sMatrix)] divByNumber:self.R];
            break;
        }
            
        case 3: {
            numerator = [[ONE_SUB_S11(sMatrix) multiply:ONE_ADD_S22(sMatrix)] add:S12_MULTIPLY_S21(sMatrix)];
            break;
        }
            
        default:
            return COMPLEX_FROM_NUMBER(0);
    }
    return [numerator div:denominator];
}

- (NSString *)title {
    return @"ABCD";
}

- (ComplexNumber *)normalizeComplexNumber:(ComplexNumber *)complexNumber {
    return [[complexNumber addNumber:1.] div:[COMPLEX_FROM_NUMBER(1.) sub:complexNumber]];
}

- (NSString *)characteristicCharacter {
    NSArray *values = @[@"A", @"B", @"C", @"D"];
    return values[2 * [self.options[OptionTypeToPortIndex] selectedValueIndex] + [self.options[OptionTypeFromPortIndex] selectedValueIndex]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@, %@",
            [self characteristicCharacter],
            [self.options[OptionTypeComplexModifier] selectedValue],
            [self.options[OptionTypeOutputType] selectedValue]];
}

- (NSString *)SmithDescription {
    return [self characteristicCharacter];
}

@end
