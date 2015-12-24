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

/// 適した形式に変換
-(id)transformedValue{
	if( self.length == 0 ){
		return @"";
	}
	if ([self isDigit]) {
		return [NSNumber numberWithLongLong:self.longLongValue];
	} else if ([self isBoolean]) {
		return [NSNumber numberWithBool:self.boolValue];
	} else {
		return self;
	}
}

- (BOOL)isDigit{
	/// http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
	NSRange r = [self rangeOfCharacterFromSet: nonDigitsCharSet];
	return r.location == NSNotFound;
}

- (BOOL)isBoolean
{
	return [booleanStrings containsObject:self];
}

@end
