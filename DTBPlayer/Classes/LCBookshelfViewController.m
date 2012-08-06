//
//  LCBookshelfViewController.m
//  DTBPlayer
//
//  Created by Jason Harwig on 8/6/12.
//  Copyright (c) 2012 Jason Harwig. All rights reserved.
//

#import "LCBookshelfViewController.h"

#define TITLE_KEY @"title"
#define AUTHOR_KEY @"author"

@implementation LCBookshelfViewController
NSArray *books;

- (void)viewDidLoad
{
    books = @[
        @{ TITLE_KEY : @"In the garden of beasts", AUTHOR_KEY : @"Larson, Erik." },
        @{ TITLE_KEY : @"The immortal life of Henrietta Lacks", AUTHOR_KEY : @"Skloot, Rebecca" }
    ];
    
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [books count] : 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 56 : 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookshelfcell"];
    
    NSDictionary *book = books[indexPath.row];
    cell.textLabel.text = book[TITLE_KEY];
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = book[AUTHOR_KEY];
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Books" : @"Magazines";
}

@end
