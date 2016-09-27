/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.date;

import java.util.ArrayList;

/**
 *
 * @author Saber NOUIOUA
 */
public class GenerateDate {

    
    public ArrayList getAllDate(int year)
    {
        ArrayList array_date = new ArrayList();
        /**
         * 
         */
        // 2016-03-21T22:11:45.000Z
        for(int month=1;month<=12;month++)
        {
            /**
             * 
             */
            if(month ==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12)
            {
                for(int day=1;day<=31;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }

            }
            /**
             * 
             */
            if(month ==4 || month==6 || month==9 || month==11)
            {
                for(int day=1;day<=30;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }            
            }
            /**
             * 
             */
            if(month ==2 )
            {
                int taille_day =28;
                if((year % 4) == 0)
                {
                    taille_day =29 ;
                }  
                for(int day=1;day<=taille_day;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }                
            }            
        }
    return array_date;
    }
    
    public ArrayList getAllDate(int year,int month)
    {
        ArrayList array_date = new ArrayList();
        /**
         * 
         */
            /**
             * 
             */
            if(month ==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12)
            {
                for(int day=1;day<=31;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }

            }
            /**
             * 
             */
            if(month ==4 || month==6 || month==9 || month==11)
            {
                for(int day=1;day<=30;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }            
            }
            /**
             * 
             */
            if(month ==2 )
            {
                int taille_day =28;
                if((year % 4) == 0)
                {
                    taille_day =29 ;
                }  
                for(int day=1;day<=taille_day;day++)
                {
                        for(int hour=0;hour<=23;hour++)
                        {
                            String month_date = ""+month;
                            String day_date   = ""+day;
                            String hour_date  = ""+hour;
                            
                            if(month_date.length()==1)
                            {
                              month_date = "0"+month_date  ;
                            }
                            if(day_date.length()==1)
                            {
                              day_date = "0"+day_date  ;
                            }
                            if(hour_date.length()==1)
                            {
                              hour_date = "0"+hour_date  ;
                            }
                            array_date.add(""+year+"-"+month_date+"-"+day_date+"T"+hour_date+":00:00.000Z");
                        }                
                }                
            }                    
    return array_date;
    }    
}
