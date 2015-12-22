//
//  NTYCSVTable.m
//  NTYCSVTable
//
//  Created by Naoto Kaneko on 2014/04/15.
//  Copyright (c) 2014 Naoto Kaneko. All rights reserved.
//

#import "NTYCSVTable.h"
#import "NSString+NTYNonStringHandling.h"

@interface NTYCSVTable ()
@property (nonatomic) NSArray *headers;
@property (nonatomic) NSArray *rows;
@property (nonatomic) NSDictionary *columns;
@property (nonatomic) NSString *columnSeperator;
@end

@implementation NTYCSVTable

- (instancetype)initWithString:(NSString*)str columnSeparator:(NSString *)separator{
	self = [super init];
	if (self) {
		self.columnSeperator = separator;
		NSString* csvString = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
		[self parseHeadersFromLines:lines];
		[self parseRowsFromLines:lines];
		[self parseColumnsFromLines:lines];
	}
	return self;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url columnSeparator:(NSString *)separator {
	NSString *csvString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	return [self initWithString:csvString columnSeparator:separator];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url
{
	return [self initWithContentsOfURL:url columnSeparator:@","];
}

- (NSArray *)rowsOfValue:(id)value forHeader:(NSString *)header
{
	NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:header]
																rightExpression:[NSExpression expressionForConstantValue:value]
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:0];
	return [self.rows filteredArrayUsingPredicate:predicate];
}

#pragma mark - Private methods

- (void)parseHeadersFromLines:(NSArray *)lines
{
	NSString *headerLine = lines.firstObject;
	self.headers = [headerLine componentsSeparatedByString:self.columnSeperator];
}

- (void)parseRowsFromLines:(NSArray *)lines{
	NSMutableArray *rows = [NSMutableArray new];
	NSUInteger len1 = lines.count;
	for (NSUInteger i=1; i<len1; i++) {// 0行目はヘッダなので1からにします。
		NSString* line = lines[i];
		NSArray *values = [line componentsSeparatedByString:self.columnSeperator];
		NSMutableDictionary *row = [NSMutableDictionary new];
		NSUInteger len2 = self.headers.count;
		for (NSUInteger j=0; j<len2; j++) {
			NSString* header = self.headers[j];
			NSString *value = values[j];
			if ([value isDigit]) {
				row[header] = [NSNumber numberWithLongLong:value.longLongValue];
			} else if ([value isBoolean]) {
				row[header] = [NSNumber numberWithBool:value.boolValue];
			} else {
				row[header] = values[j];
			}
		}
		//        [rows addObject:[NSDictionary dictionaryWithDictionary:row]];
		[rows addObject:row];
	}
	self.rows = [NSArray arrayWithArray:rows];
}

- (void)parseColumnsFromLines:(NSArray *)lines
{
	NSMutableDictionary *columns = [NSMutableDictionary new];
	for (NSString *header in self.headers) {
		NSMutableArray *values = [NSMutableArray new];
		for (NSDictionary *row in self.rows) {
			[values addObject:row[header]];
		}
		columns[header] = [NSArray arrayWithArray:values];
	}
	self.columns = [NSDictionary dictionaryWithDictionary:columns];
}

@end
