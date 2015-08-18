//
//  WHWeatherDBTool.m
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
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
    WHLog(@"%@--------weathers.sqlite-path--------",path);
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_weather(id integer PRIMARY KEY, string text UNIQUE, cityname text);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_cityname(id integer PRIMARY KEY, cityname text UNIQUE);"];
}

+ (void)addWeatherJSONStr:(NSString *)JSONStr andCityName:(NSString *)cityName
{
    [_db executeUpdateWithFormat:@"INSERT INTO t_weather(string,cityname) VALUES (%@,%@);",JSONStr,cityName];
}

+ (void)addWeatherName:(NSString *)name
{
    [_db executeUpdateWithFormat:@"INSERT INTO t_cityname(cityname) VALUES (%@);", name];
}

+ (void)deleteWeatherJSONStrWithID:(NSString *)ID
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM t_weather WHERE id = %@;", ID];
    [_db executeUpdate:sql1];
    NSString *sql2 = [NSString stringWithFormat:@"UPDATE t_weather SET id = id - 1 WHERE id > %@;", ID];
    [_db executeUpdate:sql2];
}

+ (void)deleteWeatherCityNameID:(NSString *)ID
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM t_cityname WHERE id = %@;", ID];
    [_db executeUpdate:sql1];
    NSString *sql2 = [NSString stringWithFormat:@"UPDATE t_cityname SET id = id - 1 WHERE id > %@;", ID];
    [_db executeUpdate:sql2];
}

+ (NSArray *)getAllCitiesName
{
    //得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_cityname;"];
    
    //不断往下取数据
    NSMutableArray *cityName = [NSMutableArray array];
    while (set.next) {
        //获得当前所指向数据
        NSString *str = [NSString string];
        str = [set stringForColumn:@"cityname"];
        
        [cityName addObject:str];
    }
    return cityName;
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




- (NSMutableArray *)weather:(NSArray *)JSONStrArray
{
    NSMutableArray *weathers = [[NSMutableArray alloc] init];
    for (NSString *str in JSONStrArray) {
        WHWeatherResposeEntity *weatherResposeEntity = [WHWeatherResposeEntity objectWithKeyValues:str ];
        
        WHWeather *weather = [WHWeather objectWithKeyValues:weatherResposeEntity.retData];
        [weathers addObject:weather];
    }
    return weathers;
}

- (void)closeDB
{
    [_db close];
}


@end
