//
//  NSString+NTYNonStringHandling.m
//  NTYCSVTable
//
//  Created by Naoto Kaneko on 2014/04/15.
//  Copyright (c) 2014 Naoto Kaneko. All rights reserved.
//

#import "NSString+NTYNonStringHandling.h"

@implementation NSString (NTYNonStringHandling)

static NSCharacterSet *digitCharacterSet = nil;
static NSArray *booleanStrings = nil;

+ (void)load
{
	if (!digitCharacterSet) {
		digitCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	}
	
	if (!booleanStrings) {
		booleanStrings = @[@"YES", @"NO", @"yes", @"no", @"TRUE", @"FALSE", @"true", @"false"];
	}
}

- (BOOL)isDigit{
	NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
	return r.location == NSNotFound;
}

- (BOOL)isBoolean
{
	return [booleanStrings containsObject:self];
}

@end
