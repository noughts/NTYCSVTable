//
//  NTYCSVTableTSVTests.m
//  NTYCSVTable
//
//  Created by 森下 健 on 2014/04/26.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NTYCSVTable.h"

@interface TSVWithoutHeaderTests : XCTestCase
@property (nonatomic) NTYCSVTable *table;
@end

@implementation TSVWithoutHeaderTests

- (void)setUp
{
	[super setUp];
	NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"sampleWithoutHeader" withExtension:@"tsv"];
	NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	self.table = [[NTYCSVTable alloc] initWithString:string columnSeparator:@"\t" withHeader:NO];
}

- (void)tearDown
{
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}


- (void)testRows
{
	NSArray *expect = @[
						@[@1, @"Alice", @18, @NO],
						@[@2, @"Bob", @19, @NO],
						@[@3, @"Char123lie", @1396383555363, @YES]
						];
	XCTAssertEqualObjects(self.table.rows, expect, @"%@", self.table.rows);
}




@end
