#ifndef __DATA_H
#define __DATA_H

#include <stdio.h>
#include <unistd.h>

#ifdef HAVE_SYS_TIMES_H
# include <sys/times.h>
#endif/*HAVE_SYS_TIMES_H*/

#if TIME_WITH_SYS_TIME
# include <sys/time.h>
# include <time.h>
#else
# if HAVE_SYS_TIME_H
#  include <sys/time.h>
# else
#  include <time.h>
# endif/*HAVE_SYS_TIME_H   */
#endif /*TIME_WITH_SYS_TIME*/

typedef struct DATA_T *DATA;

/* constructor */
DATA  new_data();
void  data_destroy(DATA this);

/* setters */
void  data_set_start      (DATA this);
void  data_set_stop       (DATA this);
void  data_set_highest    (DATA this, float highest);
void  data_set_lowest     (DATA this, float lowest);
void  data_increment_bytes(DATA this, unsigned long bytes);
void  data_increment_count(DATA this, unsigned long count);
void  data_increment_total(DATA this, float total);
void  data_increment_code (DATA this, int code);
void  data_increment_fail (DATA this, int fail);
void  data_increment_ok200 (DATA this, int ok200);

/* getters */
float    data_get_total(DATA this);
float    data_get_bytes(DATA this);
float    data_get_megabytes(DATA this);
float    data_get_highest(DATA this);
float    data_get_lowest(DATA this);
float    data_get_elapsed(DATA this);
float    data_get_availability(DATA this);
float    data_get_response_time(DATA this);
float    data_get_transaction_rate(DATA this);
float    data_get_throughput(DATA this);
float    data_get_concurrency(DATA this);
unsigned int data_get_count(DATA this);
unsigned int data_get_code (DATA this);
unsigned int data_get_fail (DATA this);
unsigned int data_get_ok200(DATA this);

#endif/*__DATA_H*/
