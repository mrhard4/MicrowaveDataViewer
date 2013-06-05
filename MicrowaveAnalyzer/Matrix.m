//
//  Matrix.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 05.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "Matrix.h"
#import <Accelerate/Accelerate.h>

@implementation Matrix

- (id)initWithFrequency:(double)frequency elements:(double *)elements size:(int)size {
    if ((self = [super init])) {
        _frequency = frequency;
        _elements = elements;
        _size = size;
    }
    return self;
}

- (Matrix *)multiply:(Matrix *)matrix {
    NSAssert(matrix.size == self.size, @"Matrix's have diferent size's");
    
    int stride = 1;//self.size;
    double *result = malloc(self.size * self.size * sizeof(double));
    vDSP_mmulD(self.elements, stride, matrix.elements, stride, result, stride, self.size, self.size, self.size);
    return [[[self class] alloc] initWithFrequency:self.frequency elements:result size:self.size];
}

- (double)elementForColumn:(int)column row:(int)row {
    return self.elements[self.size * row + column];
}

- (double)elementAtIndex:(int)index {
    return self.elements[index];
}

- (void)dealloc {
    free(self.elements);
}

- (NSString *)description {
    NSMutableString *result = [NSMutableString stringWithFormat:@"Frequency = %f\n", self.frequency];
    
    for (int i = 0; i < self.size; i++) {
        for (int j = 0; j < self.size; j++) {
            [result appendFormat:@"%f%@", self.elements[self.size * i + j], j == self.size - 1 ? @"" : @", "];
        }
        [result appendFormat:@"\n"];
    }
    
    return [result copy];
}

@end
