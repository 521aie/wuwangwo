//
//  NSDictionary+LB.m
//  CardApp
//
//  Created by sheldon on 15/2/5.
//  Copyright (c) 2015年 2dfire.com. All rights reserved.
//

#import "NSDictionary+LB.h"

@implementation NSDictionary(LB)

- (BOOL)containKey:(NSString *)key {
    return [[self allKeys] containsObject:key];
}

- (id)safeObjectForKey:(NSString *)key {
    
    if ([self containKey:key]) {
        id value = [self objectForKey:key];
        if (value != nil && [value isKindOfClass:[NSNull class]]) {
            return nil;
        } else if (value != nil && [value isKindOfClass:[NSString class]] && [value isEqualToString:@"null"]) {
            return nil;
        } else if (value != nil && [value isKindOfClass:[NSString class]] && [value length] == 0) {
            return nil;
        }
        return value;
    }
    
    return nil;
}

-(NSString *)safeObjectForKeyFloat:(NSString *)key decimal:(int)decimal {
    id value = [self safeObjectForKey:key];
    if (value) {
        NSMutableString *format = [[NSMutableString alloc] init];
        [format appendString:@"0"];
        for (int i = 0; i < decimal; i++) {
            if (i == 0) {
                [format appendString:@".0"];
            } else {
                [format appendString:@"0"];
            }
            
        }
        
        float f = [value floatValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:format];
        NSString *formattedNumberString = [formatter stringFromNumber:[NSNumber numberWithFloat:f]];
        return formattedNumberString;
    } else {
        return @"0";
    }
}


- (int)cardResultCode
{
    id value = [self safeObjectForKey:@"resultCode"];
    if (value) {
        return [value intValue];
    } else {
        return 0;
    }
}

- (id)cardResultModel {
    id value = [self safeObjectForKey:@"model"];
    return value;
}

- (NSString *)safeObjectForKeyPrice:(NSString *)key {
    return [self safeObjectForKeyFloat:key decimal:2];
}


-(NSString *)dataTojsonString {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
