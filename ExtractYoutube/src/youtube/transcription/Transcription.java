/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.transcription;

import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author saber
 */
public class Transcription {

private ReadXML readXML = new ReadXML();
private Settings appSettings;    // Application settings
private Controller _controller;  // Application controller
private List<Video> videos_result = new ArrayList<Video>();

/**
 * constructor par default
 */
    public Transcription()
    {

    }
    /**
     * récupérer la transcription pour la vidéo en question
     * @param url
     * @return 
     */
    public String getTRANSCRIPTION(String url)
    {
        String transcription_txt="";
        _controller = new Controller(appSettings);                 
        /* recuperation du flux xml */       
       /*new Thread(new Runnable() {                
                @Override
                public void run() {
                    videos_result = _controller.processInputURL(url);
                    //
                    if(videos_result.size()==0)
                    {
                    array_return.add("");
                    }
                    else
                    {
                    //
                    try
                    {                    
                    for(Video v:videos_result)
                    {
                        for(int i=0;i<v.getSubtitles().size();i++)
                        {
                            if(v.getSubtitles().get(i).getType().toString().equalsIgnoreCase("YouTubeASRTrack"))
                            {
                                 String transcription_txt =readXML.getTXT_XML(v.getSubtitles().get(i).getTrackURL());
                                 
                            }                            
                        }
                    }                     
                    }
                    catch(Exception e){}                    
                    }                      
                }
            }).start();*/
                    videos_result = _controller.processInputURL(url);
                    //
                    if(videos_result.size()==0)
                    {
                    transcription_txt="";
                    }
                    else
                    {
                    //    System.out.println("youtube.transcription.Transcription.getTRANSCRIPTION() "+videos_result.size());
                    //
                    try
                    {                    
                    for(Video v:videos_result)
                    {
                        for(int i=0;i<v.getSubtitles().size();i++)
                        {
                            //System.out.println("youtube.transcription.Transcription.getTRANSCRIPTION()"+v.getSubtitles().get(i).getType().toString()+"    "+i);
                            if(v.getSubtitles().get(i).getType().toString().equalsIgnoreCase("YouTubeASRTrack"))
                            {
                              transcription_txt =readXML.getTXT_XML(v.getSubtitles().get(i).getTrackURL());                                 
                            }                            
                        }
                    }                     
                    }
                    catch(Exception e)
                    {
                        System.out.println(e.getMessage());
                        transcription_txt="";
                    }                    
                    }       
    return transcription_txt;
    }    
}
