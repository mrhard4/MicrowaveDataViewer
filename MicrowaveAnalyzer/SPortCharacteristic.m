//
//  SPortCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 20.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "SPortCharacteristic.h"
#import "ComplexMatrix.h"

@implementation SPortCharacteristic

- (ComplexNumber *)valueForFreq:(NSNumber *)freq i:(int)i j:(int)j sMatrix:(ComplexMatrix *)sMatrix {
    return [sMatrix elementForColumn:i row:j];
}

- (NSString *)title {
    return @"S";
}

- (ComplexNumber *)normalizeComplexNumber:(ComplexNumber *)complexNumber {
    return [[complexNumber addNumber:1.] div:[COMPLEX_FROM_NUMBER(1.) sub:complexNumber]];
}

@end
