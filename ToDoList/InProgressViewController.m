//
//  InProgressViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "InProgressViewController.h"
#import "InProgressTableViewCell.h"
#import "EditViewController.h"
#import "DoneViewController.h"


@interface InProgressViewController ()

@end

@implementation InProgressViewController
{
    NSUserDefaults *def;
    NSMutableArray * filterArray;
    BOOL isFiltered;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = FALSE;
    self.inProgressFilter.delegate = self;

    def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"inProgressArray"]mutableCopy]==nil)
    {
    _inProgressArray = [NSMutableArray new];
    }else
    {
    _inProgressArray = [[def objectForKey:@"inProgressArray"]mutableCopy];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    if (_inProgressDict != nil) {
    [_inProgressArray addObject:_inProgressDict];
        [def setObject:_inProgressArray forKey:@"inProgressArray"];
        [def synchronize];
    _inProgressDict = nil;
    [_inProgressTableView reloadData];
    }
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
   
    if (isFiltered ) {
        return filterArray.count;
    }else{
        return _inProgressArray.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inprogresscell" forIndexPath:indexPath];
    if (isFiltered) {
        cell.inProgressNameLabel.text = [[filterArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell inProgressImage] setTintColor:[UIColor greenColor]];
        } else if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell inProgressImage] setTintColor:[UIColor blueColor]];
        } else {
            [[cell inProgressImage] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[filterArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        cell.inProgressDateLabel.text = datePicker;
    }else{
    cell.inProgressNameLabel.text = [[_inProgressArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    if ([[[_inProgressArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
        [[cell inProgressImage] setTintColor:[UIColor greenColor]];
    } else if ([[[_inProgressArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
        [[cell inProgressImage] setTintColor:[UIColor blueColor]];
    } else {
        [[cell inProgressImage] setTintColor:[UIColor redColor]];
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    NSString *datePicker = [dateFormatter stringFromDate:[[_inProgressArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
    cell.inProgressDateLabel.text = datePicker;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_inProgressArray removeObjectAtIndex:indexPath.row];
    [def setObject:_inProgressArray forKey:@"inProgressArray"];
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
        if ([_inProgressArray containsObject:filterArray[indexPath.row]]) {
            NSInteger ind = [_inProgressArray indexOfObject:filterArray[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
            [_inProgressTableView reloadData];
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.UpdateCell = self;
        
    }else{
    EditViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    detailVC.detailModelDict = _inProgressArray[indexPath.row];
    detailVC.index = indexPath;

    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.UpdateCell = self;
    }
}


-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index : (NSInteger)indexSearch {
    if (isFiltered) {
        if (updatedDict == nil) {
            [_inProgressTableView reloadData];
        }else {
            [_inProgressArray removeObjectAtIndex:indexSearch];
            [filterArray removeObjectAtIndex: index];
            [filterArray insertObject:updatedDict atIndex:index];
            [_inProgressArray addObject:filterArray[index]];
            [def setObject:_inProgressArray forKey:@"toDoArray"];
            [def synchronize];
            [_inProgressTableView reloadData];
        }
    }else{
    if (updatedDict == nil) {
        [_inProgressTableView reloadData];
    }else {
        [_inProgressArray removeObjectAtIndex: index];
        [_inProgressArray insertObject:updatedDict atIndex:index];
        [def setObject:_inProgressArray forKey:@"inProgressArray"];
        [def synchronize];
        [_inProgressTableView reloadData];
            }
}
//    if (updatedDict == nil) {
//        [_inProgressTableView reloadData];
//    }else {
//        [_inProgressArray removeObjectAtIndex: index];
//        [_inProgressArray insertObject:updatedDict atIndex:index];
//        [def setObject:_inProgressArray forKey:@"inProgressArray"];
//        [def synchronize];
//        [_inProgressTableView reloadData];
//    }
}
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UIContextualAction *Done =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
        title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        NSArray *viewControllers = [self.tabBarController viewControllers];
        UINavigationController * myNavController = (UINavigationController *)viewControllers[2];
        DoneViewController *myController = [[myNavController childViewControllers]firstObject];
        myController.doneDict = self->_inProgressArray[indexPath.row];
        [self.inProgressArray removeObjectAtIndex:indexPath.row];
        [self->def setObject:self->_inProgressArray forKey:@"inProgressArray"];
        [self->def synchronize];
        [self->_inProgressTableView reloadData];
            
        completionHandler(YES);
    }];
    [Done setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    Done.backgroundColor =[UIColor greenColor];

    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions: @[Done]];
    return swipeActionConfig;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = FALSE;
    }else{
        isFiltered = TRUE;
        filterArray = [NSMutableArray new];
        for (NSDictionary * dictName in _inProgressArray) {
            NSRange  nameRange = [[dictName objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filterArray addObject:dictName];
            }
        }
    }
    [self.inProgressTableView reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isFiltered = FALSE;
    searchBar.text = @"";
    [self.inProgressTableView reloadData];

}
@end


