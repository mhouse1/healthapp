//
//  WPContentDB.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPContentDB.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

static FMDatabaseQueue *dbQueue = nil;

#pragma mark - DB check

static void checkErr(const FMDatabase *aDb)
{
    if ([aDb hadError]) {
        NSLog(@"DB Err %d: %@", [aDb lastErrorCode], [aDb lastErrorMessage]);
    }
}

static NSString* checkNSString(NSString *aNSStr)
{
    return [aNSStr length] == 0 ? @"" : aNSStr;
}

@implementation WPContentDB

#pragma mark - init

- (void)open
{
    //获取路径数组
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //选择创建的文件信息
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DateBase.db"];
    NSLog(@"dbPath %@", dbPath);
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [self createAllTable];
}

- (void)close
{
    [dbQueue close];
}

- (void)dealloc
{
    [self close];
}

+ (WPContentDB *)shared
{
    static WPContentDB *contentDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentDB = [[WPContentDB alloc] init];
        
        [contentDB open];
    });
    return contentDB;
}

#pragma mark - create table

- (void)createAllTable
{
    [self createPlanListTable];
    [self createCurrentUserTable];
}

- (void)createPlanListTable
{
    [dbQueue inDatabase:^(FMDatabase *aDB) {
        BOOL result = [aDB executeUpdate:@"CREATE TABLE IF NOT EXISTS PlanList (plan_id varchar(255), user_id varchar(255), iconNameColor varchar(255), iconNameWhite varchar(255), planName varchar(255), selectedTime varchar(255), canSelectedTimeList varchar(255), isPlanFinished varchar(255), summary varchar(1024), sportTime varchar(255), dayOfWeek varchar(255), notifyStatus varchar(255), PRIMARY KEY (plan_id, user_id))"];
        NSLog(@"createPlanListTable result: %i",result);
    }];
}

- (void)createCurrentUserTable
{
    [dbQueue inDatabase:^(FMDatabase *aDB) {
        BOOL result = [aDB executeUpdate:@"CREATE TABLE IF NOT EXISTS CurrentUser (user_id varchar(255) NOT NULL, user_name varchar(255), password varchar(255), user_nick varchar(255), icon varchar(255), gender varchar(255), height varchar(255), weight varchar(255), area varchar(255), birthday varchar(255), continueDayCount varchar(255), lastWorkDate varchar(255), planFinishedDateList varchar(2048), coinCountOfEveryDay varchar(255), totalCoinCount varchar(255), wakeUpCoinCount varchar(255), breakfastCoinCount varchar(255), lunchCoinCount varchar(255), dinnerCoinCount varchar(255), waterCoinCount varchar(255), bianbianCoinCount varchar(255), sleepCoinCount varchar(255), youyangSportCoinCount varchar(255), wuyangSportCoinCount varchar(255), wakeUpAndSleepSwitch varchar(255), waterSwitch varchar(255), eatSwitch varchar(255), sportsSwitch varchar(255), caredPersonSwitch varchar(255), PRIMARY KEY (user_id))"];
        NSLog(@"createCurrentUserTable result: %i",result);
    }];
}

#pragma mark - exit

- (void)clearContentCurrentUserInfo
{
    [dbQueue inTransaction:^(FMDatabase *aDB, BOOL *aRollback) {
        [aDB executeUpdate:@"DELETE FROM PlanList"];
        [aDB executeUpdate:@"DELETE FROM CurrentUser"];
        checkErr(aDB);
    }];
}

#pragma mark - current plan

- (void)insertContentPlan:(WPContentPlan *)aContentPlan
{
    if (!aContentPlan) {
        return;
    }
    
    NSString *canSelectedTimeList = [aContentPlan.canSelectedTimeArray componentsJoinedByString:@"&"];

    [dbQueue inDatabase:^(FMDatabase *aDB) {
        [aDB executeUpdate:@"INSERT OR REPLACE INTO PlanList(plan_id, user_id, iconNameColor, iconNameWhite, planName, selectedTime, canSelectedTimeList, isPlanFinished, summary, sportTime, dayOfWeek, notifyStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
         checkNSString(aContentPlan.plan_id),
         checkNSString(aContentPlan.user_id),
         checkNSString(aContentPlan.iconNameColor),
         checkNSString(aContentPlan.iconNameWhite),
         checkNSString(aContentPlan.planName),
         checkNSString(aContentPlan.selectedTime),
         checkNSString(canSelectedTimeList),
         checkNSString(aContentPlan.isPlanFinished),
         checkNSString(aContentPlan.summary),
         checkNSString(aContentPlan.sportTime),
         checkNSString(aContentPlan.dayOfWeek),
         checkNSString(aContentPlan.notifyStatus)];
        checkErr(aDB);
    }];
}

- (void)updateContentPlan:(WPContentPlan *)aContentPlan
{
    if (!aContentPlan) {
        return;
    }
    
    NSString *canSelectedTimeList = [aContentPlan.canSelectedTimeArray componentsJoinedByString:@"&"];

    [dbQueue inDatabase:^(FMDatabase *aDB) {
        [aDB executeUpdate:@"UPDATE PlanList SET iconNameColor = ?, iconNameWhite = ?, planName = ?, selectedTime = ?, canSelectedTimeList = ?, isPlanFinished = ?, summary = ?, sportTime = ?, dayOfWeek = ?, notifyStatus = ? WHERE plan_id = ? and user_id = ?",
         checkNSString(aContentPlan.iconNameColor),
         checkNSString(aContentPlan.iconNameWhite),
         checkNSString(aContentPlan.planName),
         checkNSString(aContentPlan.selectedTime),
         checkNSString(canSelectedTimeList),
         checkNSString(aContentPlan.isPlanFinished),
         checkNSString(aContentPlan.summary),
         checkNSString(aContentPlan.sportTime),
         checkNSString(aContentPlan.dayOfWeek),
         checkNSString(aContentPlan.notifyStatus),
         checkNSString(aContentPlan.plan_id),
         checkNSString(aContentPlan.user_id)];
        checkErr(aDB);
    }];
}

- (NSArray *)getContentPlanList:(NSString *)aUserId
{
    NSMutableArray *contentPlanList = [NSMutableArray arrayWithCapacity:0];
    
    [dbQueue inTransaction:^(FMDatabase *aDB, BOOL *aRollback) {
        FMResultSet *rs = [aDB executeQuery:@"SELECT * FROM PlanList WHERE user_id = ? ORDER BY plan_id asc", checkNSString(aUserId)];
        while ([rs next]) {
            WPContentPlan *contentPlan = [[WPContentPlan alloc] init];
            
            contentPlan.plan_id = checkNSString([rs stringForColumnIndex:0]);
            contentPlan.user_id = checkNSString([rs stringForColumnIndex:1]);
            contentPlan.iconNameColor = checkNSString([rs stringForColumnIndex:2]);
            contentPlan.iconNameWhite = checkNSString([rs stringForColumnIndex:3]);
            contentPlan.planName = checkNSString([rs stringForColumnIndex:4]);
            contentPlan.selectedTime = checkNSString([rs stringForColumnIndex:5]);
            
            NSString *canSelectedTimeList = checkNSString([rs stringForColumnIndex:6]);
            contentPlan.canSelectedTimeArray = [canSelectedTimeList componentsSeparatedByString:@"&"];
            
            contentPlan.isPlanFinished = checkNSString([rs stringForColumnIndex:7]);
            contentPlan.summary = checkNSString([rs stringForColumnIndex:8]);
            contentPlan.sportTime = checkNSString([rs stringForColumnIndex:9]);
            contentPlan.dayOfWeek = checkNSString([rs stringForColumnIndex:10]);
            contentPlan.notifyStatus = checkNSString([rs stringForColumnIndex:11]);
            [contentPlanList addObject:contentPlan];
        }
        [rs close];
        checkErr(aDB);
    }];
    
    [contentPlanList sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        WPContentPlan *plan1 = (WPContentPlan *)obj1;
        WPContentPlan *plan2 = (WPContentPlan *)obj2;
        return [plan1.plan_id intValue] > [plan2.plan_id intValue];
    }];
    
    return contentPlanList;
}

#pragma mark - current user

- (void)insertContentCurrentUser:(WPContentCurrentUser *)aContentCurrentUser
{
    if (!aContentCurrentUser) {
        return;
    }
    
    NSString *planFinishedDateList = [aContentCurrentUser.planFinishedDateArray componentsJoinedByString:@"&"];
    
    [dbQueue inDatabase:^(FMDatabase *aDB) {
        [aDB executeUpdate:@"INSERT OR REPLACE INTO CurrentUser(user_id, user_name, password, user_nick, icon, gender, height, weight, area, birthday, continueDayCount, lastWorkDate, planFinishedDateList, coinCountOfEveryDay, totalCoinCount, wakeUpCoinCount, breakfastCoinCount, lunchCoinCount, dinnerCoinCount, waterCoinCount, bianbianCoinCount, sleepCoinCount, youyangSportCoinCount, wuyangSportCoinCount, wakeUpAndSleepSwitch, waterSwitch, eatSwitch, sportsSwitch, caredPersonSwitch) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
         checkNSString(aContentCurrentUser.user_id),
         checkNSString(aContentCurrentUser.user_name),
         checkNSString(aContentCurrentUser.password),
         checkNSString(aContentCurrentUser.user_nick),
         checkNSString(aContentCurrentUser.icon),
         checkNSString(aContentCurrentUser.gender),
         checkNSString(aContentCurrentUser.height),
         checkNSString(aContentCurrentUser.weight),
         checkNSString(aContentCurrentUser.area),
         checkNSString(aContentCurrentUser.birthday),
         checkNSString(aContentCurrentUser.continueDayCount),
         checkNSString(aContentCurrentUser.lastWorkDate),
         checkNSString(planFinishedDateList),
         checkNSString(aContentCurrentUser.coinCountOfEveryDay),
         checkNSString(aContentCurrentUser.totalCoinCount),
         checkNSString(aContentCurrentUser.wakeUpCoinCount),
         checkNSString(aContentCurrentUser.breakfastCoinCount),
         checkNSString(aContentCurrentUser.lunchCoinCount),
         checkNSString(aContentCurrentUser.dinnerCoinCount),
         checkNSString(aContentCurrentUser.waterCoinCount),
         checkNSString(aContentCurrentUser.bianbianCoinCount),
         checkNSString(aContentCurrentUser.sleepCoinCount),
         checkNSString(aContentCurrentUser.youyangSportCoinCount),
         checkNSString(aContentCurrentUser.wuyangSportCoinCount),
         checkNSString(aContentCurrentUser.wakeUpAndSleepSwitch),
         checkNSString(aContentCurrentUser.waterSwitch),
         checkNSString(aContentCurrentUser.eatSwitch),
         checkNSString(aContentCurrentUser.sportsSwitch),
         checkNSString(aContentCurrentUser.caredPersonSwitch)];
        checkErr(aDB);
    }];
}

- (void)updateContentCurrentUser:(WPContentCurrentUser *)aContentCurrentUser
{
    if (!aContentCurrentUser) {
        return;
    }
    
    NSString *planFinishedDateList = [aContentCurrentUser.planFinishedDateArray componentsJoinedByString:@"&"];
    
    [dbQueue inDatabase:^(FMDatabase *aDB) {
        [aDB executeUpdate:@"UPDATE CurrentUser SET user_name = ?, password = ?, user_nick = ?, icon = ?, gender = ?, height = ?, weight = ?, area = ?, birthday = ?, continueDayCount = ?, lastWorkDate = ?, planFinishedDateList = ?, coinCountOfEveryDay = ?, totalCoinCount = ?, wakeUpCoinCount = ?, breakfastCoinCount = ?, lunchCoinCount = ?, dinnerCoinCount = ?, waterCoinCount = ?, bianbianCoinCount = ?, sleepCoinCount = ?, youyangSportCoinCount = ?, wuyangSportCoinCount = ?, wakeUpAndSleepSwitch = ?, waterSwitch = ?, eatSwitch = ?, sportsSwitch = ?, caredPersonSwitch = ? WHERE user_id = ?",
         checkNSString(aContentCurrentUser.user_name),
         checkNSString(aContentCurrentUser.password),
         checkNSString(aContentCurrentUser.user_nick),
         checkNSString(aContentCurrentUser.icon),
         checkNSString(aContentCurrentUser.gender),
         checkNSString(aContentCurrentUser.height),
         checkNSString(aContentCurrentUser.weight),
         checkNSString(aContentCurrentUser.area),
         checkNSString(aContentCurrentUser.birthday),
         checkNSString(aContentCurrentUser.continueDayCount),
         checkNSString(aContentCurrentUser.lastWorkDate),
         checkNSString(planFinishedDateList),
         checkNSString(aContentCurrentUser.coinCountOfEveryDay),
         checkNSString(aContentCurrentUser.totalCoinCount),
         checkNSString(aContentCurrentUser.wakeUpCoinCount),
         checkNSString(aContentCurrentUser.breakfastCoinCount),
         checkNSString(aContentCurrentUser.lunchCoinCount),
         checkNSString(aContentCurrentUser.dinnerCoinCount),
         checkNSString(aContentCurrentUser.waterCoinCount),
         checkNSString(aContentCurrentUser.bianbianCoinCount),
         checkNSString(aContentCurrentUser.sleepCoinCount),
         checkNSString(aContentCurrentUser.youyangSportCoinCount),
         checkNSString(aContentCurrentUser.wuyangSportCoinCount),
         checkNSString(aContentCurrentUser.wakeUpAndSleepSwitch),
         checkNSString(aContentCurrentUser.waterSwitch),
         checkNSString(aContentCurrentUser.eatSwitch),
         checkNSString(aContentCurrentUser.sportsSwitch),
         checkNSString(aContentCurrentUser.caredPersonSwitch),
         checkNSString(aContentCurrentUser.user_id)];
        checkErr(aDB);
    }];
}

- (WPContentCurrentUser *)getContentCurrentUser
{
    __block WPContentCurrentUser *contentCurrentUser = [[WPContentCurrentUser alloc] init];
    
    [dbQueue inTransaction:^(FMDatabase *aDB, BOOL *aRollback) {
        FMResultSet *rs = [aDB executeQuery:@"SELECT * FROM CurrentUser"];
        if ([rs next]) {
            contentCurrentUser.user_id = checkNSString([rs stringForColumnIndex:0]);
            contentCurrentUser.user_name = checkNSString([rs stringForColumnIndex:1]);
            contentCurrentUser.password = checkNSString([rs stringForColumnIndex:2]);
            contentCurrentUser.user_nick = checkNSString([rs stringForColumnIndex:3]);
            contentCurrentUser.icon = checkNSString([rs stringForColumnIndex:4]);
            contentCurrentUser.gender = checkNSString([rs stringForColumnIndex:5]);
            contentCurrentUser.height = checkNSString([rs stringForColumnIndex:6]);
            contentCurrentUser.weight = checkNSString([rs stringForColumnIndex:7]);
            contentCurrentUser.area = checkNSString([rs stringForColumnIndex:8]);
            contentCurrentUser.birthday = checkNSString([rs stringForColumnIndex:9]);
            
            contentCurrentUser.continueDayCount = checkNSString([rs stringForColumnIndex:10]);
            contentCurrentUser.lastWorkDate = checkNSString([rs stringForColumnIndex:11]);
            
            NSString *planFinishedDateList = checkNSString([rs stringForColumnIndex:12]);
            contentCurrentUser.planFinishedDateArray = [planFinishedDateList componentsSeparatedByString:@"&"];
            
            contentCurrentUser.coinCountOfEveryDay = checkNSString([rs stringForColumnIndex:13]);
            contentCurrentUser.totalCoinCount = checkNSString([rs stringForColumnIndex:14]);
            
            contentCurrentUser.wakeUpCoinCount = checkNSString([rs stringForColumnIndex:15]);
            contentCurrentUser.breakfastCoinCount = checkNSString([rs stringForColumnIndex:16]);
            contentCurrentUser.lunchCoinCount = checkNSString([rs stringForColumnIndex:17]);
            contentCurrentUser.dinnerCoinCount = checkNSString([rs stringForColumnIndex:18]);
            contentCurrentUser.waterCoinCount = checkNSString([rs stringForColumnIndex:19]);
            contentCurrentUser.bianbianCoinCount = checkNSString([rs stringForColumnIndex:20]);
            contentCurrentUser.sleepCoinCount = checkNSString([rs stringForColumnIndex:21]);
            contentCurrentUser.youyangSportCoinCount = checkNSString([rs stringForColumnIndex:22]);
            contentCurrentUser.wuyangSportCoinCount = checkNSString([rs stringForColumnIndex:23]);
            
            contentCurrentUser.wakeUpAndSleepSwitch = checkNSString([rs stringForColumnIndex:24]);
            contentCurrentUser.waterSwitch = checkNSString([rs stringForColumnIndex:25]);
            contentCurrentUser.eatSwitch = checkNSString([rs stringForColumnIndex:26]);
            contentCurrentUser.sportsSwitch = checkNSString([rs stringForColumnIndex:27]);
            contentCurrentUser.caredPersonSwitch = checkNSString([rs stringForColumnIndex:28]);
        }
        [rs close];
        checkErr(aDB);
    }];
    return contentCurrentUser;
}

@end
