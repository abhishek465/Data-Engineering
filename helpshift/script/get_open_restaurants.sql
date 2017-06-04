/*===================================================================
* File name     : get_open_restaurants.sql
* Author        : Abhishek
* Date          : 21-Aug-2016
* Client        : Helpshift
* System        : Test
* Module        : Test
* Description   : get_open_restaurants function returns name of open resturant at that time
* Modification History
* Date           Pgmr          Description
* 21-Aug-2016    Abhishek     get_open_restaurants function returns name of open resturant at that time
*==================================================================*/


create or replace function get_open_restaurants(p_date varchar2,
						p_format varchar2 default 'dd/mm/yyyy hh12:mi:ss'
						) return sys_refcursor
is
	cv sys_refcursor;
	v_date varchar2(25);
	v_open_day varchar2(25);
begin
	if p_format = 'dd/mm/yyyy hh12:mi:ss' or p_format = 'dd-mm-yyyy hh12:mi:ss' then
		if regexp_count(p_format,'-') > 0 then
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'-',-1)+4),'dd-mm-yyyy'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'-',-1)+5);
		else
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'/',-1)+4),'dd/mm/yyyy'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'/',-1)+5);
		end if;
	elsif p_format = 'dd/mm/yy hh12:mi:ss' or p_format = 'dd-mm-yy hh12:mi:ss' then
		if regexp_count(p_format,'-') > 0 then
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'-',-1)+2),'dd-mm-yy'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'-',-1)+3);
		else
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'/',-1)+2),'dd/mm/yy'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'/',-1)+3);
		end if;
	elsif p_format = 'yyyy-mm-dd hh12:mi:ss' or p_format = 'yyyy/mm/dd hh12:mi:ss' then
		if regexp_count(p_format,'-') > 0 then
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'-',-1)+2),'yyyy-mm-dd'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'-',-1)+3);
		else
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'/',-1)+2),'yyyy-mm-dd'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'/',-1)+3);
		end if;
	elsif p_format = 'yy/mm/dd hh12:mi:ss' or p_format = 'yy-mm-dd hh12:mi:ss' then
		if regexp_count(p_format,'-') > 0 then
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'-',-1)+2),'yy-mm-dd'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'-',-1)+3);
		else
			v_date := to_char(to_date(substr(p_date,1,instr(p_date,'/',-1)+2),'yy/mm/dd'),'Dy');
			v_open_day := substr(p_date,instr(p_date,'/',-1)+3);
		end if;
	else
		open cv for select 'Please provide input in correct format. Go through instruction file to see supported format.' as "Error Message" from dual;
		return cv;
	end if;
		
	if v_open_day like '%AM%' then
		v_open_day := replace(replace(v_open_day,'AM',''),':','.');
	else
		v_open_day :=  substr(replace(replace(v_open_day,'PM',''),':','.'),1,instr(replace(replace(v_open_day,'PM',''),':','.'),'.',-1)-1);
	end if;
	
	if to_number(v_open_day) < 5  and p_date like '%AM%' then
		open cv for select Restaurant_name from Restaurant_analysis where open_day like '%'||v_date||'%' and to_number(end_time) >= to_number(v_open_day) and to_number(end_time) <= 4;
	else
		open cv for select Restaurant_name from Restaurant_analysis where open_day like '%'||v_date||'%' and to_number(start_time) < 12 + v_open_day and to_number(end_time) >to_number(v_open_day);
	end if;
	return cv;
	
	exception
	when others then
		open cv for select 'Please provide input in correct format. Go through instruction file to see supported format.' as "Error Message" from dual;
		return cv;

end;
/

