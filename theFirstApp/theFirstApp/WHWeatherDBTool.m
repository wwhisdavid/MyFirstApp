//
//  WHWeatherDBTool.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 deyi. All rights reserved.
//

#import "WHWeatherDBTool.h"
#import "WHWeather.h"
#import "WHWeatherResposeEntity.h"
#import "FMDB.h"
#import "MJExtension.h"

@implementation WHWeatherDBTool

static FMDatabase *_db;

+ (void)initialize
{
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weathers.sqlite"];
    WHLog(@"%@-----------------",path);
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_weather(id integer PRIMARY KEY, string text NOT NULL);"];
}

+ (void)addWeatherJSONStr:(NSString *)JSONStr
{
    [_db executeUpdateWithFormat:@"INSERT INTO t_weather(string) VALUES (%@);",JSONStr];
}

+ (void)deleteWeatherJSONStrWithID:(NSString *)ID
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM t_weather WHERE id = %@;", ID];
    [_db executeUpdate:sql1];
    NSString *sql2 = [NSString stringWithFormat:@"UPDATE t_weather SET id = id - 1 WHERE id > %@;", ID];
    [_db executeUpdate:sql2];
}

- (NSArray *)weathers
{
    //得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_weather;"];
    
    //不断往下取数据
    NSMutableArray *weathers = [NSMutableArray array];
    while (set.next) {
        //获得当前所指向数据
        NSString *str = [NSString string];
        str = [set stringForColumn:@"string"];
        WHWeatherResposeEntity *tempWeatherResponse = [WHWeatherResposeEntity objectWithKeyValues:str];
        WHWeather *tempWeather = [WHWeather objectWithKeyValues:tempWeatherResponse.retData];
        [weathers addObject:tempWeather];
    }
    return weathers;
}




- (WHWeather *)weather:(NSArray *)JSONStrArray
{
    NSString *str = [JSONStrArray lastObject];
    WHWeatherResposeEntity *weatherResposeEntity = [WHWeatherResposeEntity objectWithKeyValues:str ];
    
    WHWeather *weather = [WHWeather objectWithKeyValues:weatherResposeEntity.retData];

    return weather;
}

- (void)closeDB
{
    [_db close];
}
@end
