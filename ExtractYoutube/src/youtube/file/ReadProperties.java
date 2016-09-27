/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.file;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import youtube.data.Search;

/**
 *
 * @author user
 */
public class ReadProperties {

    
    public Properties getProperties(String properties_filaname){
        
        Properties properties = new Properties();
        try 
        {
            InputStream in = Search.class.getResourceAsStream("/" + properties_filaname);
            properties.load(in);

        }
        catch (IOException e) 
        {
            System.err.println("There was an error reading " + properties_filaname + ": " + e.getCause()
                    + " : " + e.getMessage());
            System.exit(1);
        }
        return properties;
    }
}
