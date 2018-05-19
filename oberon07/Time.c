#include <time.h>
#include <obnc/OBNC.h>
#include ".obnc/Time.h"

#include <stdio.h>

const int Time_CTimeStruct_id;
const int *const Time_CTimeStruct_ids[1] = {&Time_CTimeStruct_id};
const OBNC_Td Time_CTimeStruct_td = {Time_CTimeStruct_ids, 1};

void Time_Time_(Time_CTimeStruct_ *time_, const OBNC_Td *time_td)
{
  time_t rawtime;
  time(&rawtime);
  struct tm * gmt = gmtime(&rawtime);
  time_->tmSec_  = gmt->tm_sec;
  time_->tmMin_  = gmt->tm_min;
  time_->tmHour_ = gmt->tm_hour;
  time_->tmMday_ = gmt->tm_mday;
  time_->tmMon_  = gmt->tm_mon;
  time_->tmYear_ = gmt->tm_year;
}


void Time_Init(void)
{
}
