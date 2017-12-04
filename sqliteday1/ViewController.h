//
//  ViewController.h
//  sqliteday1
//
//  Created by Felix-ITS 004 on 06/10/17.
//  Copyright © 2017 sonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *taskDatabase;
}
@property (strong, nonatomic) IBOutlet UITextField *tf2;
@property NSMutableArray *taskNameArray;
- (IBAction)deletebutton:(id)sender;
- (IBAction)updatebutton:(id)sender;
- (IBAction)inserbutton:(id)sender;
-(BOOL)executeQuery:(NSString *)query;
@property (strong, nonatomic) IBOutlet UITextField *tf1;
-(void)getAlltasks:(NSString *)query;
-(NSString *)getDatabasePath;
-(void)createDatabase;
@property (strong, nonatomic) IBOutlet UITableView *taskTableView;
@property NSMutableArray *  IDArray;

@end

