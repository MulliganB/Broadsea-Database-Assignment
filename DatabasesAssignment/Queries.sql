--Question 1

select NAMES as Organistation, PLACETYPE as Type, XCOORDINATE, YCOORDINATE FROM BBT_DESTINATION
WHERE (NAMES <= :EnterName) AND PLACETYPE != 'BusStop' AND PLACETYPE != ' ' AND POSTCODE != 'null' ;

--Question 2

select NAMES as Organistation, PLACETYPE as Type, LOCATION_DESCRIPTION as Category, ROUND(SQRT(((XCOORDINATE - :MYX)*(XCOORDINATE - :MYX)) - ((YCOORDINATE - :MYY) - (YCOORDINATE - :MYY)))) as Metres
FROM BBT_DESTINATION
where ROUND(SQRT(((XCOORDINATE - :MYX)*(XCOORDINATE - :MYX)) - ((YCOORDINATE - :MYY) - (YCOORDINATE - :MYY)))) < (:Distance/4);


--Question 3

SELECT  BBT_Service_Stops.stopname as Busstop ,ROUND(SQRT(((XCOORDINATE - :MYX)*(XCOORDINATE - :MYX)) - ((YCOORDINATE - :MYY) - (YCOORDINATE - :MYY)))) as Metres,
BBT_Destination.locatedon, BBT_Service_Stops.stopseqno, BBT_Service_Stops.RoutingName as Towards,  BBT_Frequency.Frequency as Every 
From BBT_Service_Stops
inner join BBT_Frequency
on BBT_Frequency.route = BBT_Service_Stops.routeno
inner join BBT_Destination
on BBT_Service_Stops.stopreference = BBT_Destination.destid
where ROUND(SQRT(((XCOORDINATE - :MYX)*(XCOORDINATE - :MYX)) - ((YCOORDINATE - :MYY) - (YCOORDINATE - :MYY)))) < (:Distance/4);

--Question 4

create or replace procedure Question4(Names OUT varchar2, XCoordinate OUT number, YCoordinate OUT number, SearchName IN Varchar2)
as
v_Org BBT_DESTINATION.Names%TYPE;
v_XCoord BBT_DESTINATION.XCoordinate%TYPE;
v_YCoord BBT_DESTINATION.YCoordinate%TYPE;
cursor C_Name is
    SELECT Names , XCoordinate , YCoordinate
    from BBT_DESTINATION
    where Names <= SearchName AND PlaceType != 'BusStop' AND PlaceType != '' And Postcode != 'null';
NO_ERRORS EXCEPTION;
begin
  open C_Name;
  LOOP
    Fetch C_Name into v_Org , v_XCoord , v_YCoord;
    IF(C_Name%ROWCOUNT = 1) THEN
      Names := v_Org;
      XCoordinate := v_XCoord;
      YCoordinate := v_YCoord;
    END IF;
    Exit When C_Name%NOTFOUND;
  END LOOP;
  --Too many rows exeception
  IF(C_Name%ROWCOUNT > 1) THEN
    RAISE TOO_MANY_ROWS;
  END IF;
  close C_Name;
  dbms_output.put_line('Outputs: ' || Names || ' ' || XCoordinate ||' '|| YCoordinate);
  --No Errors exception 
  if(Names != null AND XCoordinate != null AND YCoordinate != null) THEN
    RAISE NO_ERRORS;
  END IF;
  --No Data exception
  if(Names = null AND XCoordinate = null AND YCoordinate = null) THEN
    RAISE NO_DATA_FOUND;
  END IF;
Exception
  When NO_DATA_FOUND THEN
    dbms_output.put_line(' Nothing Found');
  When TOO_MANY_ROWS Then
    dbms_output.put_line(' Returns more than one row');
  When NO_ERRORS Then
    dbms_output.put_line(' No Errors');
  When OTHERS Then
    dbms_output.put_line(' Error');
end;

