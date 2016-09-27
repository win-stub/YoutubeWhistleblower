/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.transcription;

import java.net.URL;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author saber
 */
public class ReadXML {

    /**
     * Constructor par default
     */
    public ReadXML(){
    
    }
    /**
     * 
     * @param url 
     */     
    public String getTXT_XML(String url) {
        // TODO code application logic here
        String text_return="";
        //On crée une instance de SAXBuilder
	      SAXBuilder sxb = new SAXBuilder();
              try
                 {
   		  //On crée un nouveau document JDOM avec en argument l'URL du fichier XML
                  //Le parsing est terminé ;)
   		    URL Url = new URL(url);
                    Document  document = sxb.build(Url.openStream());
                    Element root = document.getRootElement(); 
                    List<Element> empListElements = root.getChildren("text");
                    for (Element empElement : empListElements) {
                        String text = empElement.getText();
                        text = text.replaceAll("&quot;", "\"");
                        text = text.replaceAll("&amp;", "&");
                        text = text.replaceAll("&#39;", "'");
                        text = text.replaceAll("&lt;", "<");
                        text = text.replaceAll("&gt;", ">");                          
                        
                        text_return = text_return+text+"\n";
                    }
                    
                 }
              catch(Exception e)
              {
                  text_return="";
              }
              return text_return.trim();
    }
    
}
