/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.youtube_dl;

import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 *
 * @author Saber NOUIOUA
 */
public class YoutubeDL {

public YoutubeDL(){

}    

public void searchVideo(String file_to_youtube_sh   ,
                        String key_search           ,
                        String date_video           ,
                        String max_search           ,
                        String file_id_video_out)
{
    try
    { 
    /**
    * Lancer les processus de recherche par mot cle
    */
    Process p = null;
    String command = file_to_youtube_sh  +" "+
                     key_search          +" "+
                     date_video          +" "+
                     max_search          +" "+             
                     file_id_video_out;    
    p = Runtime.getRuntime().exec(command);    
    BufferedReader err = new BufferedReader(new InputStreamReader(p.getErrorStream())); 
    String e;
    while ((e = err.readLine()) != null)
    {
    System.err.println("STREAM youtube_dl: "+e);
    }
    }
    catch(Exception e)
    {
    System.out.println("ERROR youtube_dl"+e.getMessage());
    }
}        
}
