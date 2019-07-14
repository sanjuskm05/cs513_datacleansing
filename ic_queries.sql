IC violations


 1. Market records where there are at least two rows having the same ID, but some differing attributes.


select fm1.fmid, fm1.MarketName, fm1.street, fm1.city, fm1.County, fm1.State, fm1.zip, fm1.x, fm1.y
  from farmers_market_base_table fm1
  join ( select *
           from farmers_market_base_table 
          group by fmid
         having count(*) > 1 ) fm2
    on fm1.fmid = fm2.fmid;


No rows found

2. Missing market names in the Market table

select fmid from farmers_market_base_table where MarketName is null;

No rows found.

3. Duplicate market names in the Market table

select substr(MarketName, 1,20), street, zip, count(substr(MarketName, 1,20)) as NumOccurrences from farmers_market_base_table 
group by street, substr(MarketName, 1,20) having (count(street) > 1 and count(zip) > 1 and count(substr(MarketName,1,20)) > 1);

Foothills Farmers' M|126 W. Marion Street|28152|2
Redland Community Fa|12690 Sw 280th Street|33033|2
Vashon Farmers Marke|17519 Vashon Highway Sw|98070|2
Crescent City Farmer|200 Broadway Street|70118|2
Mccutcheon/mount Ver|2501 Sherwood Hall Lane|22306|2
Welcome Center Farme|2931 Monroe Avenue|51555|2
Main Street Farmers |301 Main Street|20878|2
Paulding County Farm|4075 Charles Hardy Pkway,|30157|2
Dresden Farmers Mark|421 Linden St.|38225|2
Mississippi Farmers |929 High Street|39202|2
Beaverton Farmers Ma|Hall Blvd.|97075|2

select substr(MarketName, 1,30), street, zip, count(substr(MarketName, 1,30)) as NumOccurrences from farmers_market_base_table 
group by street, substr(MarketName, 1,30) having (count(street) > 1 and count(zip) > 1 and count(substr(MarketName,1,30)) > 1);

Foothills Farmers' Market, Inc|126 W. Marion Street|28152|2
Redland Community Farm And Mar|12690 Sw 280th Street|33033|2
Crescent City Farmers Market|200 Broadway Street|70118|2
Welcome Center Farmers Market|2931 Monroe Avenue|51555|2
Paulding County Farm Bureau Fa|4075 Charles Hardy Pkway,|30157|2
Dresden Farmers Market|421 Linden St.|38225|2

4. Invalid US Longitude or Lattitude in Market table.  These rows can't be used for our USA farmers market geo-location use cases.

select fmid, MarketName, x, y from farmers_market_base_table where x > 0 or y < 0 or x > abs(180) or y > abs(90) or abs(y) >  abs(x); 

No rows found

5. Missing Longitude or Lattitude in the Market table.  These rows can't be used for our USA farmers market geo-location use cases;

select fmid, MarketName, x, y from farmers_market_base_table  where x is null or y is null;

2000001|Center For Design Practice - Mobile Farmers Market||
1011689|Charlotte Regional Farmers Market||
2000002|Dig It!||
1002854|East Goshen Farmers Market||
2000004|Farm A La Carte||
2000005|Farm Fresh Mobile Market||
2000006|Farm To Family||
2000007|Farmer’s Market Express||
2000008|Food Shuttlle||
2000009|Freshest Cargo: Mobile Farmers’ Market||
2000010|Fulton Fresh Mobile Farmer’s Market||
2000011|Go Fresh Mobile Farmer's Market||
2000012|Gorge Grown Mobile Farmers' Market||
2000013|Green Mountain - Mobile Farmers Market||
2000014|Greensgrow Farms Mobile Food Delivery System||
2000016|Honeybee Mobile Farmers Market||
2000019|Merced County’s Mobile Farmers Market||
2000020|Mobile Farm Fresh Of Nc||
2000021|Osage Nation Sr. Farmers Market||
2000022|Real Food System||
2000026|Riverview Farms Of Ranger||
2000028|San Joaquin Mobile Farmers Market||
2000030|Steve Casey's Mobile Produce Market||
2000032|Tmc Healthy Harvest Mobile Market||
2000033|Tri-community mobile farmers market||
2000034|Urban Oasis Farmers Market On The Move||
2000035|Westside Tailgate Farmers Market||
2000036|Ymca Farmers Market And Veggie Van||


6.  Social Media records where its foreign key not found in Market table

select * from FarmerMarket_socialMedia sm where sm.fmid not in (select mkt.fmid from farmers_market_base_table mkt);

No rows found

7. Social Media records where there are at least two rows having the same ID, but some differing attributes.

select sm1.fmid, sm1.website, sm1.Facebook, sm1.Twitter, sm1.Youtube, sm1.OtherMedia
  from FarmerMarket_socialMedia sm1
  join ( select *
           from FarmerMarket_socialMedia 
          group by fmid
         having count(*) > 1 ) sm2
    on sm1.fmid = sm2.fmid;

No rows found


8. Invalid websites in the Social Media table. Valid web sites must have at least one character between "http(s)://" and the "." and at least two characters after the dot. 

select fmid, website  from  FarmerMarket_socialMedia where website not  like 'http%://_%.__%';

No rows found

9. Payment Type records where their foreign keys are not found in the Market table

select * from paymentType pmt where pmt.fmid not in (select mkt.fmid from farmers_market_base_table mkt);

No records found


10. Payment Type records where there are at least two rows having the same ID, but some differing attributes.

select pmt1.fmid, pmt1.wic, pmt1.wiccash, pmt1.SFMNP, pmt1.SNAP
  from paymentType pmt1
  join ( select *
           from paymentType 
          group by fmid
         having count(*) > 1 ) pmt2
    on pmt1.fmid = pmt2.fmid;


No rows found

11. Rows with invalid payment type indicator values (valid values are 'Y' or null) in the Payment Type table;

select fmid, wic, wiccash, SFMNP, SNAP from paymentType where wic not in ('Y', null) or wiccash not in ('Y', null) or SFMNP not in ('Y', null) or SNAP not in ('Y', null

No rows found

12. Schedule records where their foreign keys are not found in the Market table 

select * from FarmersMarket_schedule sch where sch.fmid not in (select mkt.fmid from farmers_market_base_table mkt);

No records found

13. Schedule records where there are at least two rows having the same ID, but some differing attributes.

select sch1.fmid, sch1.season, sch1.seasonOpenning, sch1.seasonClosing, sch1.seasonTime
  from FarmersMarket_schedule sch1
  join ( select *
           from FarmersMarket_schedule 
          group by fmid
         having count(*) > 1 ) sch2
    on sch1.fmid = sch2.fmid;

No rows found

.14  Rows where there is no or incomplete schedule information

select *  from FarmersMarket_schedule  where season is null and (seasonOpenning is null or seasonClosing is null) or seasonTime is null limit 20;

1009364||||
1011213||||Tue: 3:00 PM-7:00 PM;
1006234||||
1006494||||
1010617||||
1007585||||
1003865||||
1002947||||
1004031||||
1007070||||
1009543||||
1002108||||
1007575||||
1005122||||
1008461||||Mon: 9:00 AM-5:00 PM;Tue: 9:00 AM-5:00 PM;Wed: 9:00 AM-5:00 PM;Thu: 9:00 AM-5:00 PM;Fri: 9:00 AM-5:00 PM;Sat: 9:00 AM-5:00 PM;
1007519||||
1006969||||
1018278||||Sat: 8:00 AM-1:00 PM;
1005109||||
1002464||||

select count( *)  from FarmersMarket_schedule  where season is null and (seasonOpenning is null or seasonClosing is null) or seasonTime is null;

3205 records with no incomplete schedile inforation




