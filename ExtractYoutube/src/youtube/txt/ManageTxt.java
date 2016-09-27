package youtube.txt;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author Saber NOUIOUA
 */
public class ManageTxt {

public ManageTxt(){

}
/**
 * RECUPERER LA PAGE HTML
 * @param file_video_id
 * @param file_log
 * @return
 * @throws IOException 
 */    
public ArrayList<String> getVideosIds(String file_video_id,String file_log) throws IOException  
  {
        BufferedReader buffer_video_id = null;        
        ArrayList<String> array_video_id = new ArrayList<>();
        try
          {
            buffer_video_id = new BufferedReader(new FileReader(file_video_id));
            String video_id;
                while ((video_id = buffer_video_id.readLine()) != null)
                {
                    System.out.println (video_id);
                    array_video_id.add(video_id);
                }
          }
        catch(FileNotFoundException e)
          {
            writelog(file_log, "** ERREUR IO "+e.getMessage());
          }
    return array_video_id;
  }
    /**
     * ECRIRE DANS LE FICHIER TXT RECUPERER PAR BOILERPIPE
     * @param path
     * @param text
     * @param file_log 
     */
	public void writetxt(String path, String text,String file_log) 
	{       
                /**
                 * UNE CLASSE POUR ECRIRE DANS UN FICHIER
                 */
                FileWriter out;
                /**
                 * CREATION D'UN FICHIER TXT
                 */
                try{
                File file = new File(path);
                if(file.exists()==false){
                out = new FileWriter(path);
                }    
                }            
		catch (IOException e)
		{
		 writelog(file_log, "** ERREUR IO "+e.getMessage());
		}
                /**
                 * ECRIRE DANS LE FICHIER TXT
                 */
		PrintWriter ecri ;
		try
		{
			ecri = new PrintWriter(new FileWriter(path));
			ecri.print(text);
			ecri.flush();
			ecri.close();
		}
		catch (NullPointerException e)
		{
			writelog(file_log, "** ERREUR NULLPOINTER "+e.getMessage());
		}
		catch (IOException e)
		{
			writelog(file_log, "** ERREUR IO "+e.getMessage());
		}
	}   
    /**
     * 
     * @param file_name
     * @return 
     */        
    public String get_valid_filename(String file_name){
                
        char ch1 ='\\';
        char ch2 ='"';     
        if(file_name!= null)
        {
          file_name = file_name.replaceAll("/", "");
          file_name = file_name.replaceAll("'", "''");
          //linkname = message.getLink().replaceAll(ch1+"", " ");
          /*linkname = linkname.replaceAll(";", "");
          linkname = linkname.replaceAll("*", "");
          linkname = linkname.replaceAll("?", "");
          //linkname = linkname.replaceAll(ch2+"", "-");
          linkname = linkname.replaceAll("<", "");
          linkname = linkname.replaceAll(">", "");*/   
          return file_name;
        }                    
        return null;
    }
    public void writelog(String filename, String text) {
        BufferedWriter bufWriter = null;
        FileWriter fileWriter = null;
        try {
            fileWriter = new FileWriter(filename, true);
            bufWriter = new BufferedWriter(fileWriter);
            //Insérer un saut de ligne            
            bufWriter.write(text);
            bufWriter.newLine();
            bufWriter.close();
        } catch (IOException ex) {
            Logger.getLogger(ManageTxt.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                bufWriter.close();
                fileWriter.close();
            } catch (IOException ex) {
                Logger.getLogger(ManageTxt.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }    
/**
 * Remplacer tous les "'" par "''" pour la base de données
 * @param str
 * @return 
 */
public String getvalidstr(String str)
{           
        if(str!=null)
        {
            return str.replaceAll("'", "''");
        }
        return null;
}    

    /**
     * CREATION DES REPERTOIRES NAME_PAYS ET NAME_JOURNAL 
     * @param file_name 
     * @param file_log 
     */
    public void create_folder(String file_name,String file_log)
    {
        File file = new File(file_name);
        if (file.exists()==false)          
        {
            if (file.mkdirs()) 
            {
                writelog(file_log, "++ CREATION FOLDER "+file.getAbsolutePath());
            } 
            else 
            {
                writelog(file_log, "** ECHEC FOLDER "+file.getAbsolutePath());
            }
        }
    }       
} 
    

