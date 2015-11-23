//
//  ViewController.m
//  Plus
//
//  Created by 茆明辉 on 15/11/23.
//  Copyright © 2015年 com.mmh. All rights reserved.
//

#import "ViewController.h"

#define DBNAME    @"personinfo.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weixin.jpg"]];
//    
//    UILabel *leable = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 50, 50)];
//    leable.text = @"用户名";
//    leable.textColor = [UIColor redColor];
//    
//    leable.textAlignment = NSTextAlignmentLeft;
//    leable.font = [UIFont systemFontOfSize:14.0f];
//    
//    
//    [self.view addSubview:leable];
//    
//    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 60, 50, 50)];
//    [btn setTitle:@"登录" forState:UIControlStateNormal];
//
//    [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [self.view addSubview:btn];
//    
//    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 100, 100, 50)];
//    slider.minimumValue = 0.0;
//    slider.maximumValue = 50.0;
//    [self.view addSubview:slider];
//    
//    UISwitch *_switch = [[UISwitch alloc]initWithFrame:CGRectMake(50, 150, 50, 50)];
//    [self.view addSubview:_switch];
//    
//    
//    NSArray *arr = [[NSArray alloc]initWithObjects:@"第一",@"第二",@"第三", nil];
//    UISegmentedControl *semg = [[UISegmentedControl alloc]initWithItems:arr];
//    semg.tintColor = [UIColor whiteColor];
//    semg.frame = CGRectMake(50, 200, 200, 20);
//    [self.view addSubview:semg];
//    
//    UIProgressView *_pro = [[UIProgressView alloc]initWithFrame:CGRectMake(50, 300, 50, 50)];
//    _pro.progressViewStyle = UIProgressViewStyleDefault;
//    [self.view addSubview:_pro];
//    
//    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(50, 350, 50, 50)];
//    field.text = @"测试";
//    [self.view addSubview:field];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    NSLog(@"%@",database_path);//打印数据库路径
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }else{
        NSLog(@"打开成功");
        
    }
    
    //创建数据库命令
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [self execSql:sqlCreateTable];
    
    
    //插入数据
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"西城区"];
    
    NSString *sql2 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"老六", @"20", @"东城区"];
    [self execSql:sql1];
    [self execSql:sql2];

    
    //查询数据库
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(db);
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
