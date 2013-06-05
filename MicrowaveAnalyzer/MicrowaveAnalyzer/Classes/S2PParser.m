//
//  S2PParser.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 02.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "S2PParser.h"
#import "Measurement.h"
#import "Matrix.h"
#import "ComplexMatrix.h"

#define THROW_INVALID_EXEPTION(condition) if ((condition)) @throw [NSException exceptionWithName:@"Invalid S2P file" reason:@"" userInfo:nil]

@interface NSMutableDictionary (Additionals)

- (void)addObject:(id)object forKey:(id)key;

@end

@implementation NSMutableDictionary (Additionals)

- (void)addObject:(id)object forKey:(id)key {
    NSMutableArray *value = self[key];
    if (!value) {
        value = [NSMutableArray new];
        self[key] = value;
    }
    [value addObject:object];
}

@end

@interface NSMutableArray (Additionals)

- (void)removeObjectAtIndexes:(NSArray *)indexes;

@end

@implementation NSMutableArray (Additionals)

- (void)removeObjectAtIndexes:(NSArray *)indexes {
    for (NSNumber *index in indexes) {
        [self removeObjectAtIndex:[index intValue]];
    }
}

@end


@implementation S2PParser

+ (NSArray *)filterValuesArray:(NSArray *)array {
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *string = evaluatedObject;
        return string.length != 0 && [string rangeOfString:@"!"].location == NSNotFound;
    }]];
}

+ (NSArray *)filterValuesArrayFromEmptyStrings:(NSArray *)array {
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *string = evaluatedObject;
        return string.length != 0;
    }]];
}

+ (NSDictionary *)buildMatricesFromValues:(NSMutableArray *)values params:(NSMutableArray *)params {
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"\\Ds{1}\\d{2}"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    NSRegularExpression *numberExpression = [NSRegularExpression regularExpressionWithPattern:@"s{1}\\d{2}"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
    NSMutableDictionary *sParams = [NSMutableDictionary new];
    for (NSString *param in params) {
        if ([expression numberOfMatchesInString:param
                                        options:0
                                          range:NSMakeRange(0, [param length])]) {
            NSString *baseParam = [numberExpression stringByReplacingMatchesInString:param
                                                                             options:NSMatchingWithTransparentBounds
                                                                               range:NSMakeRange(0, [param length])
                                                                        withTemplate:@""];
            if (![[sParams allKeys] containsObject:baseParam]) {
                sParams[baseParam] = [NSMutableArray new];
            }
            [sParams[baseParam] addObject:@([params indexOfObject:param])];
        }
    }
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    if ([sParams count] > 0) {
        
        NSMutableDictionary *matrixIndexes = [NSMutableDictionary new];
        for (NSString *baseParam in [sParams allKeys]) {
            for (NSNumber *paramIndex in sParams[baseParam]) {
                NSString *param = params[[paramIndex intValue]];
                NSString *indexString = [param stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@s", baseParam]
                                                                         withString:@""
                                                                            options:NSCaseInsensitiveSearch
                                                                              range:NSMakeRange(0, param.length)];
                THROW_INVALID_EXEPTION(indexString.length != 2);
                int j = [indexString characterAtIndex:0] - '0' - 1;
                int i = [indexString characterAtIndex:1] - '0' - 1;
                matrixIndexes[paramIndex] = @(sqrt([sParams[baseParam] count]) * i + j);
            }
        }
        
        for (NSMutableArray *paramsValues in values) {
            for (NSString *baseParam in [sParams allKeys]) {
                NSArray *indexes = sParams[baseParam];
                int matrixSize = sqrt([indexes count]);
                double *values = malloc(matrixSize * matrixSize * sizeof(double));
                for (NSNumber *index in indexes) {
                    THROW_INVALID_EXEPTION([index integerValue] >= [paramsValues count]);
                    values[[matrixIndexes[index] intValue]] = [paramsValues[[index intValue]] doubleValue];
                }
                [result addObject:[[Matrix alloc] initWithFrequency:0 elements:values size:matrixSize]
                           forKey:baseParam];
            }
        }
        
        NSMutableArray *indexes = [NSMutableArray new];
        for (id key in [sParams allKeys]) {
            [indexes addObjectsFromArray:sParams[key]];
        }
        [indexes sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"" ascending:NO]]];
        
        [params removeObjectAtIndexes:indexes];
        
        for (NSMutableArray *paramsValues in values) {
            [paramsValues removeObjectAtIndexes:indexes];
        }
    }
    
    return [result copy];
}

+ (NSDictionary *)parceParams:(NSString *)paramsString fromArray:(NSArray *)array {
    NSMutableString *parapmsMutableString = [NSMutableString stringWithString:paramsString];
    NSRegularExpression *e = [NSRegularExpression regularExpressionWithPattern:@"\\([^\\)]*\\)"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSArray *matches = [e matchesInString:paramsString options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [paramsString length])];
    for (NSTextCheckingResult *matchResult in matches) {
        NSString *match = [parapmsMutableString substringWithRange:matchResult.range];
        [parapmsMutableString replaceOccurrencesOfString:match withString:[match stringByReplacingOccurrencesOfString:@" " withString:@"_"]
                                                 options:NSLiteralSearch
                                                   range:NSMakeRange(0, [parapmsMutableString length])];
    }
    paramsString = [parapmsMutableString copy];
    array = [self filterValuesArray:array];
    NSMutableArray *params = [[self filterValuesArrayFromEmptyStrings:
                               [paramsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]
                              mutableCopy];
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:[params count]];
    
    NSMutableArray *allValuesArrays = [NSMutableArray new];
    for (NSString *sourceString in array) {
        id array = [sourceString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        array = [[self filterValuesArrayFromEmptyStrings:array] mutableCopy];
        THROW_INVALID_EXEPTION([params count] != [array count]);
        [allValuesArrays addObject:array];
    }
    
    [values addEntriesFromDictionary:[self buildMatricesFromValues:allValuesArrays params:params]];
    
    for (NSArray *paramsValues in allValuesArrays) {
        THROW_INVALID_EXEPTION([params count] != [paramsValues count]);
        
        for (int i = 0; i < [params count]; i++) {
            [values addObject:@([paramsValues[i] doubleValue]) forKey:params[i]];
        }
    }
    
    return values;
}

+ (NSDictionary *)parse:(NSString *)contentOfFile {
    NSArray *strings = [contentOfFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    __block NSString *infoString = nil;
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj length] && [obj characterAtIndex:0] == '#') {
            infoString = obj;
            *stop = YES;
        }
    }];
    
    NSArray *separators = [strings filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject rangeOfString:@"!Freq"].location != NSNotFound;
    }]];
    
    NSMutableDictionary *mDicts = [NSMutableDictionary new];
    
    for (int i = 0; i < [separators count]; i++) {
        NSString *separator = separators[i];
        int index = [strings indexOfObject:separator] + 1;
        NSRange range = NSMakeRange(index, i == [separators count] - 1 ? [strings count] - index - 1 : [strings indexOfObject:separators[i + 1]] - index);
        [mDicts addEntriesFromDictionary:[self parceParams:separator fromArray:[strings subarrayWithRange:range]]];
    }
    
    NSArray *freq = mDicts[@"!Freq"];
    [mDicts removeObjectForKey:@"!Freq"];
    
    BOOL isReAndIm = NO;
    NSArray *reElements = mDicts[@"Ang"];
    NSArray *imElements = mDicts[@"Mag"];
    if (!reElements || !imElements) {
        reElements = mDicts[@"Re"];
        imElements = mDicts[@"Im"];
        isReAndIm = YES;
    }
    
    NSMutableArray *sElements = [NSMutableArray arrayWithCapacity:[reElements count]];
    for (int i = 0; i < [reElements count]; i++) {
        [sElements addObject:[[ComplexMatrix alloc] initWithReMatrix:reElements[i] imMatrix:imElements[i] isReAndIm:isReAndIm]];
    }
    [mDicts removeObjectForKey:isReAndIm ? @"Re" : @"Ang"];
    [mDicts removeObjectForKey:isReAndIm ? @"Im" : @"Mag"];
    mDicts[@"S"] = sElements;
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *param in [mDicts allKeys]) {
        result[param] = [[Measurement alloc] initWithFreq:freq values:mDicts[param]];
    }
    
    NSArray *partsInfos = [infoString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    partsInfos = [self filterValuesArrayFromEmptyStrings:partsInfos];
    result[@"fString"] = partsInfos[1];
    [partsInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"R"]) {
            result[@"R"] = @([[partsInfos objectAtIndex:idx + 1] doubleValue]);
            *stop = YES;
        }
    }];
    
    THROW_INVALID_EXEPTION(!result[@"R"]);
    THROW_INVALID_EXEPTION(!result[@"fString"]);
    
    return [result copy];
}

@end
