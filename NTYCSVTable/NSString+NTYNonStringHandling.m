//
//  NSString+NTYNonStringHandling.m
//  NTYCSVTable
//
//  Created by Naoto Kaneko on 2014/04/15.
//  Copyright (c) 2014 Naoto Kaneko. All rights reserved.
//

#import "NSString+NTYNonStringHandling.h"

@implementation NSString (NTYNonStringHandling)

static NSCharacterSet *nonDigitsCharSet = nil;
static NSArray *booleanStrings = nil;

+ (void)load
{
	if (!nonDigitsCharSet) {
		nonDigitsCharSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	}
	
	if (!booleanStrings) {
		booleanStrings = @[@"YES", @"NO", @"yes", @"no", @"TRUE", @"FALSE", @"true", @"false"];
	}
}

- (BOOL)isDigit{
	NSRange r = [self rangeOfCharacterFromSet: nonDigitsCharSet];
	return r.location == NSNotFound;
}

- (BOOL)isBoolean
{
	return [booleanStrings containsObject:self];
}

@end
