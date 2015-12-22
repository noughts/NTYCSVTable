//
//  NTYCSVTableTSVTests.m
//  NTYCSVTable
//
//  Created by 森下 健 on 2014/04/26.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NTYCSVTable.h"

@interface NTYCSVTableTSVTests : XCTestCase
@property (nonatomic) NTYCSVTable *table;
@end

@implementation NTYCSVTableTSVTests

- (void)setUp
{
    [super setUp];
    NSURL *csvURL = [[NSBundle bundleForClass:self.class] URLForResource:@"sample" withExtension:@"tsv"];
    self.table = [[NTYCSVTable alloc] initWithContentsOfURL:csvURL columnSeparator:@"\t"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHeaders
{
    NSArray *expect = @[@"id", @"name", @"age", @"adult"];
    XCTAssertEqualObjects(self.table.headers, expect, @"");
}

- (void)testRows
{
    NSArray *expect = @[
                        @{@"id": @1, @"name": @"Alice", @"age": @18, @"adult": @NO},
                        @{@"id": @2, @"name": @"Bob", @"age": @19, @"adult": @NO},
                        @{@"id": @3, @"name": @"Char123lie", @"age": @1396383555363, @"adult": @YES}
                        ];
    XCTAssertEqualObjects(self.table.rows, expect, @"%@", self.table.rows);
}

- (void)testColumns
{
    NSDictionary *expect = @{
                             @"id": @[@1, @2, @3],
                             @"name": @[@"Alice", @"Bob", @"Char123lie"],
                             @"age": @[@18, @19, @1396383555363],
                             @"adult": @[@NO, @NO, @YES]
                             };
    XCTAssertEqualObjects(self.table.columns, expect, @"%@", self.table.columns);
}

- (void)testRowsOfValuesForHeader
{
    NSArray *actual;
    NSArray *expect;
    
    actual = [self.table rowsOfValue:@1396383555363 forHeader:@"age"];
    expect = @[
               @{@"id": @3, @"name": @"Char123lie", @"age": @1396383555363, @"adult": @YES}
               ];
    XCTAssertEqualObjects(actual, expect, @"");
    
    actual = [self.table rowsOfValue:@"Bob" forHeader:@"name"];
    expect = @[
               @{@"id": @2, @"name": @"Bob", @"age": @19, @"adult": @NO}
               ];
    XCTAssertEqualObjects(actual, expect, @"");
}


@end
