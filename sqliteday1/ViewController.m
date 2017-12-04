//
//  ViewController.m
//  sqliteday1
//
//  Created by Felix-ITS 004 on 06/10/17.
//  Copyright © 2017 sonal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDatabase];
    NSString *selectQuery=@"select taskId,taskName from taskTable";
    
    
    [self getAlltasks:selectQuery];
    if(self.taskNameArray.count >0)
    {
        self.taskTableView.delegate=self;
        self.taskTableView.dataSource=self;
    }
    NSLog(@"task Name array contains %@",self.taskNameArray);
    
    //Do any additional setup after loading the view, typically from a nib.
}
-(void)createDatabase
{
    NSString *createQuery=@"create table if not exists taskTable(taskId text,taskName text)";
    BOOL success=[self executeQuery:createQuery];
    if(success)
    {
        NSLog(@"Table created");
    }
}

-(NSString *)getDatabasePath
{
    NSArray *docArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[[docArray firstObject]stringByAppendingString:@"/myTaskDatabase.db"];
    //NSString *docPath=[NSString stringWithFormat:@"%@/myTaskDatabase.db",[docArray lastObject]];
    NSLog(@"%@",docPath);
    return docPath;
}
- (IBAction)deletebutton:(id)sender {
    
    NSString *str = _tf1.text;
    int id = [str intValue];
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM taskTable WHERE taskId==%i",id];

    NSInteger c = _taskNameArray.count;
    BOOL isSucess= [self executeQuery:deleteSQL];
    if(isSucess && c>0)
    {
        [self executeQuery:deleteSQL];
         NSString *selectQuery=@"select taskId,taskName from taskTable";
        c--;
       // _taskNameArray.count-=1;
        [self getAlltasks:selectQuery];
        if(c>0)
          [self.taskTableView reloadData];
}
  

    NSLog(@"done");

}

- (IBAction)updatebutton:(id)sender {
    NSString *str = _tf1.text;
    int id = [str intValue];
    NSString *tnstr = _tf2.text;
    //NSInteger c = _taskNameArray.count;
    
    NSString *updateQuery=[NSString stringWithFormat:@"update taskTable set taskName = '%@' where taskId = '%d'",tnstr,id];
    BOOL isSucess= [self executeQuery:updateQuery];
    if(isSucess && self.taskNameArray.count >0)
    {
        [self executeQuery:updateQuery];
        
        NSString *selectQuery=@"select taskId,taskName from taskTable";

        
        [self getAlltasks:selectQuery];
        
        [self.taskTableView reloadData];
    }
    
    NSLog(@"%@",updateQuery);
    
    
    
}

- (IBAction)inserbutton:(id)sender {
    
    NSString *insertQuery=[NSString stringWithFormat:@"insert into taskTable(taskId,taskName) values('%@','%@')",_tf1.text,_tf2.text];
   BOOL isSucess= [self executeQuery:insertQuery];
    if(isSucess && self.taskNameArray.count >0)
    {
        NSString *selectQuery=@"select taskId,taskName from taskTable";
        
        
        [self getAlltasks:selectQuery];

        [self.taskTableView reloadData];
    }
    
    NSLog(@"%@",insertQuery);
}
-(void)getAlltasks:(NSString *)query
{
    self.taskNameArray=[[NSMutableArray alloc]init];
    _IDArray = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    const char *cQuery=[query UTF8String];
    const char *databasePath=[[self getDatabasePath] UTF8String];
    if(sqlite3_open(databasePath,&taskDatabase)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(taskDatabase,cQuery,-1,&statement,NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                unsigned const char *tName=sqlite3_column_text(statement,1);
                NSString *tasknm=[NSString stringWithFormat:@"%s",tName];
                [self.taskNameArray addObject:tasknm];
                
                unsigned const char *tID=sqlite3_column_text(statement,0);
                NSString *taskID=[NSString stringWithFormat:@"%s",tID];
                [self.IDArray addObject:taskID];

                
            }
            
        }
        else
        {
            NSLog(@"%s in sqlite prepare v2",sqlite3_errmsg(taskDatabase));
            
        }
    }
    else
    {
        NSLog(@"%s in sqlite opening database",sqlite3_errmsg(taskDatabase));
    }
    sqlite3_close(taskDatabase);
    sqlite3_finalize(statement);

}

-(BOOL)executeQuery:(NSString *)query
{
    BOOL success=0;
    sqlite3_stmt *statement;
    const char *cQuery=[query UTF8String];
   const char *databasePath=[[self getDatabasePath] UTF8String];
    if(sqlite3_open(databasePath,&taskDatabase)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(taskDatabase,cQuery,-1,&statement,NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                success=1;
            }
            else
            {
                NSLog(@"%s in sqlite step",sqlite3_errmsg(taskDatabase));
            }
        }
        else
        {
            NSLog(@"%s in sqlite prepare v2",sqlite3_errmsg(taskDatabase));
 
        }
    }
    else
    {
        NSLog(@"%s in sqlite opening database",sqlite3_errmsg(taskDatabase));

    }
    sqlite3_close(taskDatabase);
    sqlite3_finalize(statement);
    return success;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _taskNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    cell.textLabel.text= [_taskNameArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_IDArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[_taskNameArray objectAtIndex:indexPath.row]);
    //cell.detailTextLabel.text=@"honey";
    return cell;
}

@end
