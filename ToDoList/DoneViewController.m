//
//  DoneViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "DoneViewController.h"
#import "DoneTableViewCell.h"
#import "EditViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController
{
    NSUserDefaults *def;
    NSMutableArray * filterArray;
    BOOL isFiltered;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = FALSE;
    self.doneFilter.delegate = self;
    def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"doneArray"]mutableCopy]==nil)
    {
        _doneArray = [NSMutableArray new];
    }else
    {
        _doneArray = [[def objectForKey:@"doneArray"]mutableCopy];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    if (_doneDict != nil) {
    [_doneArray addObject:_doneDict];
        [def setObject:_doneArray forKey:@"doneArray"];
        [def synchronize];
        _doneDict = nil;
    [_doneTableView reloadData];
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
   
    DoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"donecell" forIndexPath:indexPath];
    if (isFiltered) {
        cell.doneNameLabel.text = [[filterArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell donePriorityImageView] setTintColor:[UIColor greenColor]];
        } else if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell donePriorityImageView] setTintColor:[UIColor blueColor]];
        } else {
            [[cell donePriorityImageView] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[filterArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        cell.doneDateLabel.text = datePicker;
    }else{
    cell.doneNameLabel.text = [[_doneArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    if ([[[_doneArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
        [[cell donePriorityImageView] setTintColor:[UIColor greenColor]];
    } else if ([[[_doneArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
        [[cell donePriorityImageView] setTintColor:[UIColor blueColor]];
    } else {
        [[cell donePriorityImageView] setTintColor:[UIColor redColor]];
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    NSString *datePicker = [dateFormatter stringFromDate:[[_doneArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
    cell.doneDateLabel.text = datePicker;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    if (isFiltered ) {
        return filterArray.count;
    }else{
        return _doneArray.count;
    }}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_doneArray removeObjectAtIndex:indexPath.row];
    [def setObject:_doneArray forKey:@"doneArray"];
    [def synchronize];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isFiltered) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
        detailVC.detailModelDict = filterArray[indexPath.row];
        detailVC.index = indexPath;
        if ([_doneArray containsObject:filterArray[indexPath.row]]) {
            NSInteger ind = [_doneArray indexOfObject:filterArray[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
    EditViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    detailVC.detailModelDict = _doneArray[indexPath.row];
    detailVC.index = indexPath;

    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.UpdateCell = self;
        }
}
}

-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index : (NSInteger) indexSearch {
    if (isFiltered) {
        if (updatedDict == nil) {
            [_doneTableView reloadData];
        }else {
            [_doneArray removeObjectAtIndex:indexSearch];
            [filterArray removeObjectAtIndex: index];
            [filterArray insertObject:updatedDict atIndex:index];
            [_doneArray addObject:filterArray[index]];
            [def setObject:_doneArray forKey:@"toDoArray"];
            [def synchronize];
            [_doneTableView reloadData];
        }
    }else{
    if (updatedDict == nil) {
        [_doneTableView reloadData];
    }else {
        [_doneArray removeObjectAtIndex: index];
        [_doneArray insertObject:updatedDict atIndex:index];
        [def setObject:_doneArray forKey:@"doneArray"];
        [def synchronize];
        [_doneTableView reloadData];
            }
}

    if (updatedDict == nil) {
        
    }else {
        [_doneArray removeObjectAtIndex: index];
        [_doneArray insertObject:updatedDict atIndex:index];
        [def setObject:_doneArray forKey:@"doneArray"];
        [def synchronize];
        [_doneTableView reloadData];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = FALSE;
    }else{
        isFiltered = TRUE;
        filterArray = [NSMutableArray new];
        for (NSDictionary * dictName in _doneArray) {
            NSRange  nameRange = [[dictName objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filterArray addObject:dictName];
            }
        }
    }
    [self.doneTableView reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isFiltered = FALSE;
    searchBar.text = @"";
    [self.doneTableView reloadData];

}
@end
