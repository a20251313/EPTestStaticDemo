//
//  EPAllEnum.m
//  BizfocusOC
//
//  Created by 郑东尧 on 15/4/2.
//  Copyright (c) 2015年 郑东尧. All rights reserved.
//

#import <UIKit/UIKit.h>

//跳入选择列表时判断是单选还是多选
typedef enum
{
    singleSelect = 1,
    mutableSelect
}SelectType;

//跳入选择列表时判断应该加载什么类型的数据
typedef enum
{
    nameList = 21,
    departmentAddList = 22,
    projectList = 23,
    clientList = 24,
    subjectList = 25,
    departmentFilterList = 26,
    departmentStaticList = 27,
    defaultList = 0,
}choiceListType;


typedef enum
{
    EPBillCheckTypeAll = 0,
    EPBillCheckTypeRefused = 1,
    EPBillCheckTypeDraft = 2,
    EPBillCheckTypeWaitingProcess = 3,
    EPBillCheckTypeAproved = 4
    
}EPBillCheckType;

typedef enum
{
    all = 0,
    date,
    department,
    project,
    object,
    client,
}EPDisplaytype;

typedef enum
{
    EPStaticTypePerson = 0,
    EPStaticTypeDepartment = 1,
    EPStaticTypeSubject = 2,
    EPStaticTypeClient = 3,
    EPStaticTypeProject = 4,
    EPStaticTypeTime = 5,
    EPStaticTypeBusiness = 6,
    EPStaticTypeNone = 7,
    
}EPStaticType;

#define kPNBARWIDTH         36
#define HIGHLIGHTCOLOR [UIColor colorWithRed:6/255.0 green:90/255.0 blue:136/255.0 alpha:1]
#define DEFAULTCOLOR [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
