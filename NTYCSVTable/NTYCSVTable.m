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

@implementation NTYCSVTable{
	BOOL _withHeader;
}

- (instancetype)initWithString:(NSString*)str columnSeparator:(NSString *)separator withHeader:(BOOL)withHeader{
	self = [super init];
	if (self) {
		_withHeader = withHeader;
		self.columnSeperator = separator;
		NSString* csvString = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
		[self parseHeadersFromLines:lines];
		[self parseRowsFromLines:lines];
		if( withHeader ){
			[self parseColumnsFromLines:lines];
		}
	}
	return self;
}

- (instancetype)initWithString:(NSString*)str columnSeparator:(NSString *)separator{
	return [self initWithString:str columnSeparator:separator withHeader:YES];
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
	NSUInteger initialCount = 0;
	if( _withHeader ){
		initialCount = 1;// ヘッダ付きデータの場合、0行目はヘッダなので1からにします。
	}
	for (NSUInteger i=initialCount; i<len1; i++) {
		NSString* line = lines[i];
		NSArray *values = [line componentsSeparatedByString:self.columnSeperator];
		if( _withHeader ){
			[rows addObject:[self createRowDictFromLineValues:values]];
		} else {
			[rows addObject:[self createRowArrayFromLineValues:values]];
		}
	}
	self.rows = [NSArray arrayWithArray:rows];
}

-(NSDictionary*)createRowDictFromLineValues:(NSArray*)values{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	NSUInteger len = self.headers.count;
	for (NSUInteger j=0; j<len; j++) {
		NSString* header = self.headers[j];
		NSString *value = values[j];
		dict[header] = [value transformedValue];
	}
	return dict;
}

-(NSArray*)createRowArrayFromLineValues:(NSArray*)values{
	NSMutableArray *ary = [NSMutableArray new];
	NSUInteger len = self.headers.count;
	for (NSUInteger j=0; j<len; j++) {
		NSString *value = values[j];
		[ary addObject:[value transformedValue]];
	}
	return ary;
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
