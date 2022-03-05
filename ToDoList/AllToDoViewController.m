//
//  ViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "AllToDoViewController.h"
#import "AddViewController.h"
#import "AllToDoTableViewCell.h"
#import "DataModel.h"
#import "EditViewController.h"
#import "InProgressViewController.h"
#import "DoneViewController.h"
@interface AllToDoViewController ()

@end

@implementation AllToDoViewController

{
    NSUserDefaults *def;
    NSMutableArray * filterArray;
    BOOL isFiltered;
//    BOOL isGrantedNotification;
//    UNUserNotificationCenter *center;
//    UNAuthorizationOptions option;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    isGrantedNotification = FALSE;
    isFiltered = FALSE;
    self.allTodoSearch.delegate = self;
    def = [NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"dictArray"]mutableCopy]==nil) {
        _dictArray = [NSMutableArray new];
    }else {
        _dictArray = [[def objectForKey:@"dictArray"]mutableCopy];
        }


}



- (IBAction)addBtnTapped:(UIBarButtonItem *)sender {

    AddViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addVC"];
    [self.navigationController pushViewController:addVC animated:YES];
    [addVC setAdd:self];
}


- (void)saveMethodDict:(NSMutableDictionary *)dict {
    
 
    [_dictArray addObject:dict];
    [def setObject:_dictArray forKey:@"dictArray"];
    [def synchronize];
    
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:options
        completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted) {
                NSLog(@"Something went wrong");
            }
        }];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        
        content.title = [dict objectForKey:@"title"];
        content.body = [dict objectForKey:@"detail"];
        content.sound = [UNNotificationSound defaultSound];
        NSDate *date = [dict objectForKey:@"date"];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                      components:NSCalendarUnitYear +
                      NSCalendarUnitMonth + NSCalendarUnitDay +
                      NSCalendarUnitHour + NSCalendarUnitMinute +
                      NSCalendarUnitSecond fromDate:date];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
          triggerWithDateMatchingComponents:triggerDate repeats:NO];

        NSString *identifier = [dict objectForKey:@"title"];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                              content:content trigger:trigger];

        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Something went wrong: %@",error);
            }
        }];
    
          
    

    [_allTableView reloadData];
   
}
//- (NSTimeInterval)timeIntervalSinceDate:(NSDate *)anotherDate
//{
//
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered ) {
        return filterArray.count;
    }else{
    return _dictArray.count;
    }
    }

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AllToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alltodocell" forIndexPath:indexPath];
    if (isFiltered) {
  
        cell.nameLabel.text = [[filterArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
            [[cell priorityImageView] setTintColor:[UIColor greenColor]];
        } else if ([[[filterArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
            [[cell priorityImageView] setTintColor:[UIColor blueColor]];
        } else {
            [[cell priorityImageView] setTintColor:[UIColor redColor]];
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
        NSString *datePicker = [dateFormatter stringFromDate:[[_dictArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
        cell.dateLabel.text = datePicker;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        
   
    cell.nameLabel.text = [[_dictArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    if ([[[_dictArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Low"]) {
        [[cell priorityImageView] setTintColor:[UIColor greenColor]];
    } else if ([[[_dictArray objectAtIndex:indexPath.row]objectForKey:@"prio"] isEqualToString:@"Medium"]) {
        [[cell priorityImageView] setTintColor:[UIColor blueColor]];
    } else {
        [[cell priorityImageView] setTintColor:[UIColor redColor]];
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    NSString *datePicker = [dateFormatter stringFromDate:[[_dictArray  objectAtIndex:indexPath.row]objectForKey:@"dateCreated"]];
    cell.dateLabel.text = datePicker;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (isFiltered) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
        detailVC.detailModelDict = filterArray[indexPath.row];
        detailVC.index = indexPath;
        if ([_dictArray containsObject:filterArray[indexPath.row]]) {
            NSInteger ind = [_dictArray indexOfObject:filterArray[indexPath.row]];
            detailVC.indexSearch = ind;
        }else {
            [_allTableView reloadData];
        }
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
        detailVC.UpdateCell = self;
        
    }else{
    EditViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    detailVC.detailModelDict = _dictArray[indexPath.row];
    detailVC.index = indexPath;

    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.UpdateCell = self;
    }
}


-(void) updateMehodDic:(NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger) indexSearch; {
    if (isFiltered) {
        if (updatedDict == nil) {
            [_allTableView reloadData];
        }else {
            [_dictArray removeObjectAtIndex:indexSearch];
            [filterArray removeObjectAtIndex: index];
            [filterArray insertObject:updatedDict atIndex:index];
            [_dictArray addObject:filterArray[index]];
            [def setObject:_dictArray forKey:@"toDoArray"];
            [def synchronize];
            [_allTableView reloadData];
        }
    }else{
    if (updatedDict == nil) {
        [_allTableView reloadData];
    }else {
        [_dictArray removeObjectAtIndex: index];
        [_dictArray insertObject:updatedDict atIndex:index];
        [def setObject:_dictArray forKey:@"dictArray"];
        [def synchronize];
        [_allTableView reloadData];
    }
}
}
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return true;
//}

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UIContextualAction *inProgress =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
        title:@"InProgress" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSArray *viewControllers = [self.tabBarController viewControllers];
        UINavigationController * myNavController = (UINavigationController *)viewControllers[1];
        InProgressViewController *myController = [[myNavController childViewControllers]firstObject];
        if (self->isFiltered) {
            if ([self->_dictArray containsObject:self->filterArray[indexPath.row]]) {
                NSInteger ind = [self->_dictArray indexOfObject:self->filterArray[indexPath.row]];
                myController.inProgressDict = self->_dictArray[ind];
                [self->filterArray removeObjectAtIndex:indexPath.row];
                [self.dictArray removeObjectAtIndex:ind];
                [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                [self->def synchronize];
                [[self allTableView] reloadData];
            }
            [self.tabBarController setSelectedIndex:1];
        }else{
        myController.inProgressDict = self->_dictArray[indexPath.row];
        [self.dictArray removeObjectAtIndex:indexPath.row];
        [self->def setObject:self->_dictArray forKey:@"dictArray"];
        [self->def synchronize];
        [self->_allTableView reloadData];
        [self.tabBarController setSelectedIndex:1];

        }
        completionHandler(YES);
    }];
    [inProgress setImage:[UIImage systemImageNamed:@"increase.indent"]];
    inProgress.backgroundColor =[UIColor blueColor];


    UIContextualAction *Done =[UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
        title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        NSArray *viewControllers = [self.tabBarController viewControllers];
        UINavigationController * myNavController = (UINavigationController *)viewControllers[2];
        DoneViewController *myController = [[myNavController childViewControllers]firstObject];
        if (self->isFiltered) {
            if ([self->_dictArray containsObject:self->filterArray[indexPath.row]]) {
                NSInteger ind = [self->_dictArray indexOfObject:self->filterArray[indexPath.row]];
                myController.doneDict = self->_dictArray[ind];
                [self->filterArray removeObjectAtIndex:indexPath.row];
                [self.dictArray removeObjectAtIndex:ind];
                [self->def setObject:self->_dictArray forKey:@"toDoArray"];
                [self->def synchronize];
                [[self allTableView] reloadData];
            }
            [self.tabBarController setSelectedIndex:2];

        }else{
        myController.doneDict = self->_dictArray[indexPath.row];
        [self.dictArray removeObjectAtIndex:indexPath.row];
        [self->def setObject:self->_dictArray forKey:@"dictArray"];
        [self->def synchronize];
        [self->_allTableView reloadData];
        [self.tabBarController setSelectedIndex:2];

        }
        completionHandler(YES);
    }];
    [Done setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    Done.backgroundColor =[UIColor greenColor];

    UISwipeActionsConfiguration *swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions: @[inProgress, Done]];

    return swipeActionConfig;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_dictArray removeObjectAtIndex:indexPath.row];
    [def setObject:_dictArray forKey:@"dictArray"];
    [def synchronize];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = FALSE;
    }else{
        isFiltered = TRUE;
        filterArray = [NSMutableArray new];
        for (NSDictionary * dictName in _dictArray) {
            NSRange  nameRange = [[dictName objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filterArray addObject:dictName];
            }
        }
    }
    [self.allTableView reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isFiltered = FALSE;
    searchBar.text = @"";
    [self.allTableView reloadData];

}

//-(void) notificationMethod : (NSDate*)date : (NSDictionary *)dict{
//
//    if(isGrantedNotification){
//     center = [UNUserNotificationCenter currentNotificationCenter];
//
//         option = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
//    [center requestAuthorizationWithOptions:option completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!granted) {
//        NSLog(@"Something went wrong");
//        }
//        UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
//        content.title = @"Reminder Notification";
//        content.subtitle = [dict objectForKey:@"title"];
//        content.body =  [dict objectForKey:@"detail"];
//        content.sound = [UNNotificationSound defaultSound];
////        date = [dict objectForKey:@"date"];
//        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
//        components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute +NSCalendarUnitSecond fromDate:date];
//        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
//        NSString *identifier = @"Reminder Notification";
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
//
//        [self->center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//         if (error != nil) {
//           NSLog(@"Something went wrong: %@",error);
//         }
//         }];
//
//    }];
//
//
//
//
//
//
//
//            }
        
    
    


@end
