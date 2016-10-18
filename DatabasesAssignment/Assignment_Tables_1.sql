--Tables 

drop table "B2021501"."BBT_DESTINATION" cascade constraints PURGE;
drop table "B2021501"."BBT_LICENSEE" cascade constraints PURGE;
drop table "B2021501"."BBT_LICENCED_VEHICLE" cascade constraints PURGE;
drop table "B2021501"."BBT_VEHICLE" cascade constraints PURGE;
drop table "B2021501"."BBT_SCHEDULE" cascade constraints PURGE;
drop table "B2021501"."BBT_SERVICE_STOPS" cascade constraints PURGE;
drop table "B2021501"."BBT_FREQUENCY" cascade constraints PURGE;


create table BBT_Destination
(
DestId number(10) CONSTRAINT pk_BBT_Destination primary key,
Names varchar2(100) not null,
PlaceType varchar2(100) CONSTRAINT PlaceType_notNull not null,
xCoordinate number(4),
yCoordinate number(4),
Location_Description varchar2(100) default 'N/A',
Opening varchar2(100) default 'N/A',
AddressLine1 varchar2(100) default 'N/A',
AddressLine2 varchar2(100) default 'N/A',
AddressLine3 varchar2(100) default 'N/A',
AddressLine4 varchar2(100) default 'N/A',
Postcode varchar2(10) default 'N/A',
Phone varchar2(20),
Email  varchar2(100) default 'N/A',
StopName varchar2(100) default 'N/A',
LocatedOn varchar2(100) default 'N/A',
Operators varchar2(20) default 'N/A',
RankNo number(5) default 0,
Rating VARCHAR2(15) default 'Not Rated',
StopSeqNo Varchar2(50)
);

create table BBT_Licensee
(
LicenseNo number(20) CONSTRAINT pk_BBT_Licensee primary key,
Names varchar2(50) CONSTRAINT Names_NotNull not null,
DestId number(10)CONSTRAINT Dest_NotNull not null,
CONSTRAINT fk_BBT_Licensee foreign key (DestId) references BBT_Destination(DestId),
ValidFrom date CONSTRAINT VaildFrom_NotNull not null,
ExpiryDate date CONSTRAINT ExpiryDate_NotNull not null,
LicenseType varchar2(25)  CONSTRAINT LicenseType_NotNull not null
);

create table BBT_Licenced_Vehicle
(
LicenseNo number(15),
CONSTRAINT pk_BBT_Licenced_Vehicle primary key(LicenseNo, Reference),
Registration varchar2(10) CONSTRAINT Reg_Unique unique,
Reference varchar2(50) CONSTRAINT Reference_Unique unique
);

create table BBT_Vehicle
(
Registration varchar2(10),
Capacity number(2),
VehicleType varchar2(100)CONSTRAINT VechicleType_NotNull not null,
Models varchar2(100) CONSTRAINT Models_NotNull not null,
Reference varchar2(50) CONSTRAINT pk_BBT_Vehicle  Primary Key,
TimeOn  VARCHAR2(20) CONSTRAINT TimeOn_NotNull not null,
TimeOff VARCHAR2(20)CONSTRAINT TimeOff_NotNull not null,
HomeRank varchar2(50)CONSTRAINT HomeRank_NotNull not null,
OPERATOR varchar2(100)CONSTRAINT OPERATOR_NotNull not null
);

alter table BBT_Licenced_Vehicle 
add constraint fk_license foreign key (LicenseNo) references BBT_Licensee(LicenseNo);

alter table BBT_Licenced_Vehicle 
add constraint fk_Registration foreign key (Reference) references BBT_Vehicle(Reference);


create table BBT_Schedule
(
ScheduleNo number(10),
RouteNo varchar2(50),
Operators varchar2(20),
CONSTRAINT pk_BBT_Schedule primary key(ScheduleNo, RouteNo),
Days Varchar2(10),
Type1 varchar2(10),
startDate  date CONSTRAINT StartDate_NotNull not null,
EndDate  date CONSTRAINT EndDate_NotNull not null,
ExpiryDate date CONSTRAINT ExDate_NotNull not null,
OperatorLicenseNo number(15),
DestId number(10),
BaseFare varchar2(25) CONSTRAINT BaseFare_NotNull not null,
FarePerStop varchar2(20) CONSTRAINT FarePerStop_NotNull not null,
CONSTRAINT fk_BBT_Schedule foreign key  (DestId) references BBT_Destination(DestId)
);

create table BBT_Service_Stops
(
StopReference number(10),
RouteNo varchar2(50),
Direction varchar2(10),
CONSTRAINT pk_BBT_Service_Stops primary key(StopReference, StopSeqNo),
JourneyTime number(4),
StopName varchar2(50),
StopSeqNo Varchar2(50),
RoutingName Varchar2(50)
);

alter table BBT_Destination 
add constraint FK_StopReference foreign key (DESTID, StopSeqNo) references BBT_Service_Stops(StopReference, StopSeqNo);
/*
alter table BBT_Destination 
add constraint FK_Operator foreign key (Operators) references BBT_Schedule(Operators);
*/
CREATE TABLE BBT_Frequency
(
Route VARCHAR2(50),
Days  VARCHAR2(10),
CONSTRAINT pk_BBT_Frequency primary key  (Route, Days),
Frequency NUMBER(6) CONSTRAINT Freq_NotNull not null,
Starts VARCHAR2(10) CONSTRAINT Start_NotNull not null,
Ends VARCHAR2(10) CONSTRAINT End_NotNull not null
);

alter table BBT_Schedule 
add constraint fk_Route foreign key (routeno,days) references BBT_Frequency(route,days);
