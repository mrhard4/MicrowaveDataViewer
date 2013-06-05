//
//  HPortCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 22.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "HPortCharacteristic.h"

@implementation HPortCharacteristic

- (ComplexNumber *)valueForFreq:(NSNumber *)freq i:(int)i j:(int)j sMatrix:(ComplexMatrix *)sMatrix {
    ComplexNumber *denominator = [[ONE_SUB_S11(sMatrix) multiply:ONE_ADD_S22(sMatrix)] add:S12_MULTIPLY_S21(sMatrix)];
    ComplexNumber *numerator = nil;
    switch (2 * i + j) {
        case 0: {
            numerator = [[[ONE_ADD_S11(sMatrix) multiply:ONE_ADD_S22(sMatrix)] sub:S12_MULTIPLY_S21(sMatrix)] multiplyByNumber:self.R];
            break;
        }
            
        case 1: {
            numerator = [[sMatrix elementForColumn:0 row:1] multiplyByNumber:2.];
            break;
        }
            
        case 2: {
            numerator = [[sMatrix elementForColumn:1 row:0] multiplyByNumber:-2.];
            break;
        }
            
        case 3: {
            numerator = [[[ONE_SUB_S11(sMatrix) multiply:ONE_SUB_S22(sMatrix)] sub:S12_MULTIPLY_S21(sMatrix)] divByNumber:self.R];
            break;
        }
            
        default:
            return COMPLEX_FROM_NUMBER(0);
    }
    return [numerator div:denominator];
}

- (NSString *)title {
    return @"H";
}

- (ComplexNumber *)normalizeComplexNumber:(ComplexNumber *)complexNumber {
    return [[complexNumber addNumber:1.] div:[COMPLEX_FROM_NUMBER(1.) sub:complexNumber]];
}

@end
