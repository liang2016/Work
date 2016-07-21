--
--    LssclM2M - http://www.lsscl.com
--    Copyright (C) 2006-2011 Lsscl ES Technologies Inc.
--     
--    
--     
--     
--     
--     
--
--     
--     
--     
--     
--
--     
--    
--
--

--
-- System settings
create table systemSettings (
  settingName varchar(32) not null,
  settingValue clob
);
alert table systemSettings add constraint systemSettingsPk primary key (settingName);


--
-- Users
create table users (
  id int not null generated by default as identity (start with 1, increment by 1),
  username varchar(40) not null,
  password varchar(30) not null,
  email varchar(255) not null,
  phone varchar(40),
  admin char(1) not null,
  disabled char(1) not null,
  lastLogin bigint,
  selectedWatchList int,
  homeUrl varchar(255),
  receiveAlarmEmails int not null,
  receiveOwnAuditEvents char(1) not null
);
alert table users add constraint usersPk primary key (id);

create table userComments (
  userId int,
  commentType int not null,
  typeKey int not null,
  ts bigint not null,
  commentText varchar(1024) not null
);
alert table userComments add constraint userCommentsFk1 foreign key (userId) references users(id);
--
--
--
--
CREATE TABLE userEventHandlers(
	userId int  not null,
	eventHandlerCount int not null,
	limit bigint not null
);

--
--
-- Mailing lists
--
create table mailingLists (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  name varchar(40) not null,
    scopeid int not null,
);
alert table mailingLists add constraint mailingListsPk primary key (id);
alert table mailingLists add constraint mailingListsUn1 unique (xid);

create table mailingListInactive (
  mailingListId int not null,
  inactiveInterval int not null
);
alert table mailingListInactive add constraint mailingListInactiveFk1 foreign key (mailingListId) 
  references mailingLists(id) on delete cascade;

create table mailingListMembers (
  mailingListId int not null,
  typeId int not null,
  userId int,
  address varchar(255)
);
alert table mailingListMembers add constraint mailingListMembersFk1 foreign key (mailingListId) 
  references mailingLists(id) on delete cascade;




--
--
-- Data Sources
--
create table dataSources (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  name varchar(40) not null,
  dataSourceType int not null,
  factoryId int not null,
  data blob not null
);
alert table dataSources add constraint dataSourcesPk primary key (id);
alert table dataSources add constraint dataSourcesUn1 unique (xid);


-- Data source permissions
create table dataSourceUsers (
  dataSourceId int not null,
  userId int not null
);
alert table dataSourceUsers add constraint dataSourceUsersFk1 foreign key (dataSourceId) references dataSources(id);
alert table dataSourceUsers add constraint dataSourceUsersFk2 foreign key (userId) references users(id) on delete cascade;



--
--
-- Data Points
--
create table dataPoints (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  dataSourceId int not null,
  data blob not null
);
alert table dataPoints add constraint dataPointsPk primary key (id);
alert table dataPoints add constraint dataPointsUn1 unique (xid);
alert table dataPoints add constraint dataPointsFk1 foreign key (dataSourceId) references dataSources(id);


-- Data point permissions
create table dataPointUsers (
  dataPointId int not null,
  userId int not null,
  permission int not null
);
alert table dataPointUsers add constraint dataPointUsersFk1 foreign key (dataPointId) references dataPoints(id);
alert table dataPointUsers add constraint dataPointUsersFk2 foreign key (userId) references users(id) on delete cascade;


--
--
-- Views
--
create table mangoViews (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  name varchar(100) not null,
  background varchar(255),
  userId int not null,
  anonymousAccess int not null,
  factoryId int not null,
  data blob not null
);
alert table mangoViews add constraint mangoViewsPk primary key (id);
alert table mangoViews add constraint mangoViewsUn1 unique (xid);
alert table mangoViews add constraint mangoViewsFk1 foreign key (userId) references users(id) on delete cascade;

create table mangoViewUsers (
  mangoViewId int not null,
  userId int not null,
  accessType int not null
);
alert table mangoViewUsers add constraint mangoViewUsersPk primary key (mangoViewId, userId);
alert table mangoViewUsers add constraint mangoViewUsersFk1 foreign key (mangoViewId) references mangoViews(id);
alert table mangoViewUsers add constraint mangoViewUsersFk2 foreign key (userId) references users(id) on delete cascade;


--
--
-- Point Values (historical data)
--
create table pointValues (
  id bigint not null generated by default as identity (start with 1, increment by 1),
  dataPointId int not null,
  dataType int not null,
  pointValue double,
  ts bigint not null
);
alert table pointValues add constraint pointValuesPk primary key (id);
alert table pointValues add constraint pointValuesFk1 foreign key (dataPointId) references dataPoints(id) on delete cascade;
create index pointValuesIdx1 on pointValues (ts, dataPointId);
create index pointValuesIdx2 on pointValues (dataPointId, ts);
create index pointValuesIdx3 on pointValues (dataPointId);

create table pointValueAnnotations (
  pointValueId bigint not null,
  textPointValueShort varchar(128),
  textPointValueLong clob,
  sourceType smallint,
  sourceId int
);
alert table pointValueAnnotations add constraint pointValueAnnotationsFk1 foreign key (pointValueId) 
  references pointValues(id) on delete cascade;


--
--
-- Watch list
--
create table watchLists (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  userId int not null,
  factoryId int not null,
  name varchar(50)
);
alert table watchLists add constraint watchListsPk primary key (id);
alert table watchLists add constraint watchListsUn1 unique (xid);
alert table watchLists add constraint watchListsFk1 foreign key (userId) references users(id) on delete cascade;

create table watchListPoints (
  watchListId int not null,
  dataPointId int not null,
  sortOrder int not null
);
alert table watchListPoints add constraint watchListPointsFk1 foreign key (watchListId) references watchLists(id) on delete cascade;
alert table watchListPoints add constraint watchListPointsFk2 foreign key (dataPointId) references dataPoints(id);

create table watchListUsers (
  watchListId int not null,
  userId int not null,
  accessType int not null
);
alert table watchListUsers add constraint watchListUsersPk primary key (watchListId, userId);
alert table watchListUsers add constraint watchListUsersFk1 foreign key (watchListId) references watchLists(id);
alert table watchListUsers add constraint watchListUsersFk2 foreign key (userId) references users(id) on delete cascade;


--
--
-- Point event detectors
--
create table pointEventDetectors (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  alias varchar(255),
  dataPointId int not null,
  detectorType int not null,
  alarmLevel int not null,
  stateLimit double,
  duration int,
  durationType int,
  binaryState char(1),
  multistateState int,
  changeCount int,
  alphanumericState varchar(128),
  weight double
);
alert table pointEventDetectors add constraint pointEventDetectorsPk primary key (id);
alert table pointEventDetectors add constraint pointEventDetectorsUn1 unique (xid, dataPointId);
alert table pointEventDetectors add constraint pointEventDetectorsFk1 foreign key (dataPointId) 
  references dataPoints(id);


--
--
-- Events
--
create table events (
  id int not null generated by default as identity (start with 1, increment by 1),
  typeId int not null,
  typeRef1 int not null,
  typeRef2 int not null,
  activeTs bigint not null,
  rtnApplicable char(1) not null,
  rtnTs bigint,
  rtnCause int,
  alarmLevel int not null,
  message clob,
  ackTs bigint,
  ackUserId int,
  scopeId int NULL,
  emailHandler int,
  alternateAckSource int
);
alert table events add constraint eventsPk primary key (id);
alert table events add constraint eventsFk1 foreign key (ackUserId) references users(id);
--
--
---事件临时表 (针对邮件)
--
CREATE TABLE eventTemp(
	id int generated by default as identity (start with 1, increment by 1),
	uid int not null,
	emailAddress varchar(255)  not null,
	ts bigint not null,

);
alert table eventTemp add constraint eventTempPk primary key (id);
--
--
--userEvents
--
create table userEvents (
  eventId int not null,
  userId int not null,
  silenced char(1) not null
);
alert table userEvents add constraint userEventsPk primary key (eventId, userId);
alert table userEvents add constraint userEventsFk1 foreign key (eventId) references events(id) on delete cascade;
alert table userEvents add constraint userEventsFk2 foreign key (userId) references users(id);


--
--
-- Event handlers
--
create table eventHandlers (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  alias varchar(255),
  
  -- Event type, see events
  eventTypeId int not null,
  eventTypeRef1 int not null,
  eventTypeRef2 int not null,
  scopeId int not null,
  disableChange char(1) not null,
  
  data blob not null
);
alert table eventHandlers add constraint eventHandlersPk primary key (id);
alert table eventHandlers add constraint eventHandlersUn1 unique (xid);


--
--
-- Scheduled events
--
create table scheduledEvents (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  alias varchar(255),
  alarmLevel int not null,
  scheduleType int not null,
  returnToNormal char(1) not null,
  disabled char(1) not null,
  activeYear int,
  activeMonth int,
  activeDay int,
  activeHour int,
  activeMinute int,
  activeSecond int,
  activeCron varchar(25),
  inactiveYear int,
  inactiveMonth int,
  inactiveDay int,
  inactiveHour int,
  inactiveMinute int,
  inactiveSecond int,
  scopeId int ,
  inactiveCron varchar(25)
);
alert table scheduledEvents add constraint scheduledEventsPk primary key (id);
alert table scheduledEvents add constraint scheduledEventsUn1 unique (xid);


--
--
-- Point Hierarchy
--
create table pointHierarchy (
  id int not null generated by default as identity (start with 1, increment by 1),
  parentId int,
  scopeId int ,
  name varchar(100)
);
alert table pointHierarchy add constraint pointHierarchyPk primary key (id);


--
--
-- Compound events detectors
--
create table compoundEventDetectors (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  name varchar(100),
  alarmLevel int not null,
  returnToNormal char(1) not null,
  disabled char(1) not null,
   scopeId int not null,
  conditionText varchar(256) not null
);
alert table compoundEventDetectors add constraint compoundEventDetectorsPk primary key (id);
alert table compoundEventDetectors add constraint compoundEventDetectorsUn1 unique (xid);


--
--
-- Reports
--
create table reports (
  id int not null generated by default as identity (start with 1, increment by 1),
  userId int not null,
  name varchar(100) not null,
  factoryId int not null,
  data blob not null
);
alert table reports add constraint reportsPk primary key (id);
alert table reports add constraint reportsFk1 foreign key (userId) references users(id) on delete cascade;

create table reportInstances (
  id int not null generated by default as identity (start with 1, increment by 1),
  userId int not null,
  name varchar(100) not null,
  includeEvents int not null,
  includeUserComments char(1) not null,
  reportStartTime bigint not null,
  reportEndTime bigint not null,
  runStartTime bigint,
  runEndTime bigint,
  recordCount int,
  preventPurge char(1)
);
alert table reportInstances add constraint reportInstancesPk primary key (id);
alert table reportInstances add constraint reportInstancesFk1 foreign key (userId) references users(id) on delete cascade;

create table reportInstancePoints (
  id int not null generated by default as identity (start with 1, increment by 1),
  reportInstanceId int not null,
  dataSourceName varchar(40) not null,
  pointName varchar(100) not null,
  dataType int not null,
  startValue varchar(4096),
  textRenderer blob,
  colour varchar(6),
  consolidatedChart char(1)
);
alert table reportInstancePoints add constraint reportInstancePointsPk primary key (id);
alert table reportInstancePoints add constraint reportInstancePointsFk1 foreign key (reportInstanceId) 
  references reportInstances(id) on delete cascade;

create table reportInstanceData (
  pointValueId bigint not null,
  reportInstancePointId int not null,
  pointValue double,
  ts bigint not null
);
alert table reportInstanceData add constraint reportInstanceDataPk primary key (pointValueId, reportInstancePointId);
alert table reportInstanceData add constraint reportInstanceDataFk1 foreign key (reportInstancePointId) 
  references reportInstancePoints(id) on delete cascade;

create table reportInstanceDataAnnotations (
  pointValueId bigint not null,
  reportInstancePointId int not null,
  textPointValueShort varchar(128),
  textPointValueLong clob,
  sourceValue varchar(128)
);
alert table reportInstanceDataAnnotations add constraint reportInstanceDataAnnotationsPk 
  primary key (pointValueId, reportInstancePointId);
alert table reportInstanceDataAnnotations add constraint reportInstanceDataAnnotationsFk1 
  foreign key (pointValueId, reportInstancePointId) references reportInstanceData(pointValueId, reportInstancePointId) 
  on delete cascade;

create table reportInstanceEvents (
  eventId int not null,
  reportInstanceId int not null,
  typeId int not null,
  typeRef1 int not null,
  typeRef2 int not null,
  activeTs bigint not null,
  rtnApplicable char(1) not null,
  rtnTs bigint,
  rtnCause int,
  alarmLevel int not null,
  message clob,
  ackTs bigint,
  ackUsername varchar(40),
  alternateAckSource int
);
alert table reportInstanceEvents add constraint reportInstanceEventsPk primary key (eventId, reportInstanceId);
alert table reportInstanceEvents add constraint reportInstanceEventsFk1 foreign key (reportInstanceId)
  references reportInstances(id) on delete cascade;

create table reportInstanceUserComments (
  reportInstanceId int not null,
  username varchar(40),
  commentType int not null,
  typeKey int not null,
  ts bigint not null,
  commentText varchar(1024) not null
);
alert table reportInstanceUserComments add constraint reportInstanceUserCommentsFk1 foreign key (reportInstanceId)
  references reportInstances(id) on delete cascade;


--
--
-- Publishers
--
create table publishers (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  data blob not null
);
alert table publishers add constraint publishersPk primary key (id);
alert table publishers add constraint publishersUn1 unique (xid);


--
--
-- Point links
--
create table pointLinks (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  sourcePointId int not null,
  targetPointId int not null,
  script clob,
  eventType int not null,
  scopeId int not null,
  disabled char(1) not null
);
alert table pointLinks add constraint pointLinksPk primary key (id);
alert table pointLinks add constraint pointLinksUn1 unique (xid);


--
--
-- Maintenance events
--
create table maintenanceEvents (
  id int not null generated by default as identity (start with 1, increment by 1),
  xid varchar(50) not null,
  dataSourceId int not null,
  alias varchar(255),
  alarmLevel int not null,
  scheduleType int not null,
  disabled char(1) not null,
  activeYear int,
  activeMonth int,
  activeDay int,
  activeHour int,
  activeMinute int,
  activeSecond int,
  activeCron varchar(25),
  inactiveYear int,
  inactiveMonth int,
  inactiveDay int,
  inactiveHour int,
  inactiveMinute int,
  inactiveSecond int,
  inactiveCron varchar(25)
);


alert table maintenanceEvents add constraint maintenanceEventsPk primary key (id);
alert table maintenanceEvents add constraint maintenanceEventsUn1 unique (xid);
alert table maintenanceEvents add constraint maintenanceEventsFk1 foreign key (dataSourceId) references dataSources(id);




--
--
-- 行业表：工厂行业的分类信息
--
create table trade(
id int generated by default as identity (start with 1, increment by 1), 
tradename nvarchar(50)	not null, 
description	nvarchar(200)
); 
alert table trade add constraint tradePk primary key (id);
--
--
-- 权限表:每个操作都是一种权限
--
create table ACTION( 
id int generated by default as identity (start with 1, increment by 1) ,
actionname	nvarchar(50) not null, 
description	nvarchar(200),	
url	nvarchar(200) not null
);
alert table ACTION add constraint ACTIONPk primary key (id);
--
--
-- 角色表:多个权限的集合
--
create table role (
id int generated by default as identity (start with 1, increment by 1) ,
rolename nvarchar(20)not null,
description	nvarchar(200), 
scopeType int not null
); 
alert table role add constraint rolePk primary key (id);

--
--
-- 角色权限表:为role表和action表的中间表(多对多关系)
--
create table role_action(
rid int not null,
aid	int not null,
date bigint not null
);
alert table role_action add constraint role_actionPk  primary key (rid, aid);
  
alert table role_action ADD constraint role_action_rid foreign key(rid)  references role(id);
alert table role_action ADD constraint role_action_aid foreign key(aid)  references ACTION(id);

--
--
-- 用户角色表:为user表和role表的中间表(多对多关系)
--
create table user_role(
uid int not null,
rid		INT		not null,
DATE		BIGINT		not null,
defaultRole int not null
);
alert table user_role add constraint user_rolePk  primary key (uid, rid);

alert table user_role ADD constraint user_role_uid foreign key(uid)  references users(id);
alert table user_role ADD constraint user_role_rid foreign key(rid) references role(id);

--
--
-- 范围表:存放区域、子区域、工厂的基本信息
--
create table scope( 
id int 	generated by default as identity (start with 1, increment by 1) not null,
scopename	VARCHAR(50)	not null ,
address		VARCHAR(200)		,
lon			double		not null ,
lat			double		not null ,
enlargenum	INT			not null ,
description	VARCHAR(200)		,
parentid	INT					,
scopetype	INT			not null ,
tradeid 	INT 				,
);
alert table scope add constraint scopePk  primary key (id);


alert table scope ADD constraint scope_parentid foreign key(parentid)  references scope(id);
alert table scope ADD constraint scope_tradeid foreign key(tradeid)  references trade(id);
--
--
-- 规定区域类型编号为1,子区域类型编号为2,工厂类型编号为3 
--

--
--
-- 用户所属表:记录此用户属于那个范围的
--
create table user_scope (
uid		INT		not null,
scopeid		INT		not null,
isHomeScope int not null	
);
alert table user_scope add constraint user_scopePk  primary key (uid,scopeid);

alert table user_scope ADD constraint user_scope_uid foreign key(uid)  references users(id);
alert table user_scope ADD constraint user_scope_scopeid foreign key(scopeid)  references scope(id);
 
--
--
-- 空压机型号表：记录空压机的所有型号
--
create table aircompressor_type(
id INT	generated by default as identity (start with 1, increment by 1) not null,
typename	VARCHAR(50)	not null,
description	VARCHAR(200)		,
type int not null
);
alert table aircompressor_type add constraint aircompressor_typePk  primary key (id);



--
--
-- 空压机属性表:记录所有类型的空压机的所有属性
--
create table aircompressor_attr(
id		INT	generated by default as identity (start with 1, increment by 1) not null, 
attrname	VARCHAR(50)	not null,
description	VARCHAR(200)
);
--
--
-- 空压机表：记录空压机的基本信息
--
create table aircompressor( 
id		INT	generated by default as identity (start with 1, increment by 1) not null,
xid varchar(50)  not null,
acname		VARCHAR(50)	not null,
actid		INT		not null,
OFFSET		INT		not null,
factoryid	INT		not null,
type int not null
);
alert table aircompressor add constraint aircompressorPk  primary key (id);
alert table aircompressor ADD constraint aircompressor_actid foreign key(actid)  references aircompressor_type(id);
alert table aircompressor ADD constraint aircompressor_factoryid foreign key(factoryid)  references scope(id);

--
--
-- 统计参数表：记录统计信息需要的参数
--
create table statisticsParam( 
id		INT	generated by default as identity (start with 1, increment by 1) not null,
paramname	VARCHAR(50)	not null,
dataType	int not null,
useType int not null
); 
alert table statisticsParam add constraint statisticsParamPk  primary key (id);
--
--
--统计参数配置
--
create table statisticsConfiguration(
	spid int not null,
	acpaid int not null
) ;
alert table statisticsConfiguration  WITH CHECK ADD  constraint acpaidFk1 foreign key(acpaid)
references aircompressor_attr (id);

alert table statisticsConfiguration  WITH CHECK ADD  constraint statisticsparamFK foreign key(spid)
references statisticsParam (id);

--
--
--aircompressor_type_attr
--
create table aircompressor_type_attr(
	id int generated by default as identity (start with 1, increment by 1) not null,
	actid int not null,
	acaid int not null,
	data image not null
);
alert table aircompressor_type_attr add constraint aircompressor_type_attrPk  primary key (id);
alert table aircompressor_type_attr  WITH CHECK ADD  constraint aircompressor_type_attr_acaid foreign key(acaid)
references aircompressor_attr (id);

alert table aircompressor_type_attr  WITH CHECK ADD  constraint aircompressor_type_attr_actid foreign key(actid)
references aircompressor_type (id);

--
--
-- 空压机成员表：记录空压机每个属性对应的数据点
--
create table aircompressor_members( 
acid		INT		not null,
acaid		INT		, 
spid		INT		,
dpid		INT		not null
);
alert table aircompressor_members add constraint aircompressor_membersPk  primary key (acid);
alert table aircompressor_members ADD constraint aircompressor_members_acid foreign key(acid)  references aircompressor(id);
alert table aircompressor_members ADD constraint aircompressor_members_acaid foreign key(acaid)  references aircompressor_attr(id);

alert table aircompressor_members ADD constraint aircompressor_members_dpid foreign key(dpid)  references datapoints(id);
--
--
-- 压缩空气系统表：记录空压机系统的基本信息
--
create table aircompressor_system( 
id		INT	generated by default as identity (start with 1, increment by 1) not null,
xid		VARCHAR(50)	not null,
systemname	VARCHAR(50)	not null,
factoryid	INT		not null
);
alert table aircompressor_system add constraint aircompressor_systemPk  primary key (id);
alert table aircompressor_system ADD constraint aircompressor_system_factoryid foreign key(factoryid)  references scope(id);




--
--
-- 压缩空气系统成员表:记录空压机系统下的所有空压机以及统计需要的对应的参数
--
create table aircompressor_system_members( 
acsid		INT		not null,
membertype	INT		not null,
memberid	INT		not null,
spid		INT			
);
alert table aircompressor_system_members add constraint aircompressor_system_membersPk  primary key (acsid,membertype,memberid);

alert table aircompressor_system_members ADD constraint aircompressor_system_members_acsid foreign key(acsid)  references aircompressor_system(id);
alert table aircompressor_system_members ADD constraint aircompressor_system_members_spid  foreign key(spid)  references statisticsparam (id); 


--
--
--scope的事件处理器配置表
--
create table scopeSendSetting(
id int generated by default as identity (start with 1, increment by 1) not null,
scopeId int not null,
data image not null
) ;
alert table scopeSendSetting add constraint scopeSendSettingPk  primary key (id);
--
--
--统计脚本
--
create table statisticsScript(
id int generated by default as identity (start with 1, increment by 1) not null,
xid varchar(50)   not null,
name varchar(50)   not null,
disabled char(1)   not null,
conditionText text   not null,
startTs bigint not null
);
alert table statisticsScript add constraint statisticsScriptPk  primary key (id);


--
--
--定时统计
--
create table scheduledStatistic(
	id int generated by default as identity (start with 1, increment by 1) not null,
	scriptId int not null,
	value double not null,
	ts bigint not null,
	unitType int not null,
	unitId int not null,
	date varchar(50) null
);
alert table scheduledStatistic add constraint scheduledStatisticPk  primary key (id);
alert table scheduledStatistic  add  constraint scheduledStatistic_scriptId foreign key(scriptId)
references statisticsScript (id);
--
--
--统计运行状态表
--
create table statisticRTStatus(
	id int generated by default as identity (start with 1, increment by 1) not null,
	scriptId int not null,
	startTs bigint not null,
	endTs bigint not null,
	stopTs varchar(50) not null,
	statisticType int not null
) ;
alert table statisticRTStatus add constraint statisticRTStatusPk  primary key (id);
alert table statisticRTStatus add constraint FK_statisticRTStatus_statisticsScript foreign key(scriptId)
references statisticsScript (id);
