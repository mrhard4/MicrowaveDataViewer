//
//  ComplexMatrix.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 19.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "ComplexMatrix.h"
#import "ComplexNumber.h"

@implementation ComplexMatrix {
    NSArray *_elements;
}

- (id)initWithReMatrix:(Matrix *)reMatrix imMatrix:(Matrix *)imMatrix isReAndIm:(BOOL)isReAndIm {
    if ((self = [super init])) {
        NSMutableArray *elements = [NSMutableArray new];
        
        for (int i = 0; i < reMatrix.size * reMatrix.size; i++) {
            ComplexNumber *number = nil;
            if (isReAndIm) {
                number = [[ComplexNumber alloc] initWithReal:[reMatrix elementAtIndex:i] imaginary:[imMatrix elementAtIndex:i]];
            } else {
                number = [[ComplexNumber alloc] initWithAng:[reMatrix elementAtIndex:i] mag:[imMatrix elementAtIndex:i]];
            }
            [elements addObject:number];
        }
        _elements = [elements copy];
    }
    return self;
}

- (ComplexNumber *)elementForColumn:(int)column row:(int)row {
    int size = sqrt([_elements count]);
    return _elements[size * row + column];
}

@end
